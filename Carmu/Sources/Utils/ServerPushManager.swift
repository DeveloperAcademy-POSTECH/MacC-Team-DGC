//
//  ServerPushManager.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/20.
//

import UIKit

import Firebase
import FirebaseDatabase
import FirebaseFunctions
import FirebaseMessaging
import SnapKit

// MARK: - 서버 푸시 관련 메서드
final class ServerPushManager {

    private let functions = Functions.functions()

    // 운전자가 탑승자에게 서버 푸시 알림을 보내는 메서드
    func pushToAllPassenger(crewData: Crew) {

        guard let memberStatus = crewData.memberStatus else { return }
        for member in memberStatus {
            guard let status = member.status else { return }
            if let deviceToken = member.deviceToken, status == .accept {
                functions
                    .httpsCallable("journeyStartNotification")
                    .call(["token": deviceToken]) { (result, error) in
                        if let error = error {
                            print("Error calling Firebase Functions: \(error.localizedDescription)")
                        } else {
                            if let data = (result?.data as? [String: Any]) {
                                print("Response data --> ", data)
                            }
                        }
                    }
            }
        }
    }
}
