//
//  FriendListViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

final class FriendListViewController: UIViewController {

    let dummyFriends = ["홍길동", "우니", "배찌", "젠", "레이", "테드", "젤리빈", "김영빈", "피카츄"]
    private let friendListView = FriendListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "친구관리"
        view.addSubview(friendListView)
        friendListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 재사용 셀 등록
        friendListView.friendListTableView.register(
            FriendListTableViewCell.self,
            forCellReuseIdentifier: "friendListTableViewCell"
        )
        friendListView.friendListTableView.dataSource = self
        friendListView.friendListTableView.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "친구추가",
            style: .plain,
            target: self,
            action: #selector(showFriendAddView)
        )
        let backButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.semantic.accPrimary
    }
}

// MARK: @objc 메서드
extension FriendListViewController {

    // [친구추가] 내비게이션 바 버튼 클릭 시 동작
    @objc private func showFriendAddView() {
        let friendAddVC = FriendAddViewController()
        friendAddVC.modalPresentationStyle = .formSheet

        self.present(friendAddVC, animated: true)
    }
}

// MARK: - UITableViewDataSource 델리게이트 구현
extension FriendListViewController: UITableViewDataSource {

    // 섹션 당 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummyFriends.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    // 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "friendListTableViewCell",
            for: indexPath
        ) as? FriendListTableViewCell else {
            return UITableViewCell()
        }
        // TODO: - 셀에 친구 정보 넣어주기
        cell.nicknameLabel.text = dummyFriends[indexPath.section]
        let chevronImage = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImage.tintColor = UIColor.semantic.textBody
        cell.accessoryView = chevronImage
        return cell
    }
}

// MARK: - UITableViewDelegate 델리게이트 구현
extension FriendListViewController: UITableViewDelegate {

    // 각 섹션 사이의 간격
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    // 각 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    // 테이블 뷰 셀을 눌렀을 때에 대한 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - 친구 상세보기 페이지로 이동 구현하기
        let friendDetailVC = FriendDetailViewController()
        navigationController?.pushViewController(friendDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FriendListViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FriendListViewController
    func makeUIViewController(context: Context) -> FriendListViewController {
        return FriendListViewController()
    }
    func updateUIViewController(_ uiViewController: FriendListViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct FriendListViewPreview: PreviewProvider {
    static var previews: some View {
        FriendListViewControllerRepresentable()
    }
}
