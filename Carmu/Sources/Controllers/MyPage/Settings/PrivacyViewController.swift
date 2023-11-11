//
//  PrivacyViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/01.
//

import UIKit

final class PrivacyViewController: UIViewController {

    private let privacyView = PrivacyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        navigationController?.navigationBar.topItem?.title = "" // 백버튼 텍스트 제거

        view.addSubview(privacyView)
        privacyView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "개인정보 처리방침"
    }
}
