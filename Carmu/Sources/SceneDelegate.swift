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
    // 크루가 있는지 확인하는 임시변수. 추후 Firebase 데이터베이스 확인 후 설정하는 로직으로 변경예정
    static var hasCrew = false

    // 앱의 Scene이 처음으로 연결될 때 호출되는 메소드
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        // 현재 Scene에 연결할 창 설정
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // 로그인한 사용자가 있는지 체크
        if Auth.auth().currentUser != nil {

            if SceneDelegate.hasCrew {
                // MARK: - SessionStartViewController()
                let rootViewController = SessionStartViewController()
                let navigationController = UINavigationController(rootViewController: rootViewController)
                window.rootViewController = navigationController
            } else {
                let rootViewController = PositionSelectViewController()
                let navigationController = UINavigationController(rootViewController: rootViewController)
                window.rootViewController = navigationController
            }
        } else {
            window.rootViewController = LoginViewController()
        }
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
