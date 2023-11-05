//
//  SettingsViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/09/29.
//

import AuthenticationServices
import CryptoKit
import UIKit

import FirebaseAuth
import FirebaseDatabase
import SnapKit

final class SettingsViewController: UIViewController {

    private let settingsView = SettingsView()
    private let firebaseManager = FirebaseManager()
    // 애플 로그인 파이어베이스 인증 시 재전송 공격을 방지하기 위해 요청에 포함시키는 임의의 문자열 값
    private var currentNonce: String?

    // 테이블 뷰 섹션과 row의 데이터
    enum Section: CaseIterable {
        case friendAndOthers // 친구 및 기타 섹션
        case accountManagement // 계정 관리 섹션
    }
    let friendAndOthersContents = ["친구 관리", "개인정보 처리방침", "문의하기"]
    let accountManagementContents = ["로그아웃", "회원 탈퇴"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.topItem?.title = "" // 백버튼 텍스트 제거

        view.addSubview(settingsView)
        settingsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        // 기본 UITableViewCell 셀을 재사용 식별자와 함께 테이블 뷰에 등록
        settingsView.settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        settingsView.settingsTableView.dataSource = self
        settingsView.settingsTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "설정"
    }

    // MARK: - 로그아웃 알럿
    private func showSignOutAlert() {
        let signOutAlert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        let signOutCancel = UIAlertAction(title: "취소", style: .cancel)
        let signOutOK = UIAlertAction(title: "확인", style: .destructive) { _ in
            let firebaseAuth = Auth.auth()
            do {
                // 로그아웃 수행
                try firebaseAuth.signOut()
                // 키체인에 저장된 User Identifier와 fcmToken을 삭제해준다.
                KeychainItem.deleteUserDataFromKeychain(account: "userIdentifier")
                KeychainItem.deleteUserDataFromKeychain(account: "FCMToken")

                // 최초 화면으로 돌아가기
                if let windowScene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first(where: { $0.activationState == .foregroundActive }),
                   let window = windowScene.windows.first {
                    window.rootViewController = LoginViewController()
                    window.makeKeyAndVisible()
                    print("로그아웃 성공!!")
                }
            } catch let signOutError as NSError {
                print("로그아웃 에러: \(signOutError)")
            }
        }
        signOutAlert.addAction(signOutCancel)
        signOutAlert.addAction(signOutOK)
        self.present(signOutAlert, animated: false)
    }

    // MARK: - 회원 탈퇴 알럿
    private func showDeleteAccountAlert() {
        let deleteAccountAlert = UIAlertController(title: "회원 탈퇴", message: "정말 계정을 삭제하시겠습니까?", preferredStyle: .alert)
        let deleteAccountCancel = UIAlertAction(title: "취소", style: .cancel)
        let deleteAccountOK = UIAlertAction(title: "확인", style: .destructive) { _ in
            self.deleteAccount()
        }
        deleteAccountAlert.addAction(deleteAccountCancel)
        deleteAccountAlert.addAction(deleteAccountOK)
        self.present(deleteAccountAlert, animated: false)
    }

    // MARK: - 계정 삭제 메소드
    private func deleteAccount() {
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

    // MARK: - 계정 삭제 수행 시 유저의 친구정보를 삭제하기 위한 메서드
    private func performDeletingUsersFriendship() {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        // 유저의 friends 배열을 불러온다.
        firebaseManager.readUserFriendshipList(databasePath: databasePath) { friends in
            guard let friends = friends else {
                return
            }
            // 해당하는 friendship을 삭제하고, 그 친구의 friends에서도 friendship을 삭제해준다.
            self.deleteRelatedAllFriendship(friendshipList: friends)
        }
    }

    // MARK: - 유저와 관련된 모든 친구 관계를 삭제하는 메서드
    /**
     - DB의 "friendship"에서 탈퇴하는 유저와 관련된 모든 friendship들을 삭제해줍니다.
     - 유저와 친구인 유저들의 "friends" 배열에서 해당 friendhip id값을 삭제해줍니다.

     **friendshipList**: 유저의 friends값에 해당하는 friendship id들의 배열
     */
    private func deleteRelatedAllFriendship(friendshipList: [String]) {
        let databaseRef = Database.database().reference()

        for friendshipID in friendshipList {
            firebaseManager.getFriendUid(friendshipID: friendshipID) { friendUID in
                guard let friendUID = friendUID else {
                    return
                }
                databaseRef.child("friendship/\(friendshipID)").removeValue() // friendship 삭제
                // 친구의 friends에서 해당 friendship 삭제
                self.firebaseManager.deleteUserFriendship(uid: friendUID, friendshipID: friendshipID)
            }
        }
    }
}

// MARK: - UITableViewDataSource 프로토콜 구현
extension SettingsViewController: UITableViewDataSource {

