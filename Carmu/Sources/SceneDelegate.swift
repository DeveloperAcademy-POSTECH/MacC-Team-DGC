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
    /** 
     초기진입인지 파악하는 변수. 추후 AppStorage로 관리 예저
     크루가 없어도 SessionStart로 진입.
     */
    static var isFirst = true

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

        var rootViewController: UIViewController

        // 로그인한 사용자가 있는지 체크
        if let currentUser = Auth.auth().currentUser {
            if SceneDelegate.isFirst {
                rootViewController = PositionSelectViewController()
            } else {
                rootViewController = SessionStartViewController()
            }
            let navigationController = UINavigationController(rootViewController: rootViewController)
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
