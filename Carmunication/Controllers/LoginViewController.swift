//
//  LoginViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/25.
//

import AuthenticationServices
import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSignInWithAppleButton()
    }
    
    // MARK: - 애플 로그인 버튼
    func setSignInWithAppleButton() {
        let appleSignInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(appleSignInButton)
        appleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 300).isActive = true
    }
}




// MARK: - Preview canvas 세팅
import SwiftUI

struct LoginViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = LoginViewController
    
    func makeUIViewController(context: Context) -> LoginViewController {
        return LoginViewController()
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct LoginViewPreview: PreviewProvider {
    static var previews: some View {
        LoginViewControllerRepresentable()
    }
}
