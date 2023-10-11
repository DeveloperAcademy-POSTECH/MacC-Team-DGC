//
//  PrivacyViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/01.
//

import UIKit

final class PrivacyViewController: UIViewController {

    private let privacyView = PrivacyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "개인정보 처리방침"
        view.addSubview(privacyView)
        privacyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.semantic.accPrimary
    }
}
