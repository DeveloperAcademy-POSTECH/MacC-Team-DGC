//
//  FriendListTableViewCell.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/10.
//

import UIKit

final class FriendListTableViewCell: UITableViewCell {

    static let cellIdentifier = "friendListTableViewCell"

    // MARK: - 친구 프로필 이미지
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        if let profileImage = UIImage(named: "profile") {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = profileImage
            // TODO: - 이미지 프레임 추후 비율에 맞게 수정 필요
            let size = CGFloat(50)
            profileImageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
            profileImageView.layer.cornerRadius = size / 2
            profileImageView.clipsToBounds = true
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
        addSubview(profileImageView)
        addSubview(nicknameLabel)
    }

    func setAutoLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(24)
            make.width.height.equalTo(50)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
    }
}
