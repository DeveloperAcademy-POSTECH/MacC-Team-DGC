//
//  LoginView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import AuthenticationServices
import UIKit

final class LoginView: UIView {

    var appleSignInButton = {
        let appleSignInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleSignInButton.cornerRadius = 20
        return appleSignInButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        // MARK: - 로고
        let logo = UIImageView(image: UIImage(systemName: "car"))
        addSubview(logo)

        // MARK: - 로고 위 텍스트
        let logoUpperLabel = UILabel()
        logoUpperLabel.text = "여정을 연결하다."
        logoUpperLabel.font = UIFont.systemFont(ofSize: 22)
        addSubview(logoUpperLabel)

        // MARK: - 로고 아래 텍스트
        let logoLowerLabel = UILabel()
        logoLowerLabel.text = "Carmu"
        logoLowerLabel.font = UIFont.systemFont(ofSize: 36)
        addSubview(logoLowerLabel)

        // MARK: - 애플 로그인 버튼
        addSubview(appleSignInButton)

        // MARK: - 하단 회사명
        let corpLabel = UILabel()
        corpLabel.text = "@Damn Good Company"
        corpLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(corpLabel)

        // MARK: - 오토 레이아웃 세팅
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appleSignInButton.snp.top).offset(-202)
            make.width.equalTo(282)
            make.height.equalTo(141)
        }
        logoUpperLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(logo.snp.top).offset(-16)
        }
        logoLowerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(20)
        }
        appleSignInButton.snp.makeConstraints { make in
            make.bottom.equalTo(corpLabel.snp.top).offset(-64)
            make.leading.trailing.equalToSuperview().inset(60)
            make.height.equalTo(50)
        }
        corpLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
