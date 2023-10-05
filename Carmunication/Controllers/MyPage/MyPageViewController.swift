//
//  MyPageViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

import FirebaseAuth

// MARK: - 내 정보 탭 화면 뷰 컨트롤러
final class MyPageViewController: UIViewController {

    private let myPageView = MyPageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(myPageView)
        myPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        myPageView.settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        myPageView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        myPageView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        myPageView.darkOverlayView.addGestureRecognizer(tapGesture)

        myPageView.textField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 마이페이지에서는 내비게이션 바가 보이지 않도록 한다.
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 마이페이지에서 설정 화면으로 넘어갈 때는 내비게이션 바가 보이도록 해준다.
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    // subView들까지 모두 그려지면 호출되는 메소드
    override func viewDidLayoutSubviews() {
        myPageView.gradient.frame = myPageView.userInfoView.bounds
    }

    // 설정 페이지 이동 메소드
    @objc func showSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    // 어두운 뷰 탭하면 텍스트 필드 활성화
    @objc func dismissTextField() {
        myPageView.textField.isHidden = true
        myPageView.darkOverlayView.isHidden = true
        myPageView.textField.resignFirstResponder()
    }
    // 닉네임 편집 버튼을 누르면 텍스트 필드 비활성화
    @objc func editButtonTapped() {
        myPageView.textField.text = myPageView.nicknameLabel.text
        myPageView.textField.isHidden = false
        myPageView.darkOverlayView.isHidden = false
        myPageView.textField.becomeFirstResponder()
    }
    // 이미지 추가 버튼 클릭 시 액션 시트 호출
    @objc func addButtonTapped() {
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
        // TODO: - DB 상에 닉네임 저장하는 로직 추가 필요
        myPageView.nicknameLabel.text = textField.text
        dismissTextField()
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

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct MyPageViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyPageViewController
    func makeUIViewController(context: Context) -> MyPageViewController {
        return MyPageViewController()
    }
    func updateUIViewController(_ uiViewController: MyPageViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct MyPageViewPreview: PreviewProvider {
    static var previews: some View {
        MyPageViewControllerRepresentable()
    }
}
