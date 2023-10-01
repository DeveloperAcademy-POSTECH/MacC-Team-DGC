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
        button.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - 상단 유저 정보 뷰
    lazy var userInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // 닉네임 편집 버튼
    lazy var configButton: UIButton = {
        let button = UIButton()
        button.setTitle("닉네임 편집하기✏️", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 12
        let verticalPad: CGFloat = 4.0
        let horizontalPad: CGFloat = 8.0
        button.contentEdgeInsets = UIEdgeInsets(
            top: verticalPad,
            left: horizontalPad,
            bottom: verticalPad,
            right: horizontalPad
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - 프로필 이미지
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "profile")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    // MARK: - 이미지 추가 버튼
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cameraBtn"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    // MARK: - 뷰 레이아웃 세팅 메소드
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(userInfoView)

        // TODO: - userInfoView에 그라데이션 적용 (전체 뷰에 하면 적용되는데 userInfoView에는 적용되지 않는 문제)
        let gradient = CAGradientLayer()
        gradient.frame = userInfoView.bounds
        gradient.colors = [UIColor(hexCode: "627AF3").cgColor, UIColor(hexCode: "2CFFDC").cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        userInfoView.layer.addSublayer(gradient)

        userInfoView.addSubview(settingsButton)
        userInfoView.addSubview(nicknameStack)

        nicknameStack.addArrangedSubview(nicknameLabel)
        nicknameStack.addArrangedSubview(configButton)

        userInfoView.addSubview(imageView)
        userInfoView.addSubview(addButton)

        NSLayoutConstraint.activate([
            // 상단 유저 정보 뷰
            userInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            userInfoView.heightAnchor.constraint(equalToConstant: 320),

            // 설정 버튼
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            // 프로필 이미지
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor, constant: -27),
            imageView.bottomAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: -59),
            addButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            // 닉네임
            nicknameStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameStack.bottomAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: -62),
            configButton.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 5)
        ])
    }
    // 설정 페이지 이동 메소드
    @objc func showSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

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
