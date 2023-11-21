//
//  CrewNameSettingView.swift
//  Carmu
//
//  Created by 김동현 on 11/19/23.
//

import UIKit

final class CrewNameSettingView: UIView {

    private let firstLineTitleStack = UIStackView()

    private let titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "셔틀의 ")
    private let titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "이름")
    private let titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "을 입력해주세요")

    private let codeSearchTextFieldView: UIView = {
        let friendSearchTextFieldView = UIView()
        friendSearchTextFieldView.layer.cornerRadius = 20
        friendSearchTextFieldView.layer.borderWidth = 1.0
        friendSearchTextFieldView.layer.borderColor = UIColor.theme.blue3?.cgColor
        return friendSearchTextFieldView
    }()

    lazy var codeSearchTextField: UITextField = {
        let friendSearchTextField = UITextField()
        friendSearchTextField.textAlignment = .left
        friendSearchTextField.font = UIFont.carmuFont.body2Long
        friendSearchTextField.textColor = UIColor.semantic.textPrimary
        friendSearchTextField.autocapitalizationType = .none

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.semantic.textBody as Any,
            .font: UIFont.carmuFont.body2Long
        ]
        friendSearchTextField.attributedPlaceholder = NSAttributedString(
            string: "예) 행복유치원 셔틀",
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
        label.text = "사용가능한 이름입니다."
        label.font = UIFont.carmuFont.body1
        label.textColor = UIColor.semantic.textTertiary
        label.isHidden = true
        return label
    }()

    lazy var rejectCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 이름은 8자 이내여야 합니다."
        label.font = UIFont.carmuFont.body1
        label.textColor = UIColor.semantic.textNewCrew
        label.isHidden = true
        return label
    }()

    let nextButton = NextButton(buttonTitle: "다음")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setAutoLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        firstLineTitleStack.axis = .horizontal
        firstLineTitleStack.alignment = .center
        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)

        codeSearchTextFieldView.addSubview(codeSearchTextField)
        codeSearchTextFieldView.addSubview(clearButton)

        addSubview(firstLineTitleStack)
        addSubview(codeSearchTextFieldView)
        addSubview(conformCodeLabel)
        addSubview(rejectCodeLabel)
        addSubview(nextButton)
    }

    private func setAutoLayout() {
        firstLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(36)
            make.leading.equalToSuperview().inset(20)
        }

        codeSearchTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(firstLineTitleStack.snp.bottom).offset(100)
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

// MARK: - Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct CrewNameSettingViewPreview: PreviewProvider {
    static var previews: some View {
        CNSViewControllerRepresentable()
    }
}
