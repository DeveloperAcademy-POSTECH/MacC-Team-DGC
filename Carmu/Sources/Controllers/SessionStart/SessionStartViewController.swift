//
//  SessionStartViewController.swift
//  Carmu
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

import Firebase
import FirebaseDatabase
import FirebaseFunctions
import FirebaseMessaging
import SnapKit

final class SessionStartViewController: UIViewController {

    private let sessionStartView = SessionStartView()
    private let sessionStartMidView = SessionStartMidView()
    private let sessionStartMidNoCrewView = SessionStartMidNoCrewView()
    private let firebaseManager = FirebaseManager()

    // 데이터가 없을 때
    let crewData: [Crew]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()

        sessionStartView.myPageButton.addTarget(self, action: #selector(myPageButtonDidTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        checkCrew()
    }
}

// MARK: Layout
extension SessionStartViewController {
    private func setupUI() {
        view.addSubview(sessionStartView)
        view.addSubview(sessionStartMidView)
        view.addSubview(sessionStartMidNoCrewView)
    }
    private func setupConstraints() {
        sessionStartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // 크루가 없을 때
    private func settingNoCrewView() {
        sessionStartMidView.isHidden = true
        sessionStartMidNoCrewView.isHidden = false

        sessionStartMidNoCrewView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(sessionStartView.topComment.snp.bottom).offset(36)
            make.bottom.equalToSuperview().inset(165)
        }
    }
    // 크루가 있을 때
    private func settingCrewView() {
        sessionStartMidView.isHidden = false
        sessionStartMidNoCrewView.isHidden = true
    }
}

// MARK: Actions
extension SessionStartViewController {

    @objc private func myPageButtonDidTapped() {
        let myPageVC = MyPageViewController()
        navigationController?.pushViewController(myPageVC, animated: true)
    }

    // 크루의 유무 확인
    private func checkCrew() {
        if crewData == nil {
            settingNoCrewView()
        } else {
            settingCrewView()
        }
    }
}

extension SessionStartViewController {

    // 디바이스 토큰값이 업데이트가 될 수도 있기 때문에 업데이트된 값을 저장하기 위한 메서드
    private func settingDeviceToken() {
        print("settingDeviceToken()")
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let fcmToken = KeychainItem.currentUserDeviceToken else {
            return
        }
        print("FCMToken -> ", fcmToken)
        databasePath.child("deviceToken").setValue(fcmToken as NSString)
    }
}
