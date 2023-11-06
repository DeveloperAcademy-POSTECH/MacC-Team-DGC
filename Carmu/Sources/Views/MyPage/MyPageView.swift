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
        userInfoView.layer.shadowColor = UIColor.black.cgColor
        userInfoView.layer.shadowOpacity = 0.5
        userInfoView.layer.shadowOffset = CGSize(width: 0, height: 1)
        userInfoView.layer.shadowRadius = 5
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
        profileImageView.image = UIImage(profileImageColor: .blue)
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

    // MARK: - 닉네임 텍스트 필드
    lazy var nicknameTextField: UITextField = {
        let nicknameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        nicknameTextField.placeholder = "닉네임을 입력하세요"
        nicknameTextField.textAlignment = .center
        nicknameTextField.textColor = UIColor.semantic.textSecondary
        nicknameTextField.tintColor = UIColor.semantic.textSecondary
        nicknameTextField.clearButtonMode = .always
        nicknameTextField.borderStyle = .none
        nicknameTextField.font = UIFont.carmuFont.headline1

        if let placeholder = nicknameTextField.placeholder {
            nicknameTextField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        }
        if let clearButton = nicknameTextField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            clearButton.tintColor = .white
        }
        nicknameTextField.addSubview(bottomLine)
        return nicknameTextField
    }()

    private lazy var bottomLine = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.theme.blue3
        return bottomLine
    }()

    // MARK: - 텍스트 필드 활성화 시 어두운 배경
    lazy var darkOverlayView: UIView = {
        let darkOverlayView = UIView()
        darkOverlayView.backgroundColor = UIColor.theme.trans60
        return darkOverlayView
    }()
    // 블러 효과
    // TODO: - 피그마에 나와있는 정확한 값을 반영하는 방법 찾아보기
    lazy var blurEffectView: CustomIntensityVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = CustomIntensityVisualEffectView(effect: blurEffect, intensity: 0.4)
        return blurView
    }()

    // MARK: - 텍스트 필드 활성화 시 상단 편집 바
    lazy var textFieldEditStack: UIStackView = {
        let textFieldEditStack = UIStackView()
        textFieldEditStack.axis = .horizontal
        textFieldEditStack.alignment = .center
        textFieldEditStack.distribution = .equalCentering
        textFieldEditStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textFieldEditStack.isLayoutMarginsRelativeArrangement = true

        textFieldEditStack.addArrangedSubview(textFieldEditCancelButton)
        textFieldEditStack.addArrangedSubview(textFieldEditTitle)
        textFieldEditStack.addArrangedSubview(textFieldEditDoneButton)
        return textFieldEditStack
    }()
    // 취소 버튼
    lazy var textFieldEditCancelButton: UIButton = {
        let textFieldCancelButton = UIButton()
        textFieldCancelButton.setTitle("취소", for: .normal)
        textFieldCancelButton.setTitleColor(.white, for: .normal)
        return textFieldCancelButton
    }()
    lazy var textFieldEditTitle: UILabel = {
        let textFieldEditTitle = UILabel()
        textFieldEditTitle.text = "닉네임 편집하기"
        textFieldEditTitle.textColor = .white
        textFieldEditTitle.font = UIFont.boldSystemFont(ofSize: 17)
        textFieldEditTitle.textAlignment = .center
        return textFieldEditTitle
    }()
    // 확인 버튼
    lazy var textFieldEditDoneButton: UIButton = {
        let textFieldEditDoneButton = UIButton()
        textFieldEditDoneButton.setTitle("확인", for: .normal)
        textFieldEditDoneButton.setTitleColor(.white, for: .normal)
        return textFieldEditDoneButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        addSubview(userInfoView)

        userInfoView.addSubview(nicknameStackView)

        nicknameStackView.addArrangedSubview(nicknameLabel)
        nicknameStackView.addArrangedSubview(nicknameEditButton)

        userInfoView.addSubview(profileImageView)
        userInfoView.addSubview(profileImageEditButton)

        darkOverlayView.isHidden = true
        darkOverlayView.addSubview(blurEffectView)
        darkOverlayView.addSubview(nicknameTextField)
        darkOverlayView.addSubview(textFieldEditStack)

        setAutoLayout()
    }

    // 상위 뷰의 크기가 변경되었을 때 하위 뷰에 적용되는 변경사항을 반영
    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = darkOverlayView.bounds
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(247)
        }
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(28)
        }
        profileImageEditButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
            make.width.height.equalTo(24)
        }
        nicknameStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(27)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(userInfoView.snp.bottom).offset(10)
        }
        bottomLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nicknameTextField.snp.bottom).inset(-5)
            make.height.equalTo(1)
        }
        textFieldEditStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
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
