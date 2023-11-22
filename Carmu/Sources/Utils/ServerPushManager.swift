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

    private let firebaseManager = FirebaseManager()
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

    // 운전자가 탑승자에게 지각 알림을 보내는 메서드
    func sendLateToAllPassenger(lateMin: String, crew: Crew) {

        guard let memberStatus = crew.memberStatus else { return }
        for member in memberStatus {
            guard let status = member.status else { return }
            if let deviceToken = member.deviceToken, status == .accept {
                functions
                    .httpsCallable("lateNotificationToPassenger")
                    .call(["token": deviceToken, "lateMin": lateMin]) { (result, error) in
                        if let error = error {
                            print("Error ", error.localizedDescription)
                        } else {
                            if let data = (result?.data as? [String: Any]) {
                                print("Response data --> ", data)
                            }
                        }
                    }
            }
        }
    }

    // 탑승자가 운전자에게 지각 알림을 보내는 메서드
    func sendLateToDriver(lateMin: String, crew: Crew) {
        guard let memberStatus = crew.memberStatus else { return }
        var userNickname = ""

        for member in memberStatus where member.id == KeychainItem.currentUserIdentifier {
            userNickname = member.nickname ?? ""
        }

        guard let captainID = crew.captainID else { return }

        Database.database().reference().child("users/\(captainID)").getData { error, snapshot in
            if let error = error {
                print("Error ", error.localizedDescription)
                return
            }
            let captainData = snapshot?.value as? [String: Any]
            guard let captainDeviceToken = captainData?["deviceToken"] else { return }

            let data = ["token": captainDeviceToken, "lateMin": lateMin, "nickname": userNickname]

            self.functions
                .httpsCallable("lateNotificationToDriver")
                .call(data) { (_, error) in
                    if let error = error {
                        print("error --> ", error.localizedDescription)
                    } else {
                        print("Success sending data")
                    }
                }
        }
    }

    // 탑승자가 포기하기 클릭했을 때 운전자에게 알림을 보내는 메서드
    func sendGiveupToDriver(crew: Crew) {
        guard let memberStatus = crew.memberStatus else { return }
        var userNickname = ""

        for member in memberStatus where member.id == KeychainItem.currentUserIdentifier {
            userNickname = member.nickname ?? ""
        }

        guard let captainID = crew.captainID else { return }

        Database.database().reference().child("users/\(captainID)").getData { error, snapshot in
            if let error = error {
                print("Error ", error.localizedDescription)
                return
            }
            let captainData = snapshot?.value as? [String: Any]
            guard let captainDeviceToken = captainData?["deviceToken"] else { return }

            let data = ["token": captainDeviceToken, "nickname": userNickname]

            self.functions
                .httpsCallable("giveupNotification")
                .call(data) { (_, error) in
                    if let error = error {
                        print("error --> ", error.localizedDescription)
                    } else {
                        print("Success sending data")
                    }
                }
        }
    }

    // 크루에 새로 들어왔을 때 운전자에게 알림을 보내는 메서드
    func sendJoinInfoToDriver(crew: Crew) {
        Task {
            do {
                var userNickname = ""
                guard let userDatabasePath = User.databasePathWithUID else { return }
                let user = try await firebaseManager.readUser(databasePath: userDatabasePath)
                userNickname = user?.nickname ?? ""

                guard let captainID = crew.captainID else { return }

                let snapshot = try await Database.database().reference().child("users/\(captainID)").getData()
                if let captainData = snapshot.value as? [String: Any],
                   let captainDeviceToken = captainData["deviceToken"] as? String {

                    let data = ["token": captainDeviceToken, "nickname": userNickname]

                    do {
                        let result = try await self.functions.httpsCallable("userJoinedNotification").call(data)
                        print("Success sending data:", result)
                    } catch {
                        print("Error calling Firebase Functions:", error.localizedDescription)
                    }
                }
            } catch {
                print("Error reading user data:", error.localizedDescription)
            }
        }
    }
}
