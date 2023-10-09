//
//  GroupAddModalCollectionViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

import SnapKit

class GroupAddModalCollectionViewCell: UICollectionViewCell {

    let personImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        return imageView
    }()

    let personNameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.textAlignment = .center
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.body1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(personImage)
        personImage.snp.makeConstraints { make in
            make.width.height.equalTo(45)
        }

        contentView.addSubview(personNameLabel)
        personNameLabel.snp.makeConstraints { make in
            make.top.equalTo(personImage.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(45)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
