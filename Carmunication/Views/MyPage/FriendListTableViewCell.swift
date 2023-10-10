//
//  FriendListTableViewCell.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/10.
//

import UIKit

final class FriendListTableViewCell: UITableViewCell {

    // MARK: - 프로필 스택
    lazy var profileStack: UIStackView = {
        let profileStack = UIStackView()
        profileStack.axis = .horizontal
        profileStack.alignment = .center
        return profileStack
    }()

    // MARK: - 친구 프로필 이미지
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        if let profileImage = UIImage(named: "profile") {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = profileImage
        }
        return profileImageView
    }()

    // MARK: - 친구 닉네임 라벨
    lazy var nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.font = UIFont.carmuFont.subhead3
        nicknameLabel.textColor = UIColor.semantic.textPrimary
        return nicknameLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setAutoLayout()

        // 셀 배경색 설정
        self.backgroundColor = UIColor.semantic.backgroundSecond
        self.layer.cornerRadius = 16
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setAutoLayout()
    }

    func setupViews() {
        addSubview(profileStack)

        profileStack.addArrangedSubview(profileImageView)
        profileStack.addArrangedSubview(nicknameLabel)
    }

    func setAutoLayout() {
        profileStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(170)
        }
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(50)
            make.trailing.equalTo(nicknameLabel.snp.leading).offset(-12)
        }
    }
}
