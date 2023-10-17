//
//  GroupAddViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

final class GroupAddViewController: UIViewController {

    var groupDataModel: Group = Group()
    var pointsDataModel: [Point2] = []
    let groupAddView = GroupAddView()
    private var shouldPopViewController = true

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.backgroundColor = UIColor.semantic.backgroundDefault
        view.addGestureRecognizer(tapGesture)
        navigationBarSetting()

        groupAddView.tableViewComponent.dataSource = self
        groupAddView.tableViewComponent.delegate = self
        groupAddView.textField.delegate = self

        groupAddView.stopoverPointAddButton.addTarget(
            self,
            action: #selector(addStopoverPointTapped),
            for: .touchUpInside
        )
        groupAddView.crewCreateButton.addTarget(
            self,
            action: #selector(createCrewButtonTapped),
            for: .touchUpInside
        )
        view.addSubview(groupAddView)
        groupAddView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        for index in 0...2 {
            pointsDataModel.append(Point2(pointSequence: index))
        }
    }
}

// MARK: - @objc Method
extension GroupAddViewController {

    @objc private func addStopoverPointTapped() {
        let insertIndex = pointsDataModel.count - 1
        self.pointsDataModel.insert(
            Point2(pointSequence: insertIndex),
            at: insertIndex
        )
        if pointsDataModel.count >= 5 {
            groupAddView.stopoverPointAddButton.isEnabled = false
            groupAddView.stopoverPointAddButton.isHidden = true
        }
        groupAddView.tableViewComponent.reloadData()
    }

    @objc func stopoverRemoveButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? GroupAddTableViewCell,
              let indexPath = self.groupAddView.tableViewComponent.indexPath(for: cell) else {
            return
        }

