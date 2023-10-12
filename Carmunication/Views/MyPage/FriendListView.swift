//
//  FriendListView.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/10.
//

import UIKit

final class FriendListView: UIView {

    // MARK: - 친구 목록 테이블 뷰
    lazy var friendListTableView: UITableView = {
        let friendListTableView = UITableView()
        friendListTableView.separatorStyle = .none
        friendListTableView.showsVerticalScrollIndicator = false
        return friendListTableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        setupViews()
        setAutoLayout()
    }

    func setupViews() {
        addSubview(friendListTableView)
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
        friendListTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}
