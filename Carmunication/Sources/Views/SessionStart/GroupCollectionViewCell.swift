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
    var groupData: Group? {
        didSet {
            guard let groupData = groupData else {
                groupImage.image = UIImage(named: "defaultStoryImage") // 기본 이미지 설정
                groupNameLabel.text = "---"
                return
            }

            // TODO: - 추후 systemName을 named로 변경
            if let imageString = groupData.groupImage, let image = UIImage(systemName: imageString) {
                groupImage.image = image
            } else {
                groupImage.contentMode = .scaleAspectFit
                groupImage.clipsToBounds = true
                groupImage.image = UIImage(named: "defaultStoryImage")
            }

            if let groupName = groupData.groupName {
                groupNameLabel.text = groupName
            } else {
                groupNameLabel.text = "---"
                groupNameLabel.textColor = UIColor.semantic.textBody
            }
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

        contentView.addSubview(groupImage)
        groupImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        contentView.addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints { make in
            make.top.equalTo(groupImage.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
