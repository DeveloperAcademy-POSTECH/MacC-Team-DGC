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

    // 셀에 대응하는 프로필 타입
    var profileType: ProfileType = .blue

    // 셀의 선택 여부에 따른 이미지 표시
    override var isSelected: Bool {
        didSet {
            if isSelected {
                // 선택됐을 때
                profileImageView.image = UIImage(selectedProfileType: profileType)
            } else {
                // 선택되지 않았을 때
                profileImageView.image = UIImage(profileType: profileType)
            }
        }
    }

    let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFit
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
