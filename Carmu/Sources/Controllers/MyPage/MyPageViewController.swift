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

    var selectedProfileImageColor: ProfileImageColor = .blue // 프로필 이미지를 표시해주기 위한 ProfileImageColor 값
    var selectedProfileImageColorIdx: Int {
        // 컬렉션 뷰 셀의 인덱스에 대응하도록 ProfileImageColor 값의 인덱스를 반환하는 프로퍼티
        return ProfileImageColor.allCases.firstIndex(of: selectedProfileImageColor) ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundSecond

        // 내비게이션 바 appearance 설정 (배경색)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.semantic.backgroundDefault
        appearance.shadowColor = .red
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        // 백버튼 텍스트 제거
        navigationController?.navigationBar.topItem?.title = ""
        // 설정 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
        navigationController?.view.addSubview(myPageView.darkOverlayView)

        // 유저 정보 불러와서 닉네임, 프로필 표시
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        firebaseManager.readUser(databasePath: databasePath) { userData in
            guard let userData = userData else {
                return
            }
            self.myPageView.nicknameLabel.text = userData.nickname
            self.selectedProfileImageColor = userData.profileImageColor
            self.updateProfileImageView(profileImageColor: self.selectedProfileImageColor)
        }

        view.addSubview(myPageView)
        myPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 버튼에 Target 추가
        myPageView.nicknameEditButton.addTarget(self, action: #selector(showTextField), for: .touchUpInside)
        myPageView.profileImageEditButton.addTarget(self, action: #selector(showProfileChangeView), for: .touchUpInside)
        myPageView.textFieldEditCancelButton.addTarget(self, action: #selector(dismissTextField), for: .touchUpInside)
        myPageView.textFieldEditDoneButton.addTarget(self, action: #selector(changeNickname), for: .touchUpInside)

        // darkOverlayView가 내비게이션 바까지 덮을 수 있도록 내비게이션 컨트롤러의 뷰에 대해 subView로 추가해준다.
        navigationController?.view.addSubview(myPageView.darkOverlayView)
        myPageView.darkOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        myPageView.darkOverlayView.addGestureRecognizer(tapGesture)

        myPageView.nicknameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "My Page"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // 프로필 이미지뷰를 업데이트해주는 메서드
    func updateProfileImageView(profileImageColor: ProfileImageColor) {
        print("프로필 이미지 뷰 업데이트!!!")
        myPageView.profileImageView.image = UIImage(profileImageColor: profileImageColor)
    }
}

// MARK: - @objc 메서드
extension MyPageViewController {

    // 설정 페이지 이동 메소드
    @objc private func showSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // 어두운 뷰 탭하면 텍스트 필드를 포함하고 있는 darkOverlayView 비활성화
    @objc private func dismissTextField() {
        myPageView.darkOverlayView.isHidden = true
        myPageView.nicknameTextField.resignFirstResponder()
    }

    // 닉네임 편집 버튼을 누르면 텍스트 필드를 포함하고 있는 darkOverlayView 활성화
    @objc private func showTextField() {
        myPageView.nicknameTextField.text = myPageView.nicknameLabel.text
        myPageView.darkOverlayView.isHidden = false
        myPageView.nicknameTextField.becomeFirstResponder()
    }

    // [확인] 혹은 키보드의 엔터 버튼을 눌렀을 때 닉네임 수정사항을 DB에 반영해주는 메서드
    @objc private func changeNickname() {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let newNickname = myPageView.nicknameTextField.text else {
            return
        }
        databasePath.child("nickname").setValue(newNickname as NSString)

        myPageView.nicknameLabel.text = myPageView.nicknameTextField.text
        dismissTextField()
    }

    // 프로필 설정 버튼 클릭 시 호출
    @objc private func showProfileChangeView() {
        let profileChangeVC = ProfileChangeViewController()
        profileChangeVC.delegate = self
        profileChangeVC.selectedProfileImageColorIdx = selectedProfileImageColorIdx
        profileChangeVC.modalPresentationStyle = .formSheet
        present(profileChangeVC, animated: true)
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
 ProfileChangeViewController에서 프로필 이미지 데이터가 변경되었을 때를 감지하여 호출
 */
extension MyPageViewController: ProfileChangeViewControllerDelegate {

    func sendProfileImageColor(profileImageColor: ProfileImageColor) {
        selectedProfileImageColor = profileImageColor
        updateProfileImageView(profileImageColor: profileImageColor)
    }
}
