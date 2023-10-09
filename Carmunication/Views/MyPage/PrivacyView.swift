//
//  PrivacyView.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/08.
//

import UIKit

final class PrivacyView: UIView {

    // MARK: - 개인정보 처리방침 위 스택 뷰
    lazy var privacyIntroStackView: UIStackView = {
        let privacyIntroStackView = UIStackView()
        privacyIntroStackView.axis = .vertical
        privacyIntroStackView.alignment = .leading
        return privacyIntroStackView
    }()

    // 로고
    lazy var appLogoView: UIImageView = {
        let appLogoView = UIImageView()
        if let appLogo = UIImage(named: "appLogo") {
            let targetSize = CGSize(width: 94, height: 47)
            let scaledImage = appLogo.aspectFit(toSize: targetSize)
            appLogoView.image = scaledImage
        }
        return appLogoView
    }()

    // 인사 문구
    lazy var greetingLabel: UILabel = {
        let greetingLabel = UILabel()
        greetingLabel.text = "CARMU 이용자님,\n안녕하세요!"
        greetingLabel.font = UIFont.carmuFont.headline2
        greetingLabel.numberOfLines = 0
        return greetingLabel
    }()

    // 설명
    lazy var privacyDescription: UILabel = {
        let privacyDescription = UILabel()
        privacyDescription.text = "이용자님의 개인정보는 아래 처리 방침을 준수합니다."
        privacyDescription.font = UIFont.carmuFont.body2
        privacyDescription.textColor = .gray
        return privacyDescription
    }()

    // MARK: - 개인정보 처리방침 내용 박스
    lazy var privacyContentView: UIStackView = {
        let privacyContentView = UIStackView()
        privacyContentView.axis = .vertical
        privacyContentView.alignment = .leading
        privacyContentView.layer.borderWidth = 1
        privacyContentView.layer.borderColor = UIColor.theme.blue3?.cgColor
        privacyContentView.layer.cornerRadius = 16
        return privacyContentView
    }()

    // 개인정보 처리방침 내용
    lazy var privacyContent: UILabel = {
        let privacyContent = UILabel()
        privacyContent.text = "제 1장\n개인정보라 함은 OOO라 한다."
        privacyContent.numberOfLines = 0
        return privacyContent
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
        addSubview(privacyIntroStackView)
        addSubview(privacyContentView)

        privacyIntroStackView.addArrangedSubview(appLogoView)
        privacyIntroStackView.addArrangedSubview(greetingLabel)
        privacyIntroStackView.addArrangedSubview(privacyDescription)

        privacyContentView.addArrangedSubview(privacyContent)
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
        privacyIntroStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.leading.equalToSuperview().inset(20)
        }
        appLogoView.snp.makeConstraints { make in
            make.bottom.equalTo(greetingLabel.snp.top).offset(-20)
        }
        greetingLabel.snp.makeConstraints { make in
            make.bottom.equalTo(privacyDescription.snp.top).offset(-12)
        }

        privacyContentView.snp.makeConstraints { make in
            make.top.equalTo(privacyIntroStackView.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(48)
        }
        privacyContent.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
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
