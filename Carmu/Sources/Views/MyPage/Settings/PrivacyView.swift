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
        let mainLabelText = "당신의 셔틀이\n좀 더 편리하도록 Carmu."
        let attributedText = NSMutableAttributedString(string: mainLabelText)
        if let range1 = mainLabelText.range(of: "셔틀") {
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

    // 개인정보 처리방침 링크 연결 버튼
    let privacyButton: UIButton = {
        let privacyButton = UIButton()
        privacyButton.setTitle("개인정보 처리방침 보러가기", for: .normal)
        privacyButton.setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        return privacyButton
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

        addSubview(privacyContentView)
        privacyContentView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(appLogo.snp.bottom).offset(-40)
        }

        privacyContentView.addSubview(privacyButton)
        privacyButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
