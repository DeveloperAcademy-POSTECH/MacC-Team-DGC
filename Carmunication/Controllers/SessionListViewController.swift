//
//  SessionListViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

final class SessionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            let mainStackView = mainStack()
            view.addSubview(mainStackView)
            // Auto Layout 설정
            NSLayoutConstraint.activate([
                mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    // UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // 셀 개수 설정
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomListTableViewCell {
            // 셀에 Title, Subtitle, chevron 마크 설정
            cell.titleLabel.text = "Title \(indexPath.section + 1)"
            cell.subtitleLabel.text = "Subtitle \(indexPath.section + 1)"
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor(hexCode: "F1F3FF")
            cell.layer.cornerRadius = 20
            return cell
        } else {
            // 셀을 생성하는 데 실패한 경우, 기본 UITableViewCell을 반환.
            return UITableViewCell()
        }
    }
    // UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 선택 시 화면 전환 로직 구현
        let detailViewController = UIViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Stack
extension SessionListViewController {
    func mainTopButtonStack() -> UIStackView {
        let button1 = buttonComponent("받은 초대", 130, 40, .blue, .cyan)
        let button2 = buttonComponent("새 그룹 만들기", 130, 40, .blue, .cyan)
        button2.addTarget(self, action: #selector(moveToAddGroup), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [button1, spacer(), button2])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }
    /**
     Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
     */
    func mainStack() -> UIStackView {
        let tableView = tableViewComponent()
        let stackView = mainTopButtonStack()
        let mainStackView = UIStackView(arrangedSubviews: [stackView, tableView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        return mainStackView
    }
}

// MARK: - Component
extension SessionListViewController {
    func tableViewComponent() -> UITableView {
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
    func buttonComponent(_ title: String, _ width: CGFloat, _ height: CGFloat, _ fontColor: UIColor, _ backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(fontColor, for: .normal)
        button.setBackgroundImage(.pixel(ofColor: backgroundColor), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        return button
    }
    func spacer() -> UIView {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        return spacerView
    }
    @objc func moveToAddGroup() {
        let groudAddViewController = GroupAddViewController()
        groudAddViewController.title = "그룹 만들기"
        navigationController?.pushViewController(groudAddViewController, animated: true)
    }
    
}

extension UIImage {
  public static func pixel(ofColor color: UIColor) -> UIImage {
    let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

    UIGraphicsBeginImageContext(pixel.size)
    defer { UIGraphicsEndImageContext() }

    guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }

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
    func updateUIViewController(_ uiViewController: SessionListViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct SecondViewPreview: PreviewProvider {
    static var previews: some View {
        SessionListViewControllerRepresentable()
    }
}
