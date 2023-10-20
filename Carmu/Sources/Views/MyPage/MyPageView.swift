//
//  MyPageView.swift
//  Carmu
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

import FirebaseAuth

final class MyPageView: UIView {

    // MARK: - 설정 버튼
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let symbol = UIImage(systemName: "gearshape", withConfiguration: symbolConfig)
        button.setImage(symbol, for: .normal)
        button.tintColor = .white
        return button
    }()

    // MARK: - 상단 유저 정보 뷰
    lazy var userInfoView: UIView = {
        let userInfoView = UIView()
        userInfoView.layer.cornerRadius = 16
        userInfoView.layer.shadowColor = UIColor.black.cgColor
        userInfoView.layer.shadowOpacity = 0.5
        userInfoView.layer.shadowOffset = CGSize(width: 0, height: 1)
        userInfoView.layer.shadowRadius = 5
        return userInfoView
    }()

    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.cornerRadius = 16
        gradient.colors = [
            UIColor.theme.blue6!.cgColor,
            UIColor.theme.acua5!.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()

    // MARK: - 닉네임 스택
    private lazy var nicknameStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        return stack
    }()

    // 닉네임 라벨
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()

    // 닉네임 편집 버튼
    lazy var editButton: UIButton = {
        let button = UIButton()
        // 버튼 텍스트 설정
        var titleAttr = AttributedString("닉네임 편집하기✏️")
        titleAttr.font = UIFont.systemFont(ofSize: 12)
        // 버튼 Configuration 설정
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttr
        config.background.cornerRadius = 12
        config.baseBackgroundColor = UIColor.theme.blue1?.withAlphaComponent(0.2)
        config.baseForegroundColor = UIColor.semantic.textSecondary
        let verticalPad: CGFloat = 4.0
        let horizontalPad: CGFloat = 8.0
        config.contentInsets = NSDirectionalEdgeInsets(
            top: verticalPad,
            leading: horizontalPad,
            bottom: verticalPad,
            trailing: horizontalPad
        )
        button.configuration = config

        return button
    }()

    // MARK: - 프로필 이미지
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "profile")
        imgView.contentMode = .scaleAspectFit
        // TODO: - 이미지 프레임 추후 비율에 맞게 수정 필요
        let size = CGFloat(80)
        imgView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        imgView.layer.cornerRadius = size / 2
        imgView.clipsToBounds = true
        return imgView
    }()

    // MARK: - 이미지 추가 버튼
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cameraBtn"), for: .normal)
        return button
    }()

    // MARK: - 텍스트 필드
    lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        textField.placeholder = "입력하세요"
        textField.textAlignment = .center
        textField.textColor = .white
        textField.tintColor = .white
        textField.clearButtonMode = .always
        textField.borderStyle = .none

        if let placeholder = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        }
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            clearButton.tintColor = .white
        }
        textField.addSubview(bottomLine)
        return textField
    }()

    private var bottomLine = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = .white
        return bottomLine
    }()

    // MARK: - 텍스트 필드 활성화 시 어두운 배경
    lazy var darkOverlayView: UIView = {
        let darkOverlayView = UIView()
        darkOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return darkOverlayView
    }()

    // MARK: - 텍스트 필드 활성화 시 상단 편집 바
    lazy var textFieldEditStack: UIStackView = {
        let textFieldEditStack = UIStackView()
        textFieldEditStack.axis = .horizontal
        textFieldEditStack.alignment = .center
        textFieldEditStack.distribution = .equalCentering

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

        userInfoView.layer.addSublayer(gradient)
        userInfoView.addSubview(settingsButton)
        userInfoView.addSubview(nicknameStack)

        nicknameStack.addArrangedSubview(nicknameLabel)
        nicknameStack.addArrangedSubview(editButton)

        userInfoView.addSubview(imageView)
        userInfoView.addSubview(addButton)

        darkOverlayView.isHidden = true
        addSubview(darkOverlayView)
        darkOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        textField.isHidden = true
        textFieldEditStack.isHidden = true
        addSubview(textField)
        addSubview(textFieldEditStack)

        setAutoLayout()
    }

    // 상위 뷰의 크기가 변경되었을 때 하위 뷰에 적용되는 변경사항을 반영
    override func layoutSubviews() {
        super.layoutSubviews()
        // userInfoView의 사이즈가 정해지고 나면 gradient.frame을 맞춰준다.
        gradient.frame = userInfoView.bounds
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
        userInfoView.snp.makeConstraints { make in
            // userInfoView에 cornerRadius를 주면서 상단 모서리가 잘리는 부분을 없애주기 위해 화면 크기보다 위로 조금 넘치게 설정
            make.top.equalToSuperview().inset(-20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(340)
        }
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.trailing.equalToSuperview().inset(20)
        }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(59)
        }
        addButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView)
            make.width.height.equalTo(24)
        }
        nicknameStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(userInfoView).offset(-67)
        }
        editButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(userInfoView.snp.bottom).offset(-30)
        }
        bottomLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).inset(-5)
            make.height.equalTo(1)
        }
        textFieldEditStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(2)
            make.leading.trailing.equalToSuperview().inset(20)
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
