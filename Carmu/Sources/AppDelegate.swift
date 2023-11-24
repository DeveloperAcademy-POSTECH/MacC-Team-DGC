//
//  AppDelegate.swift
//  Carmu
//
//  Created by 허준혁 on 2023/09/19.
//

import UIKit

import FirebaseCore
import FirebaseMessaging
import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let firebaseManager = FirebaseManager()

    // gcmMessageIDKey 설정
    let gcmMessageIDKey = "gcm.Message_ID"

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 앱 자체 언어 한국어로 설정
        UserDefaults.standard.set(["ko"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        FirebaseApp.configure() // Firebase 초기화 (연결)
        // 원격 알림 등록
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        // 델리게이트 설정
        Messaging.messaging().delegate = self

        NMFAuthManager.shared().clientId = Bundle.main.naverMapClientID
        return true
    }
    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // 알림 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        //     Messaging.messaging().appDidReceiveMessage(userInfo)
        // ...
        // Print full message.
        print("userInfo")
        print(userInfo)

        // Change this to your preferred presentation option
        return [[.sound, .banner]]
    }

    // 자동 푸시 알림 처리
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        return UIBackgroundFetchResult.newData
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo

        // ...
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)
    }

    // APNS (Apple Push Notification Service) 등록을 성공적으로 완료하면 호출되는 메서드
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    // 토큰 갱신 모니터링 -> FCM 토큰은 정기적으로 자동 갱신되기 때문에 didReceiveRegistrationToken를 호출해줌으로써 갱신된 토큰값을 불러와야 함
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )

        // 디바이스 토큰값 키체인에 저장
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }
        guard let fcmToken = fcmToken else {
            return
        }
        do {
            try KeychainItem(service: bundleIdentifier, account: "FCMToken").saveItem(fcmToken)
        } catch {
            print("키체인에 FCMToken을 저장하지 못했습니다.")
        }

        // 디바이스 토큰 세팅해주기
        settingDeviceToken(fcmToken: fcmToken)
    }
}

// MARK: - Actions
extension AppDelegate {

    // 파이어베이스의 디바이스 토큰과 기기의 디바이스 토큰값이 다르면 기기의 디바이스 토큰값으로 변경하는 메서드
    private func settingDeviceToken(fcmToken: String) {
        Task {
            guard let databasePath = User.databasePathWithUID else { return }
            let user = try await firebaseManager.readUser(databasePath: databasePath)
            guard let deviceToken = user?.deviceToken else { return }
            // 만약 디바이스 토큰값이 일치하지 않는다면 변경해줍니다.
            if fcmToken != deviceToken {
                firebaseManager.updateDeviceTokenInUser(newToken: fcmToken)
                firebaseManager.updateDeviceTokenInCrews(newToken: fcmToken)
            }
        }
    }
}
