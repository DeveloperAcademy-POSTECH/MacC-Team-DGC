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
    }
}

// MARK: - 테이블 뷰 관련 델리게이트 구현
extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {

    // 섹션 당 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummyFriends.count
    }

    // 각 섹션 사이의 간격
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    // 각 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    // 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "friendListTableViewCell",
            for: indexPath
        ) as? FriendListTableViewCell {
            // TODO: - 셀에 친구 정보 넣어주기
            cell.nicknameLabel.text = dummyFriends[indexPath.section]
            return cell
        }
        return UITableViewCell()
    }

    // 테이블 뷰 셀을 눌렀을 때에 대한 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - 친구 상세보기 페이지로 이동 구현하기
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