        pointsDataModel.remove(at: indexPath.row)
        if pointsDataModel.count <= 5 {
            groupAddView.stopoverPointAddButton.isEnabled = true
            groupAddView.stopoverPointAddButton.isHidden = false
        }
        groupAddView.tableViewComponent.reloadData()
    }

    @objc private func addBoardingCrewButtonTapped(_ sender: UIButton) {
        let detailViewController = SelectBoardingCrewModalViewController()
        present(detailViewController, animated: true)
    }

    @objc private func setStartTimeButtonTapped(_ sender: UIButton) {
        let detailViewController = SelectStartTimeViewController()

        // 클로저를 통해 선택한 시간을 받음
        detailViewController.timeSelectionHandler = { [weak self] selectedTime in
            // 선택한 시간을 사용하여 원하는 작업 수행
            if let cell = sender.superview?.superview as? GroupAddTableViewCell,
               let indexPath = self?.groupAddView.tableViewComponent.indexPath(for: cell) {
                self?.pointsDataModel[indexPath.row].pointArrivalTime = selectedTime
                // 이제 선택한 시간이 `Point2` 모델에 저장됩니다.
            }
            self?.groupAddView.tableViewComponent.reloadData()
        }
        present(detailViewController, animated: true)
    }

    @objc func findAddressButtonTapped(_ sender: UIButton) {
        let detailViewController = SelectAddressViewController()
        let navigation = UINavigationController(rootViewController: detailViewController)
        guard let cell = sender.superview?.superview as? GroupAddTableViewCell,
              let indexPath = groupAddView.tableViewComponent.indexPath(for: cell) else {
            return
        }
        let row = indexPath.row

        detailViewController.selectAddressView.headerTitleLabel.text = {
            switch row {
            case 0:
                return "출발지 주소 설정"
            case (self.groupAddView.tableViewComponent.numberOfRows(inSection: 0) ?? 2) - 1:
                return "도착지 주소 설정"
            default:
                return "경유지\(row) 주소 설정"
            }
        }()

        detailViewController.addressSelectionHandler = { [weak self] addressDTO in
            self?.pointsDataModel[row].pointName = addressDTO.pointName
            self?.pointsDataModel[row].pointDetailAddress = addressDTO.pointDetailAddress
            self?.pointsDataModel[row].pointLat = addressDTO.pointLat
            self?.pointsDataModel[row].pointLng = addressDTO.pointLng
            self?.groupAddView.tableViewComponent.reloadData()
        }

        present(navigation, animated: true)
    }

    @objc private func createCrewButtonTapped(_ sender: UIButton) {
        checkDataEffectiveness()
        if shouldPopViewController {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let okButton = UIAlertAction(
            title: "확인",
            style: .default
        )

        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

// MARK: - Custom Method
extension GroupAddViewController {

    private func checkDataEffectiveness() {
        if emptyDataCheck() {
            timeEffectivenessCheck()
        }
        shouldPopViewController = true
    }

    // 빈 값을 체크해주는 메서드
    private func emptyDataCheck() -> Bool {
        // TODO: 빈 값 체크
        for element in pointsDataModel {
            let pointName = returnPointName(element.pointSequence ?? 0)

            if element.pointArrivalTime == nil {
                showAlert(title: "시간을 설정하지 않았어요!", message: "\(pointName)의 시간을 입력해주세요!")
                shouldPopViewController = false
                return false
            }

            if element.pointName == nil {
                showAlert(title: "주소를 설정하지 않았어요!", message: "\(pointName)의 주소를 설정해주세요!")
                shouldPopViewController = false
                return false
            }
//            guard let boardingCrew = element.boardingCrew else {
//                showAlert(
//                    title: "탑승 크루를 선택하지 않았어요!",
//                    message:
//                    """
//                    \(pointName)의 탑승자를 선택하지 않았어요.
//                    없다면 포인트를 삭제해주세요!
//                    출발지인 경우, 본인을 꼭 포함해야 합니다.
//                    """
//                )
//                shouldPopViewController = false
//                return false
//            }
        }
        return true
    }

    // 시간 유효성을 체크해주는 메서드
    private func timeEffectivenessCheck() {
        for (index, element) in pointsDataModel.enumerated() {
            if index == 0 { continue }

            let pointName = returnPointName(index)
            let beforeTime = pointsDataModel[index - 1].pointArrivalTime?.timeIntervalSince1970 ?? 0
            let currentTime = element.pointArrivalTime?.timeIntervalSince1970 ?? 0

            if beforeTime >= currentTime {
                showAlert(
                    title: "시간을 다시 설정해주세요!",
                    message:
                        """
                        \(pointName)의 도착시간이
                        이전 경유지의 도착시간보다
                        빠르게 설정되어 있습니다.
                        다시 설정해주세요!
                        """
                )
                shouldPopViewController = false
                return
            }
        }
    }

    private func returnPointName(_ index: Int) -> String {
        let pointName = {
            if index == 0 {
                return "출발지"
            } else if index == self.pointsDataModel.count - 1 {
                return "도착지"
            } else {
                return "경유지\(index)"
            }
        }()

        return pointName
    }
}

// MARK: - UITableViewDataSource Method
extension GroupAddViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointsDataModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GroupAddTableViewCell(
            index: CGFloat(indexPath.row),
            cellCount: CGFloat(pointsDataModel.count)
        )
        cell.addressSearchButton.addTarget(self, action: #selector(findAddressButtonTapped), for: .touchUpInside)
        cell.crewImageButton.addTarget(self, action: #selector(addBoardingCrewButtonTapped), for: .touchUpInside)
        cell.startTime.addTarget(self, action: #selector(setStartTimeButtonTapped), for: .touchUpInside)
        cell.stopoverPointRemoveButton.addTarget(
            self,
            action: #selector(stopoverRemoveButtonTapped),
            for: .touchUpInside
        )

        if indexPath.row == 0 || indexPath.row == pointsDataModel.count - 1 {
            cell.stopoverPointRemoveButton.isEnabled = false
            cell.stopoverPointRemoveButton.isHidden = true
            cell.pointNameLabel.text = indexPath.row == 0 ? "출발지" : "도착지"
            cell.timeLabel.text = indexPath.row == 0 ? "출발시간" : "도착시간"
        } else {
            cell.pointNameLabel.text = "경유지 \(indexPath.row)"
        }

        if let pointName = pointsDataModel[indexPath.row].pointName {
            cell.addressSearchButton.setTitle("    \(pointName)", for: .normal)
        }
        if let startTime = pointsDataModel[indexPath.row].pointArrivalTime {
            let formattedTime = Date.formattedDate(from: startTime, dateFormat: "a hh:mm")
            cell.startTime.setTitle(formattedTime, for: .normal)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate Method
extension GroupAddViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - Component
extension GroupAddViewController {

    private func navigationBarSetting() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationController?.navigationBar.tintColor = UIColor.semantic.accPrimary
        navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: - UITextFieldDelegate Method
extension GroupAddViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return true
    }

    // 텍스트 필드에서 리턴 키를 누를 때 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // 화면의 다른 곳을 탭할 때 호출되는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Previewer
import SwiftUI

struct GroupAddViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = GroupAddViewController

    func makeUIViewController(context: Context) -> GroupAddViewController {
        return GroupAddViewController()
    }

    func updateUIViewController(_ uiViewController: GroupAddViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct GroupAddViewControllerPreview: PreviewProvider {

    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }
}
