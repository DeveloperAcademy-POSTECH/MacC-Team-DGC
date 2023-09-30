//
//  GroupCollectionViewCell.swift
//  Carmunication
//
//  Created by 김태형 on 2023/09/25.
//

import UIKit

import SnapKit

final class GroupCollectionViewCell: UICollectionViewCell {
    // 위 식을 통해 뷰 컨트롤러에 데이터 전달
    var groupData: GroupData? {
        didSet {
            guard let groupData = groupData else { return }
            groupImage.image = groupData.image
            groupNameLabel.text = groupData.groupName
        }
    }

    private let groupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black // 원하는 텍스트 색상으로 설정
        label.font = UIFont.systemFont(ofSize: 14) // 원하는 폰트 및 크기로 설정
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setGroupCollectionViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GroupCollectionViewCell {
    // 셀 레이아웃 설정
    private func setGroupCollectionViewCell() {
        contentView.addSubview(groupImage)
        contentView.addSubview(groupNameLabel)
        groupImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        groupNameLabel.snp.makeConstraints { make in
            make.top.equalTo(groupImage.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
