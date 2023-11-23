//
//  QuestionDetailView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import UIKit

// MARK: - 자주 묻는 질문 뷰
// TODO: - 개인정보 처리방침 뷰와 똑같음 (재사용 뷰로 분리 필요)
final class QuestionDetailView: UIView {

    // 상단 메인 문구 (질문)
    private let mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.numberOfLines = 0
        mainLabel.font = UIFont.carmuFont.headline2
        mainLabel.textColor = UIColor.semantic.textPrimary
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
        mainLabel.attributedText = attributedText
        return mainLabel
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
    private let answerContent: UILabel = {
        let privacyContent = UILabel()
        privacyContent.text = "간략한 답변\n상세 변명 어쩌구..."
        privacyContent.textColor = UIColor.semantic.textPrimary
        privacyContent.numberOfLines = 0
        // TODO: - NSMutableAttributedString 활용해서 내용 채우기
        return privacyContent
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
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
        }

        addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
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
        answerContentView.addSubview(answerContent)
        answerContent.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct QuestionDetailVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = QuestionDetailViewController
    func makeUIViewController(context: Context) -> QuestionDetailViewController {
        return QuestionDetailViewController()
    }
    func updateUIViewController(_ uiViewController: QuestionDetailViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct QuestionDetailViewPreview: PreviewProvider {
    static var previews: some View {
        QuestionDetailVCRepresentable()
    }
}
