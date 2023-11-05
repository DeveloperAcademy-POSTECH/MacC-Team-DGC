//
//  InviteCodeInputView.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

final class InviteCodeInputView: UIView {

    private lazy var firstLineTitleStack = UIStackView()
    private lazy var secondLineTitleStack = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "운전자에게 ")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "공유")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "받은")
    private lazy var titleLabel4 = CrewMakeUtil.accPrimaryTitle(titleText: "초대코드")
    private lazy var titleLabel5 = CrewMakeUtil.defalutTitle(titleText: "를 입력해주세요")

    // MARK: - 텍스트 필드 배경
    private lazy var codeSearchTextFieldView: UIView = {
        let friendSearchTextFieldView = UIView()
        friendSearchTextFieldView.layer.cornerRadius = 20
        friendSearchTextFieldView.layer.borderWidth = 1.0
        friendSearchTextFieldView.layer.borderColor = UIColor.theme.blue3?.cgColor
        return friendSearchTextFieldView
    }()

    // MARK: - 텍스트 필드
    lazy var codeSearchTextField: UITextField = {
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
            string: "초대코드를 입력하세요",
            attributes: placeholderAttributes
        )

        return friendSearchTextField
    }()

    // MARK: - 텍스트 필드 clear 버튼
    lazy var clearButton: UIButton = {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = UIColor.semantic.textBody
        return clearButton
    }()

    lazy var conformCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "확인되었습니다. 즐거운 카풀 여정되세요!"
        label.font = UIFont.carmuFont.body1
        label.textColor = UIColor.semantic.textTertiary
        label.isHidden = true
        return label
    }()

    lazy var rejectCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "초대코드가 잘못되었어요. 확인 후 다시 입력해주세요."
        label.font = UIFont.carmuFont.body1
        label.textColor = UIColor.semantic.textNewCrew
        label.isHidden = true
        return label
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("여정 알리기", for: .normal)
        button.backgroundColor = UIColor.semantic.accPrimary
        button.titleLabel?.font = UIFont.carmuFont.headline2
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.setBackgroundImage(
            UIImage(color: UIColor.semantic.textSecondary ?? .white),
            for: .highlighted
        )
        button.layer.cornerRadius = 30
        return button
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

    private func setupViews() {
        firstLineTitleStack.axis = .horizontal
        firstLineTitleStack.alignment = .center
        secondLineTitleStack.axis = .horizontal
        secondLineTitleStack.alignment = .center

        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)

        secondLineTitleStack.addArrangedSubview(titleLabel4)
        secondLineTitleStack.addArrangedSubview(titleLabel5)

        codeSearchTextFieldView.addSubview(codeSearchTextField)
        codeSearchTextFieldView.addSubview(clearButton)

        addSubview(firstLineTitleStack)
        addSubview(secondLineTitleStack)
        addSubview(codeSearchTextFieldView)
        addSubview(conformCodeLabel)
        addSubview(rejectCodeLabel)
        addSubview(nextButton)
    }

    private func setAutoLayout() {
        firstLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(36)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(secondLineTitleStack.snp.top)
        }

        secondLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(firstLineTitleStack.snp.bottom)
            make.leading.equalToSuperview().inset(20)
        }

        codeSearchTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(secondLineTitleStack.snp.bottom).offset(72)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }

        codeSearchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(8)
            make.trailing.equalTo(codeSearchTextFieldView).offset(-84)
        }

        clearButton.snp.makeConstraints { make in
            make.leading.equalTo(codeSearchTextField.snp.trailing).offset(20)
            make.verticalEdges.equalToSuperview().inset(10)
            make.trailing.equalToSuperview()
        }

        conformCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(codeSearchTextFieldView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(40)
        }

        rejectCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(codeSearchTextFieldView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(40)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct InviteCodeInputViewPreview: PreviewProvider {
    static var previews: some View {
        ICIViewControllerRepresentable()
    }
}
