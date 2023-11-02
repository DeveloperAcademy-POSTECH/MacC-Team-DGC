//
//  ProfileChangeViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/02.
//

import UIKit

// MARK: - 프로필 변경 화면 뷰 컨트롤러
final class ProfileChangeViewController: UIViewController {

    private let profileChangeView = ProfileChangeView()
    private let firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(profileChangeView)
        profileChangeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        // 마이페이지에서는 내비게이션 바가 보이지 않도록 한다.
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        // 마이페이지에서는 탭 바가 보이도록 한다.
//        tabBarController?.tabBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        // 마이페이지에서 설정 화면으로 넘어갈 때는 내비게이션 바가 보이도록 해준다.
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