    // 섹션 수 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    // 각 섹션의 row 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return friendAndOthersContents.count
        } else {
            return accountManagementContents.count
        }
    }

    // 각 row에 대한 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = friendAndOthersContents[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell.textLabel?.text = accountManagementContents[indexPath.row]
            if indexPath.row == 1 {
                cell.textLabel?.textColor = .red
            }
        default:
            break
        }

        return cell
    }

    // 테이블 뷰 섹션 헤더 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "계정 관리"
    }
}

// MARK: - UITableViewDelegate 프로토콜 구현
extension SettingsViewController: UITableViewDelegate {

    // 테이블 뷰 섹션 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 1 else {
            return 0
        }
        return 23
    }

    // 테이블 뷰 셀을 눌렀을 때에 대한 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let friendListVC = FriendListViewController()
                navigationController?.pushViewController(friendListVC, animated: true)
            case 1:
                let privacyVC = PrivacyViewController()
                navigationController?.pushViewController(privacyVC, animated: true)
            case 2:
                let inquiryVC = InquiryViewController()
                navigationController?.pushViewController(inquiryVC, animated: true)
            default:
                break
            }
        } else {
            if indexPath.row == 0 {
                // 로그아웃 버튼 눌렀을 때
                showSignOutAlert()
            } else if indexPath.row == 1 {
                // 회원탈퇴 버튼 눌렀을 때
                showDeleteAccountAlert()
            }
        }
        // 클릭 후에는 셀의 선택이 해제된다.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Authorization 처리 관련 델리게이트 프로토콜 구현
extension SettingsViewController: ASAuthorizationControllerDelegate {

    // MARK: - 인증 성공 시 authorization을 리턴하는 메소드
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            fatalError("Credential을 찾을 수 없습니다.")
        }
        guard currentNonce != nil else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleAuthCode = appleIDCredential.authorizationCode else {
            print("Unable to fetch authorization code")
            return
        }
        guard let authCodeString = String(data: appleAuthCode, encoding: .utf8) else {
            print("Unable to serialize auth code string from data: \(appleAuthCode.debugDescription)")
            return
        }

        Task {
            do {
                // Storage에 저장된 유저 이미지 삭제
                guard let imageName = KeychainItem.currentUserIdentifier else {
                    return
                }
                firebaseManager.deleteProfileImage(imageName: "\(imageName).jpeg")
                // 유저와 관련된 친구 정보 삭제
                performDeletingUsersFriendship()
                // Firebase DB에서 유저 정보 삭제
                try await User.databasePathWithUID?.removeValue()
                // 애플 서버의 사용자 토큰 삭제
                try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                // 파이어베이스 서버의 계정 삭제
                try await Auth.auth().currentUser?.delete()
                // 키체인에 저장된 User Identifier와 fcmToken을 삭제해준다.
                KeychainItem.deleteUserDataFromKeychain(account: "userIdentifier")
                KeychainItem.deleteUserDataFromKeychain(account: "FCMToken")
                // 최초 화면으로 돌아가기
                if let windowScene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first(where: { $0.activationState == .foregroundActive }),
                   let window = windowScene.windows.first {
                    window.rootViewController = LoginViewController()
                    window.makeKeyAndVisible()
                    print("계정이 삭제되었습니다!!")
                }
            }
        }
    }

    // MARK: - 인증 플로우가 정상적으로 끝나지 않았거나, credential이 존재하지 않을 때 호출
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("인증이 정상적으로 마무리되지 않음: \(error.localizedDescription)")
    }
}

// MARK: - 로그인 UI 표시 관련 델리게이트 프로토콜 구현
extension SettingsViewController: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - Firebase 인증 관련 익스텐션
/// https://firebase.google.com/docs/auth/ios/apple?hl=ko 참고
extension SettingsViewController {

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
