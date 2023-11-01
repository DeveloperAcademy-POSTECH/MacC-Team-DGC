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
    private let sessionStartMidNoGroupView = SessionStartMidNoGroupView()
    private let firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: Layout
extension SessionStartViewController {

}

// MARK: Actions
extension SessionStartViewController {

}

// MARK: - Firebase Realtime Database DB 관련 메서드
extension SessionStartViewController {

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
