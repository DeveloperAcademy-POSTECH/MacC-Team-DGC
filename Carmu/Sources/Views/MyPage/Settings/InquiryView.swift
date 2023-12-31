//
//  InquiryView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/09.
//

import UIKit

// MARK: - 문의하기 뷰
final class InquiryView: UIView {

    let scrollView = UIScrollView()
    private let contentsView = UIView()

    // 상단 메인 문구
    private let mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.numberOfLines = 0
        mainLabel.text = "카뮤팀은\n언제나 열려있습니다."
        mainLabel.font = UIFont.carmuFont.headline2
        mainLabel.textColor = UIColor.semantic.textPrimary
        return mainLabel
    }()

    // 상단 서브 문구
    private let subLabel: UILabel = {
        let subLabel = UILabel()
        subLabel.text = "문의사항이 있으시다면 아래로 문의주세요!"
        subLabel.font = UIFont.carmuFont.body2Long
        subLabel.textColor = UIColor.semantic.textBody
        return subLabel
    }()

    private let faqLabel: UILabel = {
        let faqLabel = UILabel()
        faqLabel.text = "FAQ"
        faqLabel.font = UIFont.carmuFont.body2
        faqLabel.textColor = UIColor.semantic.textBody
        return faqLabel
    }()

    // 질문 스택 뷰
    private let questionsStackView: UIStackView = {
        let questionsStackView = UIStackView()
        questionsStackView.axis = .vertical
        questionsStackView.distribution = .fillEqually
        questionsStackView.spacing = 16
        return questionsStackView
    }()

    // 질문 1
    let question1Button: UIButton = {
        let question1Button = UIButton()
        let question1Text = "자주 묻는 질문, 하나\n셔틀은 하나 이상 만들 수는 없나요?"

        // 텍스트 줄 간격 값
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // TODO: - 정확한 값 확인 필요

        let attributedText = NSMutableAttributedString(string: question1Text)
        // 텍스트 전체에 폰트 적용
        attributedText.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.carmuFont.body3Long,
            range: NSRange(location: 0, length: attributedText.length)
        )
        // 텍스트 전체에 줄 간격 적용
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedText.length)
        )
        // 텍스트의 특정 부분에 폰트 적용
        if let range1 = question1Text.range(of: "자주 묻는 질문, 하나") {
            let nsRange1 = NSRange(range1, in: question1Text)
            attributedText.addAttribute(
                NSAttributedString.Key.font,
                value: UIFont.carmuFont.subhead3,
                range: nsRange1
            )
        }
        question1Button.setAttributedTitle(attributedText, for: .normal)
        question1Button.contentHorizontalAlignment = .leading // 왼쪽 정렬

        // 버튼 외형 설정
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 20
        config.baseBackgroundColor = UIColor.semantic.backgroundDefault
        config.baseForegroundColor = UIColor.semantic.textPrimary
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        question1Button.configuration = config

        return question1Button
    }()

    // 질문 2
    let question2Button: UIButton = {
        let question2Button = UIButton()
        let question2Text = "자주 묻는 질문, 둘\n참여여부 응답 시간 규칙을 변경할 수 있나요?"

        // 텍스트 줄 간격 값
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // TODO: - 정확한 값 확인 필요

        let attributedText = NSMutableAttributedString(string: question2Text)
        // 텍스트 전체에 폰트 적용
        attributedText.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.carmuFont.body3Long,
            range: NSRange(location: 0, length: attributedText.length)
        )
        // 텍스트 전체에 줄 간격 적용
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedText.length)
        )
        // 텍스트의 특정 부분에 폰트 적용
        if let range1 = question2Text.range(of: "자주 묻는 질문, 둘") {
            let nsRange1 = NSRange(range1, in: question2Text)
            attributedText.addAttribute(
                NSAttributedString.Key.font,
                value: UIFont.carmuFont.subhead3,
                range: nsRange1
            )
        }
        question2Button.setAttributedTitle(attributedText, for: .normal)
        question2Button.contentHorizontalAlignment = .leading // 왼쪽 정렬

        // 버튼 외형 설정
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 20
        config.baseBackgroundColor = UIColor.semantic.backgroundDefault
        config.baseForegroundColor = UIColor.semantic.textPrimary
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        question2Button.configuration = config

        return question2Button
    }()

    // 질문 3
    let question3Button: UIButton = {
        let question3Button = UIButton()
        let question3Text = "자주 묻는 질문, 셋\n앱을 사용하다가 지각했어요. 보상이 가능한가요?"

        // 텍스트 줄 간격 값
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // TODO: - 정확한 값 확인 필요

        let attributedText = NSMutableAttributedString(string: question3Text)
        // 텍스트 전체에 폰트 적용
        attributedText.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.carmuFont.body3Long,
            range: NSRange(location: 0, length: attributedText.length)
        )
        // 텍스트 전체에 줄 간격 적용
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedText.length)
        )
        // 텍스트의 특정 부분에 폰트 적용
        if let range1 = question3Text.range(of: "자주 묻는 질문, 셋") {
            let nsRange1 = NSRange(range1, in: question3Text)
            attributedText.addAttribute(
                NSAttributedString.Key.font,
                value: UIFont.carmuFont.subhead3,
                range: nsRange1
            )
        }
        question3Button.setAttributedTitle(attributedText, for: .normal)
        question3Button.contentHorizontalAlignment = .leading // 왼쪽 정렬

        // 버튼 외형 설정
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 20
        config.baseBackgroundColor = UIColor.semantic.backgroundDefault
        config.baseForegroundColor = UIColor.semantic.textPrimary
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        question3Button.configuration = config

        return question3Button
    }()

    // MARK: - 문의하기 화면 테이블 뷰
    lazy var inquiryTableView: UITableView = {
        let inquiryTableView = UITableView(frame: .zero, style: .insetGrouped)
        inquiryTableView.isScrollEnabled = false
        inquiryTableView.sectionFooterHeight = 0
        inquiryTableView.sectionHeaderHeight = 21

        inquiryTableView.backgroundColor = .clear
        inquiryTableView.separatorColor = UIColor.semantic.stoke
        return inquiryTableView
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
        addSubview(appLogo)
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(64)
            make.height.equalTo(18)
        }

        contentsView.addSubview(mainLabel)
        contentsView.addSubview(subLabel)
        contentsView.addSubview(faqLabel)
        contentsView.addSubview(questionsStackView)
        contentsView.addSubview(inquiryTableView)
        scrollView.addSubview(contentsView)
        addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.width.equalToSuperview()
            make.bottom.equalTo(appLogo.snp.top).offset(-30)
        }

        contentsView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(600)
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        faqLabel.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(32)
        }

        questionsStackView.snp.makeConstraints { make in
            make.top.equalTo(faqLabel.snp.bottom).offset(4)
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        questionsStackView.addArrangedSubview(question1Button)
        questionsStackView.addArrangedSubview(question2Button)
        questionsStackView.addArrangedSubview(question3Button)
        question1Button.snp.makeConstraints { make in
            make.height.equalTo(90)
        }
        question2Button.snp.makeConstraints { make in
            make.height.equalTo(90)
        }
        question3Button.snp.makeConstraints { make in
            make.height.equalTo(90)
        }

        inquiryTableView.snp.makeConstraints { make in
            make.top.equalTo(questionsStackView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct InquiryViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = InquiryViewController
    func makeUIViewController(context: Context) -> InquiryViewController {
        return InquiryViewController()
    }
    func updateUIViewController(_ uiViewController: InquiryViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct InquiryViewPreview: PreviewProvider {
    static var previews: some View {
        InquiryViewControllerRepresentable()
    }
}
