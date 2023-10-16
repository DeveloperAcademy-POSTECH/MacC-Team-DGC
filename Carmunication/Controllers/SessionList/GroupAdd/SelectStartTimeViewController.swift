//
//  StartTimeSelectViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

class SelectStartTimeViewController: UIViewController {

    let selectStartTimeView = SelectStartTimeModalView()

    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(selectStartTimeView)
        selectStartTimeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectStartTimeView.closeButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        selectStartTimeView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
    }
}

// MARK: - @objc Method
extension SelectStartTimeViewController {

    @objc private func backButtonAction() {
        dismiss(animated: true)
    }

    @objc private func saveButtonAction() {
        dismiss(animated: true)
    }
}

extension SelectStartTimeViewController: UISheetPresentationControllerDelegate {}
