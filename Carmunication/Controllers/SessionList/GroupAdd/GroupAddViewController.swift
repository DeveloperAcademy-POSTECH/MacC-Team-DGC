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

// MARK: - tableView protocol Method
extension GroupAddViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointsDataModel.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
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
        print(pointsDataModel.count)
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

        print(pointsDataModel)
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        // 특정 조건을 만족하는 경우에만 셀을 선택 가능하도록 설정
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

        print("삭제한 줄 : ", indexPath.row)
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
            print("navigation Handler 내부")
            print(addressDTO)
            self?.pointsDataModel[row].pointName = addressDTO.pointName
            self?.pointsDataModel[row].pointDetailAddress = addressDTO.pointDetailAddress
            self?.pointsDataModel[row].pointLat = addressDTO.pointLat
            self?.pointsDataModel[row].pointLng = addressDTO.pointLng
            self?.groupAddView.tableViewComponent.reloadData()
        }

        present(navigation, animated: true)
    }

    @objc private func createCrewButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

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
        // 키보드를 내립니다.
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
