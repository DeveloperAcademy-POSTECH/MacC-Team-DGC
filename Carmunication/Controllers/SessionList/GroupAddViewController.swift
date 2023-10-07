//
//  GroupAddViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

struct AddressAndTime {
    var address: String = "포항시 남구 지곡로 80"
    var time: String = "09:30"
}

final class GroupAddViewController: UIViewController {

    private var cellData: [AddressAndTime] = [
        AddressAndTime(address: "C5", time: "08:30"),
        AddressAndTime(address: "가속기", time: "09:30"),
        AddressAndTime(address: "울산", time: "10:30"),
        AddressAndTime(address: "서울", time: "14:30")
    ]

    private let groupAddView = GroupAddView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        navigationBarSetting()
        groupAddView.tableViewComponent.dataSource = self
        groupAddView.tableViewComponent.delegate = self
        groupAddView.textField.delegate = self

        groupAddView.stopoverPointAddButton.addTarget(
            self,
            action: #selector(addStopoverPointTapped),
            for: .touchUpInside
        )

        view.addSubview(groupAddView)

        groupAddView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - tableView protocol Method
extension GroupAddViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = GroupAddTableViewCell(
            index: CGFloat(indexPath.row),
            cellCount: CGFloat(cellData.count)
        )
        cell.crewCount = 3
        cell.addressSearchButton.addTarget(self, action: #selector(findAddressButtonTapped), for: .touchUpInside)
        cell.crewImageButton.addTarget(self, action: #selector(addBoardingCrewButtonTapped), for: .touchUpInside)
        cell.startTime.addTarget(self, action: #selector(setStartTimeButtonTapped), for: .touchUpInside)
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

    /**
     backButton을 누를 때 적용되는 액션 메서드
     */
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func findAddressButtonTapped() {
        let detailViewController = SelectPointMapViewController()
        detailViewController.title = "장소 선택"
        detailViewController.modalPresentationStyle = .fullScreen

        present(detailViewController, animated: true)
    }
}

// MARK: - @objc Method
extension GroupAddViewController {

    /**
     버튼이 눌린 section을 식별하거나 다른 작업 수행
     */
    @objc private func buttonTapped(_ sender: UIButton) {

        let section = sender.tag
        cellData.remove(at: section)
        groupAddView.tableViewComponent.reloadData()
    }

    @objc private func addStopoverPointTapped() {

        cellData.insert(AddressAndTime(address: "새로 들어온 데이터", time: "12:30"), at: cellData.count - 1)
        groupAddView.tableViewComponent.reloadData()
    }

    @objc private func addBoardingCrewButtonTapped(_ sender: UIButton) {
        print("탑승자 추가 버튼 클릭")
    }

    @objc private func setStartTimeButtonTapped(_ sender: UIButton) {
        print("도착 시간 버튼 클릭")
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
