//
//  ProfileTypeCollectionViewCell.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/03.
//

import UIKit

// MARK: - 프로필 이미지 수정 화면에서 프로필 타입을 선택하기 위한 컬렉션 뷰 셀
final class ProfileTypeCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "profileTypeCollectionViewCell"

    let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = .yellow
        return profileImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupProfileImageView() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
