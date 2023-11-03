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
        // TODO: - 로그인 여부 + 회원가입 여부 모두 체크해서 분기처리 필요함 (온보딩 화면 작업 마무리 시에 작업)
        if Auth.auth().currentUser != nil {

            // MARK: - SessionStartViewController()
            let sessionStartViewController = SessionStartViewController()
            let navigationController = UINavigationController(rootViewController: sessionStartViewController)
            window.rootViewController = navigationController
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
