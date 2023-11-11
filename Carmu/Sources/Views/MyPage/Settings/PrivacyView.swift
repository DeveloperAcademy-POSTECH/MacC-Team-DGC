//
//  PrivacyView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/08.
//

import UIKit

// MARK: - 개인정보 처리방침 뷰
final class PrivacyView: UIView {

    // 상단 메인 문구
    private let mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.numberOfLines = 0
        mainLabel.font = UIFont.carmuFont.headline2
        mainLabel.textColor = UIColor.semantic.textPrimary
        let mainLabelText = "당신의 카풀생활이\n오래갈 수 있도록 Carmu."
        let attributedText = NSMutableAttributedString(string: mainLabelText)
        if let range1 = mainLabelText.range(of: "카풀생활") {
            let nsRange1 = NSRange(range1, in: mainLabelText)
            attributedText.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor.semantic.accPrimary ?? .systemBlue,
                range: nsRange1
            )
        }
        if let range2 = mainLabelText.range(of: "Carmu.") {
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
        subLabel.text = "이용자님의 개인정보를 위해 아래 처리 방침을 준수합니다."
        subLabel.font = UIFont.carmuFont.body2Long
        subLabel.textColor = UIColor.semantic.textBody
        return subLabel
    }()

    // 개인정보 처리방침 내용 박스
    private let privacyContentView: UIView = {
        let privacyContentView = UIView()
        privacyContentView.layer.cornerRadius = 20
        privacyContentView.backgroundColor = UIColor.semantic.backgroundDefault
        return privacyContentView
    }()

    // 개인정보 처리방침 내용
    private let privacyContent: UILabel = {
        let privacyContent = UILabel()
        privacyContent.text = "제 1조 1항\n개인정보라 함은 oooo이다."
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
        // TODO: - 백그라운드 색상 수정 필요
        self.backgroundColor = UIColor.semantic.backgroundSecond
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

        addSubview(privacyContentView)
        privacyContentView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(appLogo.snp.bottom).offset(-40)
        }
        privacyContentView.addSubview(privacyContent)
        privacyContent.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct PrivacyViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PrivacyViewController
    func makeUIViewController(context: Context) -> PrivacyViewController {
        return PrivacyViewController()
    }
    func updateUIViewController(_ uiViewController: PrivacyViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct PrivacyViewPreview: PreviewProvider {
    static var previews: some View {
        PrivacyViewControllerRepresentable()
    }
}
