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

    private var startButton: UIButton = {
        let startBtn = UIButton()
        startBtn.setTitle("바로 시작", for: .normal)
        startBtn.backgroundColor = .systemBlue
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        startBtn.layer.cornerRadius = 8
        return startBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setSheetPresentationController()
        setStartButton()
    }
}
extension ModalQueueViewController {
    private func setSheetPresentationController() {
        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
    }

    // "바로 시작"버튼
    private func setStartButton() {
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        startButton.addTarget(self, action: #selector(goToMapView), for: .touchUpInside)
    }

    @objc private func goToMapView() {
        let sessionMapViewController = SessionMapViewController()
        // SessionMapViewController를 full-screen 모달로 표시
        sessionMapViewController.modalPresentationStyle = .fullScreen
        self.present(sessionMapViewController, animated: true, completion: nil)
    }
}

extension ModalQueueViewController: UISheetPresentationControllerDelegate {}
