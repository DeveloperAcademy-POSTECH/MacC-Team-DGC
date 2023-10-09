//
//  StartTimeSelectViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

class StartTimeSelectViewController: UIViewController {

    let startTimeSelectView = StartTimeSelectView()

    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(startTimeSelectView)
        startTimeSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        startTimeSelectView.closeButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)

        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
    }
}

// MARK: - @objc Method
extension StartTimeSelectViewController {

    @objc private func backButtonAction() {
        dismiss(animated: true)
    }
}

extension StartTimeSelectViewController: UISheetPresentationControllerDelegate {}
