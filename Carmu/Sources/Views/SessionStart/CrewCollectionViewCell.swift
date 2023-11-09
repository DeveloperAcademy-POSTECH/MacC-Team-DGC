//
//  CrewCollectionViewCell.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/09.
//

import UIKit

import SnapKit

final class CrewCollectionViewCell: UICollectionViewCell {

    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.semantic.textEnabled
        label.font = UIFont.carmuFont.body3
        return label
    }()
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.semantic.textTertiary
        label.font = UIFont.carmuFont.body3
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(statusLabel)
        addSubview(profileImageView)
        addSubview(userNameLabel)
        profileImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(48)
        }
        statusLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.top).offset(-4)
            make.centerX.equalToSuperview()
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
