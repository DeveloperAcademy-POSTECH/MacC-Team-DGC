//
//  LoginViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/25.
//

import AuthenticationServices
import CryptoKit
import UIKit

import FirebaseAuth
import FirebaseDatabase
import SnapKit

final class LoginViewController: UIViewController {
    // 애플 로그인 파이어베이스 인증 시 재전송 공격을 방지하기 위해 요청에 포함시키는 임의의 문자열 값
    private var currentNonce: String?

    private let loginView = LoginView()

    private lazy var databasePath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        return Database.database().reference().child("\(User.databasePath)/\(uid)")
    }()

    private let encoder = JSONEncoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loginView.appleSignInButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
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
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        // 파이어베이스 인증 수행
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("파이어베이스 로그인 실패: \(error.localizedDescription)")
                return
            }
            // 파이어베이스의 user identifier(uid)를 키체인에 저장
            if let userIdentifier = authResult?.user.uid {
                self.saveUserInKeychain(userIdentifier)
            }

            // Firebase DB에 유저 정보 추가
            if let currentUser = Auth.auth().currentUser {
                self.uploadMyUserData(currentUser)
            }

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

    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.dgc.carmunication", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("키체인에 userIdentifier를 저장하지 못했습니다.")
        }
    }

    private func uploadMyUserData(_ currentUser: FirebaseAuth.User) {
        guard let databasePath = databasePath else {
            return
        }
        guard let userName = currentUser.displayName,
              let email = currentUser.email else {
            return
        }
        let user = User(userID: currentUser.uid, userName: userName, email: email)

        do {
            let data = try encoder.encode(user)

            let json = try JSONSerialization.jsonObject(with: data)

            databasePath.setValue(json)
        } catch {
            print("an error occurred", error)
        }
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
    @objc private func startSignInWithAppleFlow() {
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

        let charset = [Character]("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
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
