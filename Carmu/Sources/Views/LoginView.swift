//
//  LoginView.swift
//  Carmu
//
//  Created by 허준혁 on 10/5/23.
//

import AuthenticationServices
import UIKit

final class LoginView: UIView {

    // 로그인 처리 시 액티비티 인디케이터 뷰
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = UIColor.semantic.backgroundThird
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    lazy var activityIndicatorLabel: UILabel = {
        let activityIndicatorLabel = UILabel()
        activityIndicatorLabel.text = "로그인 중..."
        activityIndicatorLabel.textAlignment = .center
        activityIndicatorLabel.font = UIFont.carmuFont.subhead3
        activityIndicatorLabel.textColor = UIColor.semantic.textBody
        activityIndicatorLabel.isHidden = true
        return activityIndicatorLabel
    }()

    // MARK: - 앱 로고
    lazy var appLogoView = GifView(gifName: "launchGif")

    lazy var sloganLabel: UILabel = {
        let label = UILabel()
        label.text = "셔틀, 좀 더 편리하게"
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.textTertiary
        label.backgroundColor = UIColor.semantic.backgroundThird
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
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
        addSubview(sloganLabel)
        addSubview(appleSignInButton)
        addSubview(corpName)
        addSubview(activityIndicator)
        addSubview(activityIndicatorLabel)
    }

    func setAutoLayout() {
        appLogoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(54)
            make.centerY.equalToSuperview()
            make.height.equalTo(54)
        }

        sloganLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appLogoView.snp.top).offset(-16)
            make.width.equalTo(154)
            make.height.equalTo(30)
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

        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(appLogoView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        activityIndicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
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
