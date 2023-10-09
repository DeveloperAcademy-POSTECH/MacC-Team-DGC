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
            appLogoView.contentMode = .scaleAspectFit
            appLogoView.image = appLogo
        }
        return appLogoView
    }()

    lazy var greetingStack: UIStackView = {
        let greetingStack = UIStackView()
        greetingStack.axis = .vertical
        greetingStack.alignment = .leading
        return greetingStack
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
        privacyIntroStackView.addArrangedSubview(greetingStack)

        greetingStack.addArrangedSubview(greetingLabel)
        greetingStack.addArrangedSubview(privacyDescription)

        privacyContentView.addArrangedSubview(privacyContent)
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
        privacyIntroStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(79)
            make.bottom.equalTo(privacyContentView.snp.top).offset(-36)
        }
        appLogoView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(197)
            make.height.equalTo(47)
            make.bottom.equalTo(greetingStack.snp.top).offset(-20)
        }
        greetingStack.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
        }
        greetingLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.bottom.equalTo(privacyDescription.snp.top).offset(-12)
        }
        privacyDescription.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
        }

        privacyContentView.snp.makeConstraints { make in
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
