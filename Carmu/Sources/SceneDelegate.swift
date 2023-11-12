//
//  SceneDelegate.swift
//  Carmu
//
//  Created by 허준혁 on 2023/09/19.
//

import UIKit

import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    // TODO: 추후 AppStorage 처리 추가 필요. 개발 편의를 위해 static 변수로 둠.
    static var isFirst = true
    static var isCrewCreated = false

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // 첫 화면 설정
        updateRootViewController()

        // NotificationCenter에서 isFirst 변수가 변하는지 감지하는 부분
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(isFirstChanged(_:)),
            name: Notification.Name("IsFirstChanged"),
            object: nil
        )
    }

    func updateRootViewController() {
        var rootViewController: UIViewController
        if Auth.auth().currentUser != nil {
            if SceneDelegate.isFirst {
                rootViewController = StopoverPointCheckViewController()
            } else {
                rootViewController = SessionStartViewController()
            }
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.navigationBar.tintColor = UIColor.semantic.accPrimary
            removeBackButtonTitle()
            window?.rootViewController = navigationController
        } else {
            window?.rootViewController = LoginViewController()
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}

    // isFirst 값이 변경될 때 호출되는 메소드
    @objc func isFirstChanged(_ notification: Notification) {
        updateRootViewController()
    }

    // isFirst 값을 변경하는 함수
    static func updateIsFirstValue(_ newValue: Bool) {
        SceneDelegate.isFirst = newValue
        NotificationCenter.default.post(name: Notification.Name("IsFirstChanged"), object: nil)
    }

    // TODO: - 내비게이션 바 버튼 색이 자꾸 .clear로 변하기 때문에 다른 방법 필요
    private func removeBackButtonTitle() {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
    }
}
