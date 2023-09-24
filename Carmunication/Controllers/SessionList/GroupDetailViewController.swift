//
//  GroupDetailViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

class GroupDetailViewController: UIViewController {
    var selectedGroup: DummyGroup?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let mainStackView = mainStack()
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    /**
     Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
     */
    func mainStack() -> UIStackView {
        let stackView = selectedGroup?.isDriver ?? false ? driverBottomButtonStack() : crewBottomButtonStack()
        let mainStackView = UIStackView(arrangedSubviews: [distanceLabel(), stackView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        return mainStackView
    }
    func distanceLabel() -> UIStackView {
        let label1 = UILabel()
        let label2 = UILabel()
        label1.text = "크루가 함께한 주행거리"
        label2.text = "\("0000") km"
        let stackView = UIStackView(arrangedSubviews: [label1, spacer(), label2])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }
    func driverBottomButtonStack() -> UIStackView {
        let button1 = buttonComponent("그만 두기", 130, 40, .blue, .cyan)
        let button2 = buttonComponent("수정 하기", 130, 40, .blue, .cyan)
        button2.addTarget(self, action: #selector(dummyButtonAction), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [button1, spacer(), button2])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }
    func crewBottomButtonStack() -> UIStackView {
        let button = buttonComponent("그만 두기", .greatestFiniteMagnitude, 60, .blue, .cyan)
        button.addTarget(self, action: #selector(dummyButtonAction), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }
    @objc func dummyButtonAction() {
    }
    func buttonComponent(_ title: String, _ width: CGFloat, _ height: CGFloat,
                         _ fontColor: UIColor, _ backgroundColor: UIColor) -> UIButton {
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

// MARK: - Preview canvas 세팅
import SwiftUI

struct GroupDetailViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = GroupDetailViewController
    func makeUIViewController(context: Context) -> GroupDetailViewController {
        return GroupDetailViewController()
    }
    func updateUIViewController(_ uiViewController: GroupDetailViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct GroupDetailViewPreview: PreviewProvider {
    static var previews: some View {
        GroupDetailViewControllerRepresentable()
    }
}
