//
//  FriendAddView.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/10.
//

import UIKit

final class FriendAddView: UIView {

    // MARK: - 텍스트 필드 배경
    lazy var friendSearchTextFieldView: UIView = {
        let friendSearchTextFieldView = UIView()
        friendSearchTextFieldView.layer.cornerRadius = 20
        friendSearchTextFieldView.layer.borderWidth = 1.0
        friendSearchTextFieldView.layer.borderColor = UIColor.theme.blue3?.cgColor
        return friendSearchTextFieldView
    }()

    // MARK: - 텍스트 필드
    lazy var friendSearchTextField: UITextField = {
        let friendSearchTextField = UITextField()
        friendSearchTextField.textAlignment = .left
        friendSearchTextField.font = UIFont.carmuFont.body2Long
        friendSearchTextField.textColor = UIColor.semantic.textPrimary
        friendSearchTextField.autocapitalizationType = .none

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.semantic.textPrimary as Any,
            .font: UIFont.carmuFont.body2Long
        ]
        friendSearchTextField.attributedPlaceholder = NSAttributedString(
            string: "친구의 닉네임을 검색하세요.",
            attributes: placeholderAttributes
        )

        friendSearchTextField.rightView = textFieldUtilityStackView
        friendSearchTextField.rightViewMode = .whileEditing

        return friendSearchTextField
    }()

    // MARK: - 텍스트 필드 우측 스택
    lazy var textFieldUtilityStackView: UIStackView = {
        let textFieldUtilityStackView = UIStackView()
        textFieldUtilityStackView.axis = .horizontal
        textFieldUtilityStackView.alignment = .center
        textFieldUtilityStackView.distribution = .fill
        return textFieldUtilityStackView
    }()

    // MARK: - 텍스트 필드 clear 버튼
    lazy var clearButton: UIButton = {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = UIColor.semantic.accPrimary
        return clearButton
    }()

    // MARK: - 텍스트 필드 검색 버튼
    lazy var friendSearchButton: UIButton = {
        let friendSearchButton = UIButton()
        friendSearchButton.setTitle("검색", for: .normal)
        friendSearchButton.setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        friendSearchButton.titleLabel?.font = UIFont.carmuFont.body2Long
        return friendSearchButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        setupViews()
        setAutoLayout()
    }

    func setupViews() {
        addSubview(friendSearchTextFieldView)

        friendSearchTextFieldView.addSubview(friendSearchTextField)

        textFieldUtilityStackView.addArrangedSubview(clearButton)
        textFieldUtilityStackView.addArrangedSubview(friendSearchButton)
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
        friendSearchTextFieldView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(38)
        }
        friendSearchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(8)
        }
        clearButton.snp.makeConstraints { make in
            make.trailing.equalTo(friendSearchButton.snp.leading).offset(-10)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FriendAddViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FriendAddViewController
    func makeUIViewController(context: Context) -> FriendAddViewController {
        return FriendAddViewController()
    }
    func updateUIViewController(_ uiViewController: FriendAddViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct FriendAddViewPreview: PreviewProvider {
    static var previews: some View {
        FriendAddViewControllerRepresentable()
    }
}
