//
//  MyPageView.swift
//  Carmu
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

import FirebaseAuth

final class MyPageView: UIView {

    // MARK: - 상단 유저 정보 뷰
    lazy var userInfoView: UIView = {
        let userInfoView = UIView()
        userInfoView.layer.cornerRadius = 16
        userInfoView.layer.shadowColor = UIColor.theme.blue6?.cgColor
        userInfoView.layer.shadowOpacity = 0.2
        userInfoView.layer.shadowOffset = CGSize(width: 0, height: 1)
        userInfoView.layer.shadowRadius = 8
        userInfoView.backgroundColor = UIColor.semantic.backgroundDefault
        return userInfoView
    }()

    // MARK: - 닉네임 스택
    private lazy var nicknameStackView: UIStackView = {
        let nicknameStackView = UIStackView()
        nicknameStackView.axis = .vertical
        nicknameStackView.alignment = .leading
        nicknameStackView.distribution = .fillProportionally
        nicknameStackView.spacing = 4
        return nicknameStackView
    }()

    // 닉네임 라벨
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()

    // 닉네임 편집 버튼
    lazy var nicknameEditButton: UIButton = {
        let nicknameEditButton = UIButton()
        // 폰트 설정
        let buttonFont = UIFont.systemFont(ofSize: 12)
        // 버튼 텍스트 설정
        var titleAttr = AttributedString("닉네임 편집하기 ")
        titleAttr.font = buttonFont
        // SF Symbol 설정
        let symbolConfiguration = UIImage.SymbolConfiguration(font: buttonFont)
        let symbolImage = UIImage(systemName: "pencil", withConfiguration: symbolConfiguration)

        // 버튼 Configuration 설정
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttr
        config.image = symbolImage
        config.imagePlacement = .trailing
        config.background.cornerRadius = 12
        config.baseBackgroundColor = UIColor.theme.blueTrans20?.withAlphaComponent(0.2)
        config.baseForegroundColor = UIColor.semantic.textTertiary
        let verticalPad: CGFloat = 4.0
        let horizontalPad: CGFloat = 8.0
        config.contentInsets = NSDirectionalEdgeInsets(
            top: verticalPad,
            leading: horizontalPad,
            bottom: verticalPad,
            trailing: horizontalPad
        )
        nicknameEditButton.configuration = config

        return nicknameEditButton
    }()

    // MARK: - 프로필 이미지
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(myPageImageColor: .blue)
        profileImageView.contentMode = .scaleAspectFit
        // TODO: - 이미지 프레임 추후 비율에 맞게 수정 필요
        let size = CGFloat(80)
        profileImageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        profileImageView.layer.cornerRadius = size / 2
        profileImageView.clipsToBounds = true
        return profileImageView
    }()

    // MARK: - 이미지 추가 버튼
    lazy var profileImageEditButton: UIButton = {
        let profileImageEditButton = UIButton(type: .custom)
        profileImageEditButton.setImage(UIImage(named: "profileEditBtn"), for: .normal)
        return profileImageEditButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(userInfoView)
        userInfoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(247)
        }

        addSubview(nicknameStackView)
        nicknameStackView.addArrangedSubview(nicknameLabel)
        nicknameStackView.addArrangedSubview(nicknameEditButton)
        nicknameStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(userInfoView).offset(-28)
        }

        addSubview(profileImageView)
        addSubview(profileImageEditButton)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(userInfoView).offset(-28)
        }
        profileImageEditButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
            make.width.height.equalTo(24)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct MyPageViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyPageViewController
    func makeUIViewController(context: Context) -> MyPageViewController {
        return MyPageViewController()
    }
    func updateUIViewController(_ uiViewController: MyPageViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct MyPageViewPreview: PreviewProvider {
    static var previews: some View {
        MyPageViewControllerRepresentable()
    }
}
