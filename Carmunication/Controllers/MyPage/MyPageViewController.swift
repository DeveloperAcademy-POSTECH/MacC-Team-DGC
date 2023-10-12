//
//  MyPageViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase

// MARK: - 내 정보 탭 화면 뷰 컨트롤러
final class MyPageViewController: UIViewController {

    private let myPageView = MyPageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // 닉네임 불러오기
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        readNickname(databasePath: databasePath) { storedNickname in
            guard let storedNickname = storedNickname else {
                return
            }
            self.myPageView.nicknameLabel.text = storedNickname
        }

        let backButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem

        view.addSubview(myPageView)
        myPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        myPageView.settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        myPageView.editButton.addTarget(self, action: #selector(showTextField), for: .touchUpInside)
        myPageView.addButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
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

    // MARK: - DB에서 닉네임 불러오는 메서드
    func readNickname(databasePath: DatabaseReference, completion: @escaping (String?) -> Void) {
        databasePath.child("nickname").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            let nickname = snapshot?.value as? String
            completion(nickname)
        }
    }
}

// MARK: - @objc 메서드
extension MyPageViewController {

    // 설정 페이지 이동 메소드
    @objc func showSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    // 어두운 뷰 탭하면 텍스트 필드 비활성화
    @objc func dismissTextField() {
        myPageView.textField.isHidden = true
        myPageView.darkOverlayView.isHidden = true
        myPageView.textFieldEditStack.isHidden = true
        myPageView.textField.resignFirstResponder()
    }
    // 닉네임 편집 버튼을 누르면 텍스트 필드 활성화
    @objc func showTextField() {
        myPageView.textField.text = myPageView.nicknameLabel.text
        myPageView.textField.isHidden = false
        myPageView.darkOverlayView.isHidden = false
        myPageView.textFieldEditStack.isHidden = false
        myPageView.textField.becomeFirstResponder()
    }
    // [확인] 혹은 키보드의 엔터 버튼을 눌렀을 때 닉네임 수정사항을 DB에 반영해주는 메서드
    @objc func changeNickname() {
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
    // 이미지 추가 버튼 클릭 시 액션 시트 호출
    @objc func showImagePicker() {
        let alert = UIAlertController(
            title: "프로필 사진 설정",
            message: nil,
            preferredStyle: .actionSheet
        )
        let album = UIAlertAction(title: "앨범에서 사진/동영상 선택", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(album)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

// MARK: - 텍스트 필드 델리게이트 구현
extension MyPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeNickname()
        return true
    }
}

// MARK: - 이미지 피커 델리게이트 구현
extension MyPageViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false)
    }
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: false) { () in
            if let editedImage = info[.editedImage] as? UIImage {
                // TODO: - DB 상에 프로필 이미지 저장하는 로직 추가 필요
                self.myPageView.imageView.image = editedImage
            }
        }
    }
}
extension MyPageViewController: UINavigationControllerDelegate {}
