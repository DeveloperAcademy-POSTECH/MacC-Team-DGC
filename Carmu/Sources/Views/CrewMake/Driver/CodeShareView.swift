//
//  CodeShareView.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

import SnapKit

final class CodeShareView: UIView {

    private lazy var secondLineTitleStack = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "카풀을 같이 하는 사람들에게")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "초대코드를 공유")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "해주세요")

    private let characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "VariantGradientStroke")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let codeStackView: UIView = {
        let stackView = UIView()
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.theme.blue3?.cgColor
        stackView.layer.cornerRadius = 20
        stackView.clipsToBounds = true
        return stackView
    }()

    var codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    let copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("복사 􀉁", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead2
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.backgroundColor = UIColor.semantic.accPrimary
        button.setBackgroundImage(UIImage(color: UIColor.semantic.textSecondary ?? .white), for: .highlighted)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "클립보드에 복사되었습니다"
        label.font = UIFont.carmuFont.subhead2
        label.textColor = UIColor.semantic.textSecondary
        label.textAlignment = .center
        label.backgroundColor = UIColor.theme.trans60
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

    let nextButton = NextButton(buttonTitle: "카풀 시작하기")

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
}

// MARK: - setup UI
extension CodeShareView {
    private func setupViews() {
        secondLineTitleStack.axis = .horizontal

        secondLineTitleStack.addArrangedSubview(titleLabel2)
        secondLineTitleStack.addArrangedSubview(titleLabel3)

        codeStackView.addSubview(codeLabel)
        codeStackView.addSubview(copyButton)

        addSubview(titleLabel1)
        addSubview(secondLineTitleStack)
        addSubview(characterImage)
        addSubview(codeStackView)
        addSubview(nextButton)
        addSubview(messageLabel)
    }

    private func setAutoLayout() {
        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(36)
            make.leading.equalToSuperview().inset(20)
        }

        secondLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.leading.equalToSuperview().inset(20)
        }

        characterImage.snp.makeConstraints { make in
            make.top.equalTo(secondLineTitleStack.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(67)
        }

        codeStackView.snp.makeConstraints { make in
            make.top.equalTo(characterImage.snp.bottom).offset(68)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(36)
        }

        codeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        copyButton.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.width.equalTo(80)
        }

        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeStackView.snp.bottom).offset(20)
            make.width.equalTo(192)
            make.height.equalTo(30)
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
struct CodeShareViewPreview: PreviewProvider {
    static var previews: some View {
        CSViewControllerRepresentable()
    }
}
