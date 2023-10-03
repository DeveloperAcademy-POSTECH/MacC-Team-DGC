//
//  SessionListViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//
import SnapKit
import UIKit

struct DummyGroup {
    var groupTitle: String = "(주)좋좋소"
    var subTitle: String = "늦으면 큰일이 나요"
    var isDriver: Bool = false
    var startPoint = "출발지"
    var endPoint = "도착지"
    var startTime = "08:30"
    var crewCount = 4
}

final class SessionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var cellData: [DummyGroup] = [
        DummyGroup(
            groupTitle: "(주)좋좋소",
            subTitle: "회사",
            startPoint: "배찌의 스윗한 홈",
            endPoint: "칠포2리 간이해수욕장",
            crewCount: 3
        ),
        DummyGroup(
            groupTitle: "김배찌",
            subTitle: "바지사장",
            isDriver: true
        ),
        DummyGroup(
            groupTitle: "환장의 카풀",
            startPoint: "서울시 봉천동",
            endPoint: "부산광역시 남천동 살제",
            startTime: "13:30",
            crewCount: 2
        ),
        DummyGroup(
            groupTitle: "환장의 카풀",
            startPoint: "서울시 봉천동",
            endPoint: "부산광역시 남천동 살제",
            startTime: "13:30",
            crewCount: 2
        ),
        DummyGroup(
            groupTitle: "환장의 카풀",
            startPoint: "서울시 봉천동",
            endPoint: "부산광역시 남천동 살제",
            startTime: "13:30",
            crewCount: 2
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
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
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as? CustomListTableViewCell {
            // 셀에 Title, Subtitle, chevron 마크 설정
            let cellData = cellData[indexPath.section]
            cell.backgroundColor = UIColor.semantic.backgroundSecond
            cell.layer.cornerRadius = 16
            cell.titleLabel.text = "\(cellData.groupTitle)"
            cell.startPointLabel.text = "\(cellData.startPoint)"
            cell.endPointLabel.text = "\(cellData.endPoint)"
            cell.startTimeLabel.text = "\(cellData.startTime)"
            cell.leftImageView.image = {
                if !cellData.isDriver {
                    UIImage(named: "ImCrewButton")
                } else {
                    UIImage(named: "ImCaptainButton")
                }
            }()
            cell.crewCount = cellData.crewCount
            return cell
        } else {
            return UITableViewCell()
        }
    }

    // UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 선택 시 화면 전환 로직 구현
        let selectedGroup = cellData[indexPath.section]
        let detailViewController = GroupDetailViewController()

        detailViewController.title = cellData[indexPath.section].groupTitle
        detailViewController.selectedGroup = selectedGroup
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Stack
extension SessionListViewController {

    private func mainTopButtonStack() -> UIButton {
        let button2 = buttonComponent("+ 새 그룹 만들기", 174, 62, UIColor.semantic.textSecondary!, UIColor.semantic.accPrimary!)
        button2.titleLabel?.font = UIFont.carmuFont.subhead3
        button2.addTarget(self, action: #selector(moveToAddGroup), for: .touchUpInside)
        return button2
    }

    /**
     Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
     */
    private func mainStack() -> UIStackView {
        let stackView = mainTopButtonStack()
        let tableView = tableViewComponent()
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        // TableView를 최대한 확장하고 버튼을 아래에 추가합니다.
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(stackView)
        stackView.backgroundColor = .clear
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
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
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }

    private func buttonComponent(
        _ title: String,
        _ width: CGFloat,
        _ height: CGFloat,
        _ fontColor: UIColor,
        _ backgroundColor: UIColor
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

    private func spacer() -> UIView {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false

        return spacerView
    }

    @objc private func moveToAddGroup() {
        let groudAddViewController = GroupAddViewController()
        groudAddViewController.title = "그룹 만들기"
        navigationController?.pushViewController(groudAddViewController, animated: true)
    }
}

extension UIImage {

    public static func pixel(ofColor color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(pixel.size)

        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        context.setFillColor(color.cgColor)
        context.fill(pixel)

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
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
