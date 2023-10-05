//
//  GroupDetailViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//
import SnapKit
import UIKit

final class GroupDetailViewController: UIViewController {

    let groupDetailView = GroupDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(groupDetailView)
        groupDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        groupDetailView.editButton.addTarget(self, action: #selector(dummyButtonAction), for: .touchUpInside)
        groupDetailView.quitButton.addTarget(self, action: #selector(dummyButtonAction), for: .touchUpInside)
    }
}

// MARK: - @objc Method
extension GroupDetailViewController {

    /**
     추후 그룹 해체 기능으로 사용될 액션 메서드
     */
    @objc private func dummyButtonAction() {}

    /**
     그룹 만들기 화면으로 넘어가는 액션 메서드
     */
    @objc private func moveToAddGroup() {
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

    func updateUIViewController(_ uiViewController: GroupDetailViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct GroupDetailViewPreview: PreviewProvider {

    static var previews: some View {
        GroupDetailViewControllerRepresentable()
    }
}
