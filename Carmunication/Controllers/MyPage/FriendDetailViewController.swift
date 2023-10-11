//
//  FriendDetailViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/11.
//

import UIKit

final class FriendDetailViewController: UIViewController {

    private let friendDetailView = FriendDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.tintColor = UIColor.semantic.textSecondary

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "친구삭제",
            style: .plain,
            target: self,
            action: #selector(showDeleteFriendAlert)
        )

        view.addSubview(friendDetailView)
        friendDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc 메서드
extension FriendDetailViewController {

    // [친구삭제] 버튼 클릭 시 알럿 띄우기
    @objc private func showDeleteFriendAlert() {
        let deleteAlertController = UIAlertController(
            title: "친구를 삭제하시겠어요?",
            message: nil,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let performDelete = UIAlertAction(title: "삭제", style: .destructive)
        deleteAlertController.addAction(cancel)
        deleteAlertController.addAction(performDelete)
        self.present(deleteAlertController, animated: true)
    }
}
