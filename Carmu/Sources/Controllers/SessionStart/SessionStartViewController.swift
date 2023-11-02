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
    private let sessionStartDriverView = SessionStartDriverView()
    private let sessionStartPassengerView = SessionStartPassengerView()
    private let sessionStartNoGroupView = SessionStartNoGroupView()
    private let firebaseManager = FirebaseManager()

//    // 데이터가 없을 때
//    let groupData: Group? = nil

    // 데이터가 있을 때
    let groupData: Group? = Group(id: "1", name: "aa", captainID: "ted", crews: ["uni", "rei", "bazzi"])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        setupUI()
        setupConstraints()

        sessionStartView.myPageButton.addTarget(self, action: #selector(myPageButtonDidTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        checkGroup()
    }
}

// MARK: Layout
extension SessionStartViewController {
    private func setupUI() {
        view.addSubview(sessionStartView)
        view.addSubview(sessionStartDriverView)
        view.addSubview(sessionStartPassengerView)
        view.addSubview(sessionStartNoGroupView)
    }
    private func setupConstraints() {
        sessionStartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // 그룹이 없을 때
    private func settingNoGroupView() {
        sessionStartDriverView.isHidden = true
        sessionStartPassengerView.isHidden = true
        sessionStartNoGroupView.isHidden = false

        sessionStartNoGroupView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(sessionStartView.topComment.snp.bottom).offset(36)
            make.bottom.equalToSuperview().inset(165)
        }
    }
    // 그룹이 있을 때
    private func settingGroupView() {

        sessionStartNoGroupView.isHidden = true

        // TODO: - 데이터 형식에 맞춰서 수정
        if groupData?.captainID == "ted" {  // 운전자일 경우
            sessionStartDriverView.isHidden = false
            sessionStartPassengerView.isHidden = true

            sessionStartDriverView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalTo(sessionStartView.topComment.snp.bottom).offset(36)
                make.bottom.equalToSuperview().inset(165)
            }
        }

        // TODO: - 운전자인지, 크루원인지 구분하기

    }
}

// MARK: Actions
extension SessionStartViewController {

    @objc private func myPageButtonDidTapped() {
        let myPageVC = MyPageViewController()
        navigationController?.pushViewController(myPageVC, animated: true)
    }

    // 그룹의 유무 확인
    private func checkGroup() {
        if groupData == nil {
            settingNoGroupView()
        } else {
            settingGroupView()
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
