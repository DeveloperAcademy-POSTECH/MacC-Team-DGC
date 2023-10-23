//
//  GroupDetailViewController.swift
//  Carmu
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

final class GroupDetailViewController: UIViewController {

    var selectedGroup: Group?
    var pointList: [Point]?

    private let groupDetailView = GroupDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(groupDetailView)
        groupDetailView.selectedGroup = selectedGroup
        groupDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        groupDetailView.tableViewComponent.dataSource = self
        groupDetailView.tableViewComponent.delegate = self
        groupDetailView.crewExitButton.addTarget(self, action: #selector(crewExitButtonAction), for: .touchUpInside)
        navigationBarSetting()
    }
}

// MARK: - TableView 관련 Delegate 메서드
extension GroupDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let stopoverCount = selectedGroup?.stopoverCount else { return 2 }
        return stopoverCount == 0 ? 2 : (2 + stopoverCount)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stopoverCount = selectedGroup?.stopoverCount else { return UITableViewCell() }
        guard let pointList = pointList else { return UITableViewCell() }

        let cell = GroupDetailTableViewCell(
            index: CGFloat(indexPath.row),
            cellCount: CGFloat(stopoverCount + 2)
        )
        // TODO: - 셀 데이터 입력 부분. 리팩토링 필요
        cell.crewCount = 3
        switch indexPath.row {
        case 0:
            cell.pointNameLabel.text = "출발지"
            cell.pointName.text = pointList[0].pointName
            cell.detailAddress.text = pointList[0].pointDetailAddress ?? "출발지의 상세주소"
            cell.timeLabel.text = Date.formatTime(pointList[0].pointArrivalTime)
        case (stopoverCount + 1):
            cell.pointNameLabel.text = "도착지"
            cell.pointName.text = pointList.last?.pointName
            cell.detailAddress.text = pointList.last?.pointDetailAddress ?? "도착지의 상세주소"
            cell.timeLabel.text = Date.formatTime(pointList.last?.pointArrivalTime)
        default:
            cell.pointNameLabel.text = "경유지 \(indexPath.row)"
            cell.pointName.text = pointList[indexPath.row].pointName
            cell.detailAddress.text = pointList[indexPath.row].pointDetailAddress ?? "경유지의 상세주소"
            cell.timeLabel.text = Date.formatTime(pointList[indexPath.row].pointArrivalTime)
        }
        cell.boardingCrewLabel.text = "탑승 크루"

        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

// MARK: - Component & Stacks
extension GroupDetailViewController {

    private func backButton() -> UIBarButtonItem {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        return backButton
    }

    private func navigationBarSetting() {
        navigationController?.navigationBar.tintColor = UIColor.semantic.accPrimary
        navigationItem.leftBarButtonItem = backButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editButtonAction)
        )
    }
}

// MARK: - @objc Method
extension GroupDetailViewController {

    /**
     추후 그룹 해체 기능으로 사용될 액션 메서드
     */
    @objc private func crewExitButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    /**
     크루 편집 화면으로 들어가는 메서드
     */
    @objc private func editButtonAction() {
        let groupAddViewController = GroupAddViewController() // 추후 EditView 따로 만들어서 관리해야 함.
        present(groupAddViewController, animated: true)
    }

    /**
     backButton을 누를 때 적용되는 액션 메서드
     */
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Preview canvas 세팅
import SwiftUI

struct GroupDetailViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = GroupDetailViewController

    func makeUIViewController(context: Context) -> GroupDetailViewController {
        return GroupDetailViewController()
    }

    func updateUIViewController(_ uiViewController: GroupDetailViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct GroupDetailViewPreview: PreviewProvider {

    static var previews: some View {
        GroupDetailViewControllerRepresentable()
    }
}
