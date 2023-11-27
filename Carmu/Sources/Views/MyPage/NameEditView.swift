//
//  NicknameEditView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/07.
//

import UIKit

// MARK: - 이름 편집 화면 (유저 닉네임 & 크루명)
final class NameEditView: UIView {

    // MARK: - 텍스트 필드
    lazy var nameEditTextField: UITextField = {
        let nameEditTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        nameEditTextField.placeholder = "닉네임을 입력하세요"
        nameEditTextField.textAlignment = .center
        nameEditTextField.textColor = UIColor.semantic.textSecondary
        nameEditTextField.tintColor = UIColor.semantic.textSecondary
        nameEditTextField.clearButtonMode = .always
        nameEditTextField.borderStyle = .none
        nameEditTextField.font = UIFont.carmuFont.headline1
        nameEditTextField.enablesReturnKeyAutomatically = true

        if let placeholder = nameEditTextField.placeholder {
            nameEditTextField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        }
        if let clearButton = nameEditTextField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            clearButton.tintColor = .white
        }
        nameEditTextField.addSubview(bottomLine)
        return nameEditTextField
    }()

    private lazy var bottomLine = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.theme.blue3
        return bottomLine
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
//        self.backgroundColor = UIColor.theme.trans60
        self.backgroundColor = .clear
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(textFieldEditStack)

        textFieldEditStack.addArrangedSubview(textFieldEditCancelButton)
        textFieldEditStack.addArrangedSubview(textFieldEditTitle)
        textFieldEditStack.addArrangedSubview(textFieldEditDoneButton)
        textFieldEditStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(49)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }

        addSubview(nameEditTextField)
        nameEditTextField.addSubview(bottomLine)
        nameEditTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(247) // TODO: userInfoView bottom과 맞는지??
        }
        bottomLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nameEditTextField.snp.bottom).offset(5)
            make.height.equalTo(1)
        }
    }

    // 상위 뷰의 크기가 변경되었을 때 하위 뷰에 적용되는 변경사항을 반영
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct NameEditViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = NameEditViewController
    func makeUIViewController(context: Context) -> NameEditViewController {
        return NameEditViewController(nowName: "홍길동", isCrewNameEditView: false)
    }
    func updateUIViewController(_ uiViewController: NameEditViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct NameEditViewPreview: PreviewProvider {
    static var previews: some View {
        NameEditViewControllerRepresentable()
    }
}
