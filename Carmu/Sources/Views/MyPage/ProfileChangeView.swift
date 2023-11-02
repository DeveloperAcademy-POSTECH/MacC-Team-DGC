//
//  ProfileChangeView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/02.
//

import UIKit

final class ProfileChangeView: UIView {

    // MARK: - 프로필 설정 모달 상단 바
    private lazy var headerBar: UIView = {
        let headerStackView = UIView()
        return headerStackView
    }()

    // 상단 바 제목
    private lazy var headerTitleLabel: UILabel = {
        let headerTitleLabel = UILabel()
        headerTitleLabel.text = "프로필 변경"
        headerTitleLabel.textAlignment = .center
        // TODO: 폰트 적용 필요
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        headerTitleLabel.textColor = UIColor.semantic.textPrimary
        return headerTitleLabel
    }()

    // 모달 닫기 버튼
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.semantic.accPrimary
        return closeButton
    }()

    lazy var guideLabel: UILabel = {
        let guideLabel = UILabel()
        guideLabel.text = "변경할 프로필을 선택하세요"
        guideLabel.font = UIFont.carmuFont.headline2
        guideLabel.textColor = UIColor.semantic.textPrimary
        return guideLabel
    }()

    // 프로필 타입 선택 콜렉션 뷰
    lazy var profileCollectionView: UIView = {
        let profileCollectionView = UIView()
        profileCollectionView.backgroundColor = .red
        return profileCollectionView
    }()

    // 저장 버튼
    lazy var saveButton: UIButton = {
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
        setHeader()
        setLabel()
        setProfileCollectionView()
        setSaveButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setHeader() {
        addSubview(headerBar)
        headerBar.addSubview(headerTitleLabel)
        headerBar.addSubview(closeButton)

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
    }

    func setLabel() {
        addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(headerBar.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(profileCollectionView.snp.top).offset(-114)
        }
    }

    func setProfileCollectionView() {
        addSubview(profileCollectionView)
        profileCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-114)
        }
    }

    func setSaveButton() {
        addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(80)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct ProfileChangeViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ProfileChangeViewController
    func makeUIViewController(context: Context) -> ProfileChangeViewController {
        return ProfileChangeViewController()
    }
    func updateUIViewController(_ uiViewController: ProfileChangeViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct ProfileChangeViewPreview: PreviewProvider {
    static var previews: some View {
        ProfileChangeViewControllerRepresentable()
    }
}
