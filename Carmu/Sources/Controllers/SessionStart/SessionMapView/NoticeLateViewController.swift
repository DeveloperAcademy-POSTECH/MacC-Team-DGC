//
//  NoticeLateViewController.swift
//  Carmu
//
//  Created by 허준혁 on 10/23/23.
//

import UIKit

import SnapKit

final class NoticeLateViewController: UIViewController {

    private let noticeLateView = NoticeLateView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("customDetent")) { _ in
            return 320
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
        noticeLateView.lateThreeMinutesButton.addTarget(
            self,
            action: #selector(lateThreeMinutesButtonDidTap),
            for: .touchUpInside
        )
        noticeLateView.lateFiveMinutesButton.addTarget(
            self,
            action: #selector(lateFiveMinutesButtonDidTap),
            for: .touchUpInside
        )
        noticeLateView.lateTenMinutesButton.addTarget(
            self,
            action: #selector(lateTenMinutesButtonDidTap),
            for: .touchUpInside
        )
    }

    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }

    @objc private func lateThreeMinutesButtonDidTap() {
        print("3분 늦어요")
    }

    @objc private func lateFiveMinutesButtonDidTap() {
        print("5분 늦어요")
    }

    @objc private func lateTenMinutesButtonDidTap() {
        print("10분 늦어요")
    }
}
