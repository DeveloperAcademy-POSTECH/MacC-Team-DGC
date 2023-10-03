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
    var startPoint = "울산"
    var endPoint = "C5"
    var startTime = "08:30"
    var crewCount = 4
}

final class SessionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var cellData: [DummyGroup] = [
        DummyGroup(groupTitle: "(주)좋좋소", subTitle: "회사"),
        DummyGroup(groupTitle: "김배찌", subTitle: "바지사장", isDriver: true)
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
            make.bottom.equalToSuperview()
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
            cell.backgroundColor = UIColor.semantic.backgroundSecond
            cell.layer.cornerRadius = 16

            cell.titleLabel.text = "\(cellData[indexPath.section].groupTitle)"
//            UIFont.CarmuFont.subhead3.applyFont(to: cell.titleLabel)
//            UIFont.CarmuFont.subhead1.applyFont(to: cell.subtitleLabel)

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

    private func mainTopButtonStack() -> UIStackView {
        let button2 = buttonComponent("새 그룹 만들기", 130, 40, .blue, .cyan)
        button2.addTarget(self, action: #selector(moveToAddGroup), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [button2])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }

    /**
     Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
     */
    private func mainStack() -> UIStackView {
        let stackView = mainTopButtonStack()
        let tableView = tableViewComponent()
        let mainStackView = UIStackView(arrangedSubviews: [tableView, stackView])
        mainStackView.axis = .vertical
        return mainStackView
    }
}

// MARK: - Component
extension SessionListViewController {

    private func tableViewComponent() -> UITableView {
        let tableView = UITableView()
        // UITableView 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        button.layer.cornerRadius = 20
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

final class CustomListTableViewCell: UITableViewCell {

    let leftImageView = UIImageView(image: UIImage(named: "ImCaptainButton"))
    let titleLabel = UILabel()
    let rightImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        contentView.addSubview(leftImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightImageView)

        leftImageView.contentMode = .scaleAspectFill
        titleLabel.font = UIFont.carmuFont.subhead3
        rightImageView.tintColor = UIColor.semantic.accPrimary
        // Add any additional setup for your labels and image views here
        // For example, you can set font, text color, content mode, etc.
    }

    private func setupConstraints() {
        let padding: CGFloat = 20
        let imageLabelSpacing: CGFloat = 8

        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(16)
            make.width.equalTo(45)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(leftImageView.snp.trailing).offset(imageLabelSpacing)
            make.centerY.equalTo(leftImageView.snp.centerY)
        }

        rightImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }
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
