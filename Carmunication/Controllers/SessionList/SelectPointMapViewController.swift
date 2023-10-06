//
//  SelectPointMapViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

final class SelectPointMapViewController: UIViewController {

    let selectPointMapView = SelectPointMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(selectPointMapView)
        selectPointMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectPointMapView.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
}

// MARK: - @objc Method
extension SelectPointMapViewController {

    @objc private func backButtonAction() {
        dismiss(animated: true)
    }
}
