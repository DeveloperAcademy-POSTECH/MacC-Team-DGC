//
//  ProfileChangeView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/02.
//

import UIKit

final class ProfileChangeView: UIView {

    // MARK: - 프로필 설정 모달 상단 바
    private let headerBar: UIView = {
        let headerStackView = UIView()
        return headerStackView
    }()

    // 상단 바 제목
    private let headerTitleLabel: UILabel = {
        let headerTitleLabel = UILabel()
        headerTitleLabel.text = "프로필 변경"
        headerTitleLabel.textAlignment = .center
        // TODO: 폰트 적용 필요
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        headerTitleLabel.textColor = UIColor.semantic.textPrimary
        return headerTitleLabel
    }()

    // 모달 닫기 버튼
    private let closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.semantic.accPrimary
        return closeButton
    }()

    private let guideLabel: UILabel = {
        let guideLabel = UILabel()
        guideLabel.text = "변경할 프로필을 선택하세요"
        guideLabel.font = UIFont.carmuFont.headline2
        guideLabel.textColor = UIColor.semantic.textPrimary
        return guideLabel
    }()

    // 프로필 타입 선택 콜렉션 뷰
    let profileCollectionView: UICollectionView = {
        let profileCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        profileCollectionView.backgroundColor = .gray
        return profileCollectionView
    }()

    // 저장 버튼
    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.backgroundColor = UIColor.semantic.accPrimary
        saveButton.setTitle("저장", for: .normal)
        saveButton.titleLabel?.font = UIFont.carmuFont.headline2
        saveButton.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        saveButton.layer.cornerRadius = 30
        return saveButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(headerBar)
        headerBar.addSubview(headerTitleLabel)
        headerBar.addSubview(closeButton)

        addSubview(guideLabel)
        addSubview(saveButton)
        addSubview(profileCollectionView)
    }

    private func setupConstraints() {
        headerBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        headerTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(130)
        }
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }

        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(headerBar.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(34)
        }
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(59)
            make.height.equalTo(60)
        }
        profileCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(272)
        }
    }
}
