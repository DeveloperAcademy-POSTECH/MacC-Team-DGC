//
//  LoginView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import AuthenticationServices
import UIKit

final class LoginView: UIView {

    private let logo = {
        UIImageView(image: UIImage(systemName: "car"))
    }()

    private let logoUpperLabel = {
        let logoUpperLabel = UILabel()
        logoUpperLabel.text = "여정을 연결하다."
        logoUpperLabel.font = UIFont.systemFont(ofSize: 22)
        return logoUpperLabel
    }()

    private let logoLowerLabel = {
        let logoLowerLabel = UILabel()
        logoLowerLabel.text = "Carmu"
        logoLowerLabel.font = UIFont.systemFont(ofSize: 36)
        return logoLowerLabel
    }()

    let appleSignInButton = {
        let appleSignInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleSignInButton.cornerRadius = 20
        return appleSignInButton
    }()

    private let corpName = {
        let corpName = UILabel()
        corpName.text = "@Damn Good Company"
        corpName.font = UIFont.systemFont(ofSize: 12)
        return corpName
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        addSubview(logo)
        logo.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(282)
            make.height.equalTo(141)
        }

        addSubview(logoUpperLabel)
        logoUpperLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(logo.snp.top).offset(-16)
        }

        addSubview(logoLowerLabel)
        logoLowerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(20)
        }

        addSubview(appleSignInButton)
        appleSignInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(60)
            make.height.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(92)
        }

        addSubview(corpName)
        corpName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
