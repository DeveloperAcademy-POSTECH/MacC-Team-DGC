//
//  SelectBoardingCrewModalViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

class SelectBoardingCrewModalViewController: UIViewController {

    let selectBoardingCrewModalView = SelectBoardingCrewModalView()

    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(selectBoardingCrewModalView)
        selectBoardingCrewModalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectBoardingCrewModalView.closeButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)

        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
    }
}

// MARK: - @objc Method
extension SelectBoardingCrewModalViewController {

    @objc private func backButtonAction() {
        dismiss(animated: true)
    }
}

extension SelectBoardingCrewModalViewController: UISheetPresentationControllerDelegate {}
