//
//  MyPageViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

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
        // 프로필 이미지 불러오기
        readProfileImageURL(databasePath: databasePath) { imageURL in
            guard let imageURL = imageURL else {
                // 설정한 이미지가 없으면 기본 프로필 설정
                print("프로필 이미지가 없습니다.")
                self.myPageView.imageView.image = UIImage(named: "profile")
                return
            }
            // 설정한 이미지가 있으면 프로필 이미지 뷰에 반영
            if !imageURL.isEmpty {
                print("프로필 이미지가 있습니다.")
                self.loadProfileImage(urlString: imageURL) { profileImage in
                    guard let profileImage = profileImage else {
                        return
                    }
                    self.myPageView.imageView.image = profileImage
                }
            } else {
                print("프로필 이미지가 없습니다.")
                self.myPageView.imageView.image = UIImage(named: "profile")
            }
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

    // 이미지 추가 버튼 클릭 시 액션 시트 호출
    @objc private func showImagePicker() {
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
        let defaultProfile = UIAlertAction(title: "기본 프로필 선택", style: .default) { _ in
            self.addImageUrlToDB(imageURL: nil) // 유저 DB의 imageURL 값을 nil로 설정
            // Storage에서 이미지 삭제
            guard let imageName = KeychainItem.currentUserIdentifier else {
                return
            }
            self.deleteProfileImage(imageName: "\(imageName).jpeg")
            self.myPageView.imageView.image = UIImage(named: "profile")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(album)
        alert.addAction(defaultProfile)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

// MARK: - Firebase Realtime Database DB 관련 메서드
extension MyPageViewController {

    // MARK: - DB에서 닉네임 불러오는 메서드
    private func readNickname(databasePath: DatabaseReference, completion: @escaping (String?) -> Void) {
        databasePath.child("nickname").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            let nickname = snapshot?.value as? String
            completion(nickname)
        }
    }

    // MARK: - DB 유저 정보에 이미지 경로 저장
    private func addImageUrlToDB(imageURL: String?) {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let imageURL = imageURL else {
            databasePath.child("imageURL").setValue(nil)
            return
        }
        databasePath.child("imageURL").setValue(imageURL as NSString)
    }

    // MARK: - DB에서 유저 이미지 경로 불러오기
    private func readProfileImageURL(databasePath: DatabaseReference, completion: @escaping (String?) -> Void) {
        databasePath.child("imageURL").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshotValue = snapshot?.value else {
                completion(nil)
                return
            }
            let imageURL = snapshotValue as? String
            completion(imageURL)
        }
    }
}

// MARK: - Firebase Storage 관련 메서드
extension MyPageViewController {

    // MARK: - 파이어베이스 Storage에 이미지 업로드
    private func uploadImageToStorage(image: UIImage, imageName: String, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        // 파이어베이스 Storage에 대한 참조
        let firebaseStorageRef = Storage.storage().reference().child("images/\(imageName)")
        firebaseStorageRef.putData(imageData, metadata: metaData) { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            firebaseStorageRef.downloadURL { url, _ in
                completion(url)
            }
        }
    }

    // MARK: - 파이어베이스 Storage에서 유저 이미지 불러오기
    private func loadProfileImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let firebaseStorageRef = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)

        firebaseStorageRef.getData(maxSize: megaByte) { data, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }

    // MARK: - 파이어베이스 Storage에서 유저 이미지 삭제하기
    private func deleteProfileImage(imageName: String) {
        let firebaseStorageRef = Storage.storage().reference().child("images/\(imageName)")
        firebaseStorageRef.delete { error in
            if let error = error {
                print("이미지 삭제에 실패했습니다.", error.localizedDescription)
            } else {
                print("이미지가 성공적으로 삭제되었습니다.")
            }
        }
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
                guard let imageName = KeychainItem.currentUserIdentifier else {
                    return
                }
                // 파이어베이스 Storage에 이미지 저장
                self.uploadImageToStorage(image: editedImage, imageName: "\(imageName).jpeg") { url in
                    guard let imageURL = url else {
                        return
                    }
                    // 이미지 경로를 Realtime Database DB 유저 정보에 저장
                    self.addImageUrlToDB(imageURL: imageURL.absoluteString)
                }
                self.myPageView.imageView.image = editedImage
            }
        }
    }
}
extension MyPageViewController: UINavigationControllerDelegate {}
