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
    var startButton: UIButton = {
        let startBtn = UIButton()
        startBtn.translatesAutoresizingMaskIntoConstraints = false
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
    private func setStartButton() {
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        startButton.addTarget(self, action: #selector(goToMapView), for: .touchUpInside)
    }
    @objc private func goToMapView() {
        print("asd")
    }
}
extension ModalQueueViewController: UISheetPresentationControllerDelegate {
}
