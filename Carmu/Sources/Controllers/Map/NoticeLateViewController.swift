//
//  NoticeLateViewController.swift
//  Carmu
//
//  Created by 허준혁 on 10/23/23.
//

import UIKit

import FirebaseDatabase
import FirebaseFunctions
import SnapKit

final class NoticeLateViewController: UIViewController {

    private let noticeLateView = NoticeLateView()
    private let firebaseManager = FirebaseManager()
    private let serverPushManager = ServerPushManager()
    private var lateMin = "0"
    private let crew: Crew

    init(crew: Crew) {
        self.crew = crew
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("customDetent")) { _ in
            return 301
        }

        if let sheet = sheetPresentationController {
            sheet.detents = [customDetent]
        }

        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(noticeLateView)
        noticeLateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        noticeLateView.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        noticeLateView.lateThreeMinutesButton.addTarget(self, action: #selector(lateThreeMinutesButtonDidTap), for: .touchUpInside)
        noticeLateView.lateFiveMinutesButton.addTarget(self, action: #selector(lateFiveMinutesButtonDidTap), for: .touchUpInside)
    }

    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }

    @objc private func lateThreeMinutesButtonDidTap() {
        lateMin = "3"
        firebaseManager.updateLateTime(lateTime: 3, crew: crew)
        let isDriver = KeychainItem.currentUserIdentifier == crew.captainID
        if isDriver {
            serverPushManager.sendLateToAllPassenger(lateMin: lateMin, crew: crew)
        } else {
            serverPushManager.sendLateToDriver(lateMin: lateMin, crew: crew)
        }
        sendToastMessage()
    }

    @objc private func lateFiveMinutesButtonDidTap() {
        lateMin = "5"
        firebaseManager.updateLateTime(lateTime: 5, crew: crew)

        let isDriver = KeychainItem.currentUserIdentifier == crew.captainID
        if isDriver {
            serverPushManager.sendLateToAllPassenger(lateMin: lateMin, crew: crew)
        } else {
            serverPushManager.sendLateToDriver(lateMin: lateMin, crew: crew)
        }
        sendToastMessage()
    }

    // Toast 메세지 보내기
    private func sendToastMessage() {
        guard let pvc = presentingViewController as? MapViewController else { return }
        dismiss(animated: true) {
            pvc.showToast("지각 알림을 보냈어요", withDuration: 1.0, delay: 2.0)
        }
    }
}
