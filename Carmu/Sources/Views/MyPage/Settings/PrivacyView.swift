//
//  PrivacyView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/08.
//

import UIKit

final class PrivacyView: UIView {

    // 로고
    lazy var appLogoView: UIImageView = {
        let appLogoView = UIImageView()
        if let appLogo = UIImage(named: "appLogo") {
            appLogoView.contentMode = .scaleAspectFit
            appLogoView.image = appLogo
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
    lazy var privacyContentView: UIView = {
        let privacyContentView = UIView()
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
        setupUI()
    }

    func setupUI() {
        addSubview(privacyContentView)
        privacyContentView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(277)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(48)
        }

        privacyContentView.addSubview(privacyContent)
        privacyContent.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(20)
        }

        addSubview(privacyDescription)
        privacyDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(privacyContentView.snp.top).offset(-36)
        }

        addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(privacyDescription.snp.top).offset(-12)
        }

        addSubview(appLogoView)
        appLogoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(greetingLabel.snp.top).offset(-20)
            make.width.equalTo(94)
            make.height.equalTo(47)
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
