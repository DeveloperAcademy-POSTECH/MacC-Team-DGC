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
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let personNameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.textAlignment = .center
        label.textColor = .black // 원하는 텍스트 색상으로 설정
        label.font = UIFont.systemFont(ofSize: 14) // 원하는 폰트 및 크기로 설정
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(personImage)
        personImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        contentView.addSubview(personNameLabel)
        personNameLabel.snp.makeConstraints { make in
            make.top.equalTo(personImage.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
