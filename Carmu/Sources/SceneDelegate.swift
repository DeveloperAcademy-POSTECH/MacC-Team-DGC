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
    var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    private let firebaseManager = FirebaseManager()

    static var isFirst: Bool {
        get {
            return UserDefaults.standard.object(forKey: "isFirst") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFirst")
        }
    }
    static var isCrewCreated = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.overrideUserInterfaceStyle = .light

        // 스플래시 뷰
        let navigationController = UINavigationController(rootViewController: LaunchScreenViewController())
        navigationController.navigationBar.tintColor = UIColor.semantic.accPrimary
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        // NotificationCenter에서 isFirst 변수가 변하는지 감지하는 부분
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(isFirstChanged(_:)),
            name: Notification.Name("IsFirstChanged"),
            object: nil
        )
        // Auth state 변화 감지
        authStateDidChangeHandle = Auth.auth().addStateDidChangeListener { [weak self] (_, _) in
            self?.updateRootViewController()
        }
    }

    /**
     window navigationController rootViewController 변경 메서드
     */
    private func updateRootViewController() {
        var navigationController = UINavigationController(rootViewController: UIViewController())
        navigationController.navigationBar.tintColor = UIColor.semantic.accPrimary

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Task {
                let hasCrew = await self.firebaseManager.checkHasCrewAsync()

                // UI 업데이트 메인 스레드에서 수행
                await MainActor.run {
                    if Auth.auth().currentUser != nil {
                        if SceneDelegate.isFirst && !hasCrew {
                            navigationController = UINavigationController(rootViewController: PositionSelectViewController())
                            navigationController.navigationBar.tintColor = UIColor.semantic.accPrimary
                        } else {
                            navigationController = UINavigationController(rootViewController: SessionStartViewController())
                            navigationController.navigationBar.tintColor = UIColor.semantic.accPrimary
                        }
                        navigationController.navigationItem.backButtonTitle = ""
                        self.window?.rootViewController = navigationController
                    } else {
                        self.window?.rootViewController = LoginViewController()
                    }
                    self.window?.makeKeyAndVisible()
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        if let handle = authStateDidChangeHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

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
}
