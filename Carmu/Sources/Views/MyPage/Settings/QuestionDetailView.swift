//
//  QuestionDetailView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import UIKit

// MARK: - 자주 묻는 질문 뷰
final class QuestionDetailView: UIView {

    // 상단 질문 문구
    let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.carmuFont.headline2
        questionLabel.textColor = UIColor.semantic.textPrimary
        let mainLabelText = "많은 사람들과 카풀을 하고 있는데, 크루는 하나 이상 만들 수는 없나요?"
        let attributedText = NSMutableAttributedString(string: mainLabelText)
        if let range1 = mainLabelText.range(of: "카풀") {
            let nsRange1 = NSRange(range1, in: mainLabelText)
            attributedText.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor.semantic.accPrimary ?? .systemBlue,
                range: nsRange1
            )
        }
        if let range2 = mainLabelText.range(of: "하나 이상") {
            let nsRange2 = NSRange(range2, in: mainLabelText)
            attributedText.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor.semantic.accPrimary ?? .systemBlue,
                range: nsRange2
            )
        }
        questionLabel.attributedText = attributedText
        return questionLabel
    }()

    // 상단 서브 문구
    private let subLabel: UILabel = {
        let subLabel = UILabel()
        subLabel.text = "상세한 문의사항이 있으시다면 1:1 문의하기로 문의주세요!"
        subLabel.font = UIFont.carmuFont.body2Long
        subLabel.textColor = UIColor.semantic.textBody
        return subLabel
    }()

    // 답변 내용 박스
    private let answerContentView: UIView = {
        let privacyContentView = UIView()
        privacyContentView.layer.cornerRadius = 20
        privacyContentView.backgroundColor = UIColor.semantic.backgroundDefault
        return privacyContentView
    }()

    // 답변 내용
    let answerTitle: UILabel = {
        let answerTitle = UILabel()
        answerTitle.text = "답변 제목"
        answerTitle.font = UIFont.carmuFont.subhead3
        answerTitle.textColor = UIColor.semantic.textPrimary
        return answerTitle
    }()
    let answerDescription: UILabel = {
        let answerDescription = UILabel()
        answerDescription.text = "답변 내용"
        answerDescription.font = UIFont.carmuFont.body3Long
        answerDescription.textColor = UIColor.semantic.textPrimary
        answerDescription.numberOfLines = 0
        return answerDescription
    }()

    // 로고
    private let appLogo: UIImageView = {
        let appLogo = UIImageView()
        appLogo.contentMode = .scaleAspectFit
        if let image = UIImage(named: "appLogo") {
            appLogo.image = image
        } else {
            appLogo.image = UIImage(systemName: "x.square")
        }
        return appLogo
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupUI() {
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
        }

        addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        addSubview(appLogo)
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(64)
            make.height.equalTo(18)
        }

        addSubview(answerContentView)
        answerContentView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(appLogo.snp.bottom).offset(-40)
        }
        answerContentView.addSubview(answerTitle)
        answerContentView.addSubview(answerDescription)
        answerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(22)
        }
        answerDescription.snp.makeConstraints { make in
            make.top.equalTo(answerTitle.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
