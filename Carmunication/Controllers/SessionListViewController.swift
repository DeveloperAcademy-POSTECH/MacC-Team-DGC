//
//  SessionListViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//
import SnapKit
import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainStackView = mainStack()
        view.backgroundColor = .systemBackground
        view.addSubview(mainStackView)

        // Auto Layout 설정
        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
        }
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

// MARK: - Stack
extension SessionListViewController {

    // TODO: - 뒷 배경 흐리게 하여 뒷 셀 보이도록 처리하기
    private func addNewGroupButton() -> UIStackView {
        let stackView = UIStackView()
        let button = buttonComponent(
            title: "+ 새 그룹 만들기",
            width: 174,
            height: 62,
            fontColor: UIColor.semantic.textSecondary!,
            backgroundColor: UIColor.semantic.accPrimary!
        )
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.addTarget(self, action: #selector(moveToAddGroup), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        return stackView
    }

    // Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
    private func mainStack() -> UIStackView {
        let mainStackView = UIStackView()
        let stackView = addNewGroupButton()
        let tableView = tableViewComponent()
        mainStackView.axis = .vertical
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(stackView)

        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom).offset(16)
        }

        return mainStackView
    }
}

// MARK: - Component
extension SessionListViewController {

    private func tableViewComponent() -> UITableView {
        let tableView = UITableView()
        // UITableView 설정
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(NotFoundCrewTableViewCell.self, forCellReuseIdentifier: "notFoundCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }

    private func buttonComponent(
        title: String,
        width: CGFloat,
        height: CGFloat,
        fontColor: UIColor,
        backgroundColor: UIColor
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(fontColor, for: .normal)
        button.setBackgroundImage(.pixel(ofColor: backgroundColor), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }

        return button
    }

    @objc private func moveToAddGroup() {
        let groudAddViewController = GroupAddViewController()
        groudAddViewController.title = "그룹 만들기"
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
