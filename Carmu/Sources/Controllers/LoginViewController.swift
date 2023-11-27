//
//  LoginViewController.swift
//  Carmu
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
    private let firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        loginView.appleSignInButton.addTarget(
            self,
            action: #selector(startSignInWithAppleFlow),
            for: .touchUpInside
        )

        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
// MARK: - Authorization 처리 관련 델리게이트 프로토콜 구현
extension LoginViewController: ASAuthorizationControllerDelegate {

    // MARK: - 인증 성공 시 authorization을 리턴하는 메소드
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
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
                print("키체인에 UID를 저장하는 중...")
                self.saveUserInKeychain(userIdentifier)
                print("키체인에 UID를 저장했습니다!!!")
            }
            // Firebase DB에 유저 정보 추가
            if let currentUser = Auth.auth().currentUser {
                self.saveToDB(user: currentUser)
            }

            // 온보딩을 진행했는지 여부에 대한 isFirst값에 따라서 넘어가는 화면이 달라진다.
            if UserDefaults.standard.object(forKey: "isFirst") as? Bool ?? true {
                let positionSelectVC = PositionSelectViewController()
                self.navigationController?.pushViewController(positionSelectVC, animated: true)
            } else {
                let sessionStartVC = SessionStartViewController()
                self.navigationController?.pushViewController(sessionStartVC, animated: true)
            }
        }
    }

    // MARK: - 인증 플로우가 정상적으로 끝나지 않았거나, credential이 존재하지 않을 때 호출
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패: \(error.localizedDescription)")
    }

    private func saveUserInKeychain(_ userIdentifier: String) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }
        do {
            try KeychainItem(service: bundleIdentifier, account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("키체인에 userIdentifier를 저장하지 못했습니다.")
        }
    }

    // 인증 후 사용자 정보를 DB에 저장하는 메서드
    private func saveToDB(user firebaseUser: FirebaseAuth.User) {
        // 파이어베이스에 저장된 유저가 있는지 여부에 따라서 CREATE 혹은 UPDATE
        Task {
            guard let databasePath = User.databasePathWithUID else {
                return
            }
            let user = try await firebaseManager.readUser(databasePath: databasePath)
            if let user = user {
                print("user 데이터 있음: \(user)")
                firebaseManager.updateUser(user: firebaseUser, updatedUser: user)
            } else {
                print("user 데이터 없음: \(String(describing: user))")
                firebaseManager.createUser(user: firebaseUser)
            }
            print("Firebase DB에 유저 정보가 추가/업데이트 되었습니다!!!")
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
