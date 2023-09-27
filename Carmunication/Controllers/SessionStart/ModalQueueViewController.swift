//
//  ModalQueueViewController.swift
//  Carmunication
//
//  Created by 김태형 on 2023/09/27.
//

import UIKit

class ModalQueueViewController: UIViewController {
    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setSheetPresentationController()
    }
}
extension ModalQueueViewController {
    private func setSheetPresentationController() {
        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
    }
}
extension ModalQueueViewController: UISheetPresentationControllerDelegate {
}
