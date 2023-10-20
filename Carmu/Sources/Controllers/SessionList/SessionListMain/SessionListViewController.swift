//
//  SessionListViewController.swift
//  Carmu
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

import SnapKit

final class SessionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var cellData: [DummyGroup] = [
        DummyGroup(
            groupTitle: "(주)좋좋소",
            subTitle: "회사",
            startPoint: "배찌의 스윗한 홈",
            endPoint: "칠포2리 간이해수욕장",
            crewCount: 3
        )
    ]

    private let sessionListView = SessionListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(sessionListView)
        sessionListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        sessionListView.addNewGroupButton.addTarget(self, action: #selector(moveToAddGroup), for: .touchUpInside)

        sessionListView.tableViewComponent.dataSource = self
        sessionListView.tableViewComponent.delegate = self
    }
}

// MARK: - TableView Method
extension SessionListViewController {
    // UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // 셀 개수 설정
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return cellData.count == 0 ? 1 : cellData.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellData.isEmpty {
            // cellData가 비어있을 때 NotFoundCrewTableViewCell을 반환
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "notFoundCell",
                for: indexPath
            ) as? NotFoundCrewTableViewCell {
                return cell
            }
        } else {
            // cellData가 비어있지 않을 때 기존의 CustomListTableViewCell을 반환
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as? CustomListTableViewCell {
                let cellData = cellData[indexPath.row]
                cell.groupName.text = "\(cellData.groupTitle)"
                cell.startPointLabel.text = "\(cellData.startPoint)"
                cell.endPointLabel.text = "\(cellData.endPoint)"
                cell.startTimeLabel.text = "\(cellData.startTime)"
                cell.isCaptainBadge.image = {
                    if !cellData.isDriver {
                        UIImage(named: "ImCrewButton")
                    } else {
                        UIImage(named: "ImCaptainButton")
                    }
                }()
                cell.crewCount = cellData.crewCount
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 선택 시 화면 전환 로직 구현
        let selectedGroup = cellData[indexPath.section]
        let detailViewController = GroupDetailViewController()

        detailViewController.selectedGroup = selectedGroup
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Component
extension SessionListViewController {

    @objc private func moveToAddGroup() {
        let groudAddViewController = GroupAddViewController()
        groudAddViewController.title = "크루 만들기"
        navigationController?.pushViewController(groudAddViewController, animated: true)
    }
}

// MARK: - Preview canvas 세팅
import SwiftUI

struct SessionListViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = SessionListViewController

    func makeUIViewController(context: Context) -> SessionListViewController {
        return SessionListViewController()
    }

    func updateUIViewController(_ uiViewController: SessionListViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct SecondViewPreview: PreviewProvider {

    static var previews: some View {
        SessionListViewControllerRepresentable()
    }
}
