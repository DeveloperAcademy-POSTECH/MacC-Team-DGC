//
//  MyPageViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

// MARK: - 내 정보 탭 화면 뷰 컨트롤러
final class MyPageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // 친구 목록 버튼
        let friendListButton = UIButton()
        friendListButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        friendListButton.addTarget(self, action: #selector(showFriendList), for: .touchUpInside)
        friendListButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(friendListButton)
        // 설정 버튼
        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsButton)

        // MARK: - 상단 유저 정보 뷰
        let userInfoView = UIView()
        userInfoView.backgroundColor = .white
        userInfoView.layer.cornerRadius = 16
        userInfoView.layer.shadowColor = UIColor.black.cgColor
        userInfoView.layer.shadowOpacity = 0.5
        userInfoView.layer.shadowOffset = CGSize(width: 0, height: 1)
        userInfoView.layer.shadowRadius = 5
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userInfoView)
        view.sendSubviewToBack(userInfoView)

        // MARK: - 하단 기타 정보 뷰
        let otherInfoView = UIView()
        otherInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(otherInfoView)

        // MARK: - 오토 레이아웃 설정
        NSLayoutConstraint.activate([
            // 친구 목록 버튼
            friendListButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            friendListButton.widthAnchor.constraint(equalToConstant: 50),
            friendListButton.heightAnchor.constraint(equalToConstant: 50),
            // 설정 버튼
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            settingsButton.widthAnchor.constraint(equalToConstant: 50),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),

            // 상단 유저 정보 뷰
            userInfoView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            userInfoView.heightAnchor.constraint(equalToConstant: 320),
            userInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userInfoView.bottomAnchor.constraint(equalTo: otherInfoView.topAnchor, constant: -1),
            // 하단 기타 정보 뷰
            otherInfoView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            otherInfoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    @objc func showFriendList() {
        let friendListVC = FriendListViewController()
        navigationController?.pushViewController(friendListVC, animated: true)
    }
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
