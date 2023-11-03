//
//  MyPageViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

// MARK: - 내 정보 탭 화면 뷰 컨트롤러
final class MyPageViewController: UIViewController {

    private let myPageView = MyPageView()
    private let firebaseManager = FirebaseManager()

    var selectedProfileType: ProfileType = .blue // 프로필 이미지를 표시해주기 위한 ProfileType 값
    var selectedProfileTypeIdx: Int {
        // 컬렉션 뷰 셀의 인덱스에 대응하도록 ProfileType 값의 인덱스를 반환하는 프로퍼티
        return ProfileType.allCases.firstIndex(of: selectedProfileType) ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // 유저 정보 불러와서 닉네임, 프로필 표시
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        firebaseManager.readUser(databasePath: databasePath) { userData in
            guard let userData = userData else {
                return
            }
            self.myPageView.nicknameLabel.text = userData.nickname
            self.selectedProfileType = userData.profileType
            self.updateProfileImageView(profileType: self.selectedProfileType)
        }

        let backButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem

        view.addSubview(myPageView)
        myPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        myPageView.settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        myPageView.editButton.addTarget(self, action: #selector(showTextField), for: .touchUpInside)
        myPageView.addButton.addTarget(self, action: #selector(showProfileChangeView), for: .touchUpInside)
        myPageView.textFieldEditCancelButton.addTarget(self, action: #selector(dismissTextField), for: .touchUpInside)
        myPageView.textFieldEditDoneButton.addTarget(self, action: #selector(changeNickname), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        myPageView.darkOverlayView.addGestureRecognizer(tapGesture)

        myPageView.textField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 마이페이지에서는 내비게이션 바가 보이지 않도록 한다.
        navigationController?.setNavigationBarHidden(true, animated: false)
        // 마이페이지에서는 탭 바가 보이도록 한다.
        tabBarController?.tabBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 마이페이지에서 설정 화면으로 넘어갈 때는 내비게이션 바가 보이도록 해준다.
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // 프로필 이미지뷰를 업데이트해주는 메서드
    func updateProfileImageView(profileType: ProfileType) {
        print("프로필 이미지 뷰 업데이트!!!")
        self.myPageView.imageView.image = UIImage(profileType: profileType)
    }
}

// MARK: - @objc 메서드
extension MyPageViewController {

    // 설정 페이지 이동 메소드
    @objc private func showSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // 어두운 뷰 탭하면 텍스트 필드 비활성화
    @objc private func dismissTextField() {
        myPageView.textField.isHidden = true
        myPageView.darkOverlayView.isHidden = true
        myPageView.textFieldEditStack.isHidden = true
        myPageView.textField.resignFirstResponder()
    }

    // 닉네임 편집 버튼을 누르면 텍스트 필드 활성화
    @objc private func showTextField() {
        myPageView.textField.text = myPageView.nicknameLabel.text
        myPageView.textField.isHidden = false
        myPageView.darkOverlayView.isHidden = false
        myPageView.textFieldEditStack.isHidden = false
        myPageView.textField.becomeFirstResponder()
    }

    // [확인] 혹은 키보드의 엔터 버튼을 눌렀을 때 닉네임 수정사항을 DB에 반영해주는 메서드
    @objc private func changeNickname() {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let newNickname = myPageView.textField.text else {
            return
        }
        databasePath.child("nickname").setValue(newNickname as NSString)

        myPageView.nicknameLabel.text = myPageView.textField.text
        dismissTextField()
    }

    // 프로필 설정 버튼 클릭 시 호출
    @objc private func showProfileChangeView() {
        let profileChangeVC = ProfileChangeViewController()
        profileChangeVC.delegate = self
        profileChangeVC.selectedProfileTypeIdx = selectedProfileTypeIdx
        profileChangeVC.modalPresentationStyle = .formSheet
        self.present(profileChangeVC, animated: true)
    }
}

// MARK: - 텍스트 필드 델리게이트 구현
extension MyPageViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeNickname()
        return true
    }
}

// MARK: - ProfileChangeViewControllerDelegate 델리게이트 구현
/**
 ProfileChangeViewController에서 프로필 타입 데이터가 변경되었을 때를 감지하여 호출
 */
extension MyPageViewController: ProfileChangeViewControllerDelegate {

    func sendProfileType(profileType: ProfileType) {
        selectedProfileType = profileType
        updateProfileImageView(profileType: profileType)
    }
}
