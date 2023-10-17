//
//  MainTabBarViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/22.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.semantic.accPrimary
        tabBar.backgroundColor = UIColor.theme.white
        let vc1 = UINavigationController(rootViewController: SessionStartViewController())
        vc1.tabBarItem = UITabBarItem(title: "세션 시작하기", image: UIImage(systemName: "car"), tag: 0)
        let vc2 = UINavigationController(rootViewController: SessionListViewController())
        vc2.tabBarItem = UITabBarItem(title: "세션 관리", image: UIImage(systemName: "list.bullet"), tag: 1)
        let vc3 = UINavigationController(rootViewController: MyPageViewController())
        vc3.tabBarItem = UITabBarItem(title: "내 정보", image: UIImage(systemName: "person.fill"), tag: 2)
        setViewControllers([vc1, vc2, vc3], animated: true)

        settingDeviceToken()
    }
}

extension MainTabBarViewController {

    private func settingDeviceToken() {
        print("settingDeviceToken()")
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let fcmToken = UserDefaults.standard.string(forKey: "FCMToken") else {
            return
        }
        databasePath.child("deviceToken").setValue(fcmToken as NSString)
    }
}
