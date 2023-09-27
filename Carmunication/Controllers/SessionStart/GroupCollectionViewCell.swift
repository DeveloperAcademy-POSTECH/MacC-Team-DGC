//
//  GroupCollectionViewCell.swift
//  Carmunication
//
//  Created by 김태형 on 2023/09/25.
//

import UIKit

final class GroupCollectionViewCell: UICollectionViewCell {
    // 데이터들(groupImage, groupNameLabel)이 fileprivate이기 때문에 위 식을 통해 뷰 컨트롤러에 데이터 전달
    var groupData: GroupData? {
        didSet {
            guard let groupData = groupData else { return }
            groupImage.image = groupData.image
            groupNameLabel.text = groupData.groupName
        }
    }
    private let groupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            groupImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            groupImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            groupImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            groupNameLabel.topAnchor.constraint(equalTo: groupImage.bottomAnchor,
                                                constant: 12), // groupImage 아래에 배치하고 위쪽 간격 조정
            groupNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            groupNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            groupNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
