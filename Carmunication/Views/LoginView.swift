//
//  LoginView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import AuthenticationServices
import UIKit

final class LoginView: UIView {

    // MARK: - 앱 로고
    lazy var appLogoView: UIImageView = {
        let appLogoView = UIImageView()
        if let appLogo = UIImage(named: "appLogo") {
            let targetSize = CGSize(width: 282, height: 141)
            let scaledImage = appLogo.aspectFit(toSize: targetSize)
            appLogoView.image = scaledImage
        }
        return appLogoView
    }()

    lazy var logoUpperLabelStack: UIStackView = {
        let logoUpperLabelStack = UIStackView()
        logoUpperLabelStack.axis = .horizontal
        logoUpperLabelStack.alignment = .center
        return logoUpperLabelStack
    }()
    lazy var logoUpperLabel1: UILabel = {
        let logoUpperLabel1 = UILabel()
        logoUpperLabel1.text = "여정"
        logoUpperLabel1.font = UIFont.carmuFont.body3
        logoUpperLabel1.textColor = UIColor.theme.blue8
        return logoUpperLabel1
    }()
    lazy var logoUpperLabel2: UILabel = {
        let logoUpperLabel2 = UILabel()
        logoUpperLabel2.text = "을 연결하다."
        logoUpperLabel2.font = UIFont.carmuFont.body3
        logoUpperLabel2.textColor = UIColor.theme.black
        return logoUpperLabel2
    }()

    // MARK: - 앱 이름
    lazy var appNameLabel: UILabel = {
        let appNameLabel = UILabel()
        appNameLabel.text = "Carmu"
        appNameLabel.font = UIFont.carmuFont.display3
        appNameLabel.textColor = UIColor.theme.blue3
        return appNameLabel
    }()

    // MARK: - 애플 로그인 버튼
    lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let appleSignInButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
        appleSignInButton.cornerRadius = 100
        return appleSignInButton
    }()

    // 화사명
    lazy var corpName: UILabel = {
        let corpName = UILabel()
        corpName.text = "@Damn Good Company"
        corpName.font = UIFont.carmuFont.body1
        corpName.textColor = UIColor.theme.gray6
        return corpName
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
        addSubview(appLogoView)
        addSubview(logoUpperLabelStack)
        addSubview(appNameLabel)
        addSubview(appleSignInButton)
        addSubview(corpName)

        logoUpperLabelStack.addArrangedSubview(logoUpperLabel1)
        logoUpperLabelStack.addArrangedSubview(logoUpperLabel2)
    }

    func setAutoLayout() {
        appLogoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        logoUpperLabelStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appLogoView.snp.top).offset(-16)
        }

        appNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appLogoView.snp.bottom).offset(20)
        }

        appleSignInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(60)
            make.height.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(92)
        }

        corpName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct LoginViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = LoginViewController
    func makeUIViewController(context: Context) -> LoginViewController {
        return LoginViewController()
    }
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {}
}
@available(iOS 13.0.0, *)
struct LoginViewPreview: PreviewProvider {
    static var previews: some View {
        LoginViewControllerRepresentable()
    }
}
