//
//  MyPageViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

// MARK: - 내 정보 탭 화면 뷰 컨트롤러
final class MyPageViewController: UIViewController {
    // MARK: - 설정 버튼
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let symbol = UIImage(systemName: "gearshape", withConfiguration: symbolConfig)
        button.setImage(symbol, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - 상단 유저 정보 뷰
    lazy var userInfoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = userInfoView.bounds
        gradient.colors = [
            UIColor(hexCode: "627AF3").cgColor,
            UIColor(hexCode: "2CFFDC").cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    // MARK: - 닉네임 스택
    lazy var nicknameStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        return stack
    }()
    // 닉네임 라벨
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // 닉네임 편집 버튼
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("닉네임 편집하기✏️", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = UIColor(hexCode: "F1F3FF", alpha: 0.2)
        button.layer.cornerRadius = 12
        let verticalPad: CGFloat = 4.0
        let horizontalPad: CGFloat = 8.0
        button.contentEdgeInsets = UIEdgeInsets(
            top: verticalPad,
            left: horizontalPad,
            bottom: verticalPad,
            right: horizontalPad
        )
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - 프로필 이미지
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "profile")
        imgView.contentMode = .scaleAspectFill
        // TODO: - 추후 오토 레이아웃 비율에 맞게 수정 필요
        let size = CGFloat(80)
        imgView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        imgView.layer.cornerRadius = size / 2
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    // MARK: - 이미지 추가 버튼
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cameraBtn"), for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - 텍스트 필드
    lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        textField.placeholder = "입력하세요"
        textField.textAlignment = .center
        textField.textColor = .white
        textField.tintColor = .white
        textField.clearButtonMode = .always
        textField.borderStyle = .none

        if let placeholder = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        }
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            clearButton.tintColor = .white
        }
        return textField
    }()
    // MARK: - 텍스트 필드 활성화 시 어두운 배경
    lazy var darkOverlayView: UIView = {
        let darkOverlayView = UIView(frame: self.view.bounds)
        darkOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        darkOverlayView.addGestureRecognizer(tapGesture)
        return darkOverlayView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
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
    override func viewDidLayoutSubviews() {
        gradient.frame = userInfoView.bounds
    }
    // MARK: - 뷰 레이아웃 세팅 메소드
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(userInfoView)

        userInfoView.layer.addSublayer(gradient)
        userInfoView.addSubview(settingsButton)
        userInfoView.addSubview(nicknameStack)

        nicknameStack.addArrangedSubview(nicknameLabel)
        nicknameStack.addArrangedSubview(editButton)

        userInfoView.addSubview(imageView)
        userInfoView.addSubview(addButton)

        darkOverlayView.isHidden = true
        view.addSubview(darkOverlayView)
        textField.isHidden = true
        textField.delegate = self
        view.addSubview(textField)
        let bottomLine = UIView()
        bottomLine.backgroundColor = .white
        textField.addSubview(bottomLine)

        // MARK: - 오토 레이아웃
        userInfoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(320)
        }
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(12)
            make.trailing.equalToSuperview().inset(20)
        }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.trailing.equalTo(userInfoView.snp.trailing).inset(27)
            make.bottom.equalTo(userInfoView.snp.bottom).inset(59)
        }
        addButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView)
        }
        nicknameStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(userInfoView).inset(62)
        }
        editButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
        }
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(userInfoView.snp.bottom).inset(5)
        }
        bottomLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(8)
            make.height.equalTo(1)
        }
    }
    // 설정 페이지 이동 메소드
    @objc func showSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    // 어두운 뷰 탭하면 텍스트 필드 활성화
    @objc func dismissTextField() {
        textField.isHidden = true
        darkOverlayView.isHidden = true
        textField.resignFirstResponder()
    }
    // 닉네임 편집 버튼을 누르면 텍스트 필드 비활성화
    @objc func editButtonTapped() {
        textField.text = nicknameLabel.text
        textField.isHidden = false
        darkOverlayView.isHidden = false
        textField.becomeFirstResponder()
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
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
        }
        alert.addAction(album)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

// MARK: - 텍스트 필드 델리게이트 구현
extension MyPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: - DB 상에 닉네임 저장하는 로직 추가 필요
        nicknameLabel.text = textField.text
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
                self.imageView.image = editedImage
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
