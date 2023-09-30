//
//  LoginViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/25.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import UIKit

final class LoginViewController: UIViewController {
    // 애플 로그인 파이어베이스 인증 시 재전송 공격을 방지하기 위해 요청에 포함시키는 임의의 문자열 값
    private var currentNonce: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setLoginViewLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        // 로그아웃 확인용 출력
        print("fullName: \(Auth.auth().currentUser?.displayName ?? "None")")
        print("email: \(Auth.auth().currentUser?.email ?? "None")")
        print("UUID: \(Auth.auth().currentUser?.uid ?? "None")")
    }
    // MARK: - 로그인 뷰 레이아웃 세팅
    func setLoginViewLayout() {
        // MARK: - 로고
        let logo = UIImageView(image: UIImage(systemName: "car"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logo)

        // MARK: - 로고 위 텍스트
        let logoUpperLabel = UILabel()
        logoUpperLabel.text = "여정을 연결하다."
        logoUpperLabel.font = UIFont.systemFont(ofSize: 22)
        logoUpperLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoUpperLabel)

        // MARK: - 로고 아래 텍스트
        let logoLowerLabel = UILabel()
        logoLowerLabel.text = "Carmu"
        logoLowerLabel.font = UIFont.systemFont(ofSize: 36)
        logoLowerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoLowerLabel)

        // MARK: - 애플 로그인 버튼
        let appleSignInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleSignInButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        appleSignInButton.cornerRadius = 20
        self.view.addSubview(appleSignInButton)

        // MARK: - 하단 회사명
        let corpLabel = UILabel()
        corpLabel.text = "@Damn Good Company"
        corpLabel.font = UIFont.systemFont(ofSize: 12)
        corpLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(corpLabel)

        // MARK: - 오토 레이아웃 세팅
        NSLayoutConstraint.activate([
            // 로고
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 수평 중앙 정렬
            logo.bottomAnchor.constraint(equalTo: appleSignInButton.topAnchor, constant: -202), // 간격 고정
            logo.widthAnchor.constraint(equalToConstant: 282), // width 고정
            logo.heightAnchor.constraint(equalToConstant: 141), // height 고정
            // 로고 위 텍스트
            logoUpperLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 수평 중앙 정렬
            logoUpperLabel.bottomAnchor.constraint(equalTo: logo.topAnchor, constant: -16), // logo 상단부와 간격 고정
            // 로고 아래 텍스트
            logoLowerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 수평 중앙 정렬
            logoLowerLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 20), // logo 하단부와 간격 고정
            // 애플 로그인 버튼
            appleSignInButton.bottomAnchor.constraint(equalTo: corpLabel.topAnchor, constant: -64), // corpLabel와 간격 고정
            appleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60), // 화면 왼쪽과 간격 고정
            appleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60), // 화면 오른쪽과 간격 고정
            appleSignInButton.heightAnchor.constraint(equalToConstant: 50), // height 고정
            // 하단 회사명
            corpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 수평 중앙 정렬
            corpLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16) // 간격 고정
        ])
    }
}

// MARK: - Authorization 처리 관련 델리게이트 프로토콜 구현
extension LoginViewController: ASAuthorizationControllerDelegate {
    // MARK: - 인증 성공 시 authorization을 리턴하는 메소드
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            fatalError("Credential을 찾을 수 없습니다.")
        }
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        // Firebase credential 초기화
        // → 애플 로그인에 성공했으면 해시되지 않은 nonce가 포함된 애플의 응답에서 ID 토큰을 사용하여 파이어베이스에도 인증을 수행해줍니다.
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)
        // 파이어베이스 인증 수행
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("파이어베이스 로그인 실패: \(error.localizedDescription)")
                return
            }
            print("\(authResult?.description ?? "")")
            print("fullName: \(Auth.auth().currentUser?.displayName ?? "None")")
            print("email: \(Auth.auth().currentUser?.email ?? "None")")
            print("UUID: \(Auth.auth().currentUser?.uid ?? "None")")
            // 로그인 성공 시 메인 탭 바 뷰로 이동
            let mainTabBarView = MainTabBarViewController()
            // present() 애니메이션 커스텀 (오른쪽->왼쪽)
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window?.layer.add(transition, forKey: kCATransition)
            mainTabBarView.modalPresentationStyle = .fullScreen
            self.present(mainTabBarView, animated: true)
        }
    }
    // MARK: - 인증 플로우가 정상적으로 끝나지 않았거나, credential이 존재하지 않을 때 호출
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패: \(error.localizedDescription)")
    }
}

// MARK: - 로그인 UI 표시 관련 델리게이트 프로토콜 구현
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - Firebase 인증 관련 익스텐션
/// https://firebase.google.com/docs/auth/ios/apple?hl=ko 참고
extension LoginViewController {
    // MARK: - 애플 로그인 버튼 클릭 시 동작
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        // Sign In with Apple 요청을 수행
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    // MARK: - 암호화된 nonce 생성 함수
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    // MARK: - SHA256 해시 함수
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

// MARK: - 프리뷰 canvas 세팅
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
