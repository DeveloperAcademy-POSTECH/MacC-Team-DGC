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
    let friendAndOthersContents = ["개인정보 처리방침", "문의하기"]
    let accountManagementContents = ["로그아웃", "회원 탈퇴"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

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
            self.showActivityIndicatorLoading(process: "로그아웃")
            let firebaseAuth = Auth.auth()
            do {
                // 로그아웃 수행
                try firebaseAuth.signOut()
                // 키체인에 저장된 User Identifier를 삭제해준다.
                KeychainItem.deleteUserDataFromKeychain(account: "userIdentifier")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.hideActivityIndicatorLoading()
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
        let deleteAccountAlert = UIAlertController(title: "카뮤에서 탈퇴하시겠습니까?", message: "탈퇴 시 카뮤 앱 내의\n모든 정보가 사라집니다.", preferredStyle: .alert)
        let deleteAccountCancel = UIAlertAction(title: "돌아가기", style: .cancel)
        let deleteAccountOK = UIAlertAction(title: "회원탈퇴", style: .destructive) { _ in
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

    /**
     계정 삭제 시 크루에서 유저 정보를 삭제해주기 위한 메서드
     - 크루 데이터 불러오기 👉 운전자/동승자 체크 👉 그에 맞게 크루에서 정보 삭제(or 크루 삭제)
     */
    private func deleteCrewDataOfUser() async throws {
        do {
            // 크루 데이터 불러오기
            if let crewID = try await firebaseManager.readUserCrewID() {
                guard let crewData = try await firebaseManager.getCrewData(crewID: crewID) else { return }

                if firebaseManager.isDriver(crewData: crewData) { // 운전자라면
                    print("운전자의 크루 데이터와 크루 삭제 중...")
                    try await firebaseManager.deleteCrewByDriver()
                } else { // 동승자라면
                    print("동승자의 크루 데이터 삭제 중...")
                    try await firebaseManager.deletePassengerInfoFromCrew()
                }
            } else {
                print("소속한 크루가 없기 때문에 삭제 작업을 수행하지 않습니다.")
            }
        } catch {
            print("유저와 관련된 크루 정보 삭제 중 오류 발생")
        }
    }

    private func showActivityIndicatorLoading(process: String) {
        print("\(process) 대기 중...")
        settingsView.isUserInteractionEnabled = false // 터치 이벤트 제한
        settingsView.activityIndicator.startAnimating()
        settingsView.activityIndicatorLabel.text = "\(process) 중..."
        settingsView.activityIndicatorLabel.isHidden = false
    }
    private func hideActivityIndicatorLoading() {
        print("대기 종료")
        settingsView.isUserInteractionEnabled = true // 터치 이벤트 제한 해제
        settingsView.activityIndicator.stopAnimating()
        settingsView.activityIndicatorLabel.isHidden = true
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
        cell.backgroundColor = UIColor.semantic.backgroundDefault
        cell.textLabel?.textColor = UIColor.semantic.textPrimary

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = friendAndOthersContents[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.tintColor = UIColor.semantic.stoke
            let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
            if let width = image?.size.width, let height = image?.size.height {
                let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                disclosureImageView.image = image
                cell.accessoryView = disclosureImageView
            }
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

    // 테이블 뷰 섹션 헤더 제목 색상
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor.semantic.textBody
        }
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
                let privacyVC = PrivacyViewController()
                navigationController?.pushViewController(privacyVC, animated: true)
            case 1:
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
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        showActivityIndicatorLoading(process: "회원 탈퇴")
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
                // 유저와 관련된 크루 데이터 삭제
                try await deleteCrewDataOfUser()
                // Firebase DB에서 유저 정보 삭제
                try await firebaseManager.deleteUser()
                // 키체인에 저장된 User Identifier를 삭제해준다.
                KeychainItem.deleteUserDataFromKeychain(account: "userIdentifier")
                print("회원탈퇴 처리 중...")
                // 애플 서버의 사용자 토큰 삭제
                try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                print("애플 로그인 정보가 삭제되었습니다!!, \(String(describing: Auth.auth().currentUser))")
                // 파이어베이스 서버의 계정 삭제
                try await Auth.auth().currentUser?.delete()
                print("유저의 파이어베이스 Authentication 정보가 삭제되었습니다!!, \(String(describing: Auth.auth().currentUser))")
                UserDefaults.standard.set(true, forKey: "isFirst") // isFirst값 초기화
                // SceneDelegate의 updateRootViewController가 실행되며 대기하는 3초동안 기다린 후 activity indicator 숨김
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.hideActivityIndicatorLoading()
                }
            } catch {
                print("회원탈퇴 처리 중 오류 발생")
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
