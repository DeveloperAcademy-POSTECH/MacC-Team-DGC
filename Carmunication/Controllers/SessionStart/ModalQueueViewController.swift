//
//  ModalQueueViewController.swift
//  Carmunication
//
//  Created by 김태형 on 2023/09/27.
//

import UIKit

import SnapKit

final class ModalQueueViewController: UIViewController {
    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }

    private let modalQueueView = ModalQueueView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(modalQueueView)
        modalQueueView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        modalQueueView.startButton.addTarget(self, action: #selector(goToMapView), for: .touchUpInside)

        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
    }
}
extension ModalQueueViewController {

    @objc private func goToMapView() {
        let sessionMapViewController = SessionMapViewController()
        // SessionMapViewController를 full-screen 모달로 표시
        sessionMapViewController.modalPresentationStyle = .fullScreen
        self.present(sessionMapViewController, animated: true, completion: nil)
    }
}

extension ModalQueueViewController: UISheetPresentationControllerDelegate {}
