//
//  RepeatDaySelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class RepeatDaySelectViewController: UIViewController {

    private let repeatDaySelectView = RepeatDaySelectView()
    private var selectedButton: DaySelectButton?
    private var selectedPoint: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        repeatDaySelectView.weekdayButton.addTarget(
            self,
            action: #selector(daySettingButtonTapped),
            for: .touchUpInside
        )
        repeatDaySelectView.weekendButton.addTarget(
            self,
            action: #selector(daySettingButtonTapped),
            for: .touchUpInside
        )
        repeatDaySelectView.everydayButton.addTarget(
            self,
            action: #selector(daySettingButtonTapped),
            for: .touchUpInside
        )

        repeatDaySelectView.weekdayButton.addTarget(
            self,
            action: #selector(weekdayButtonTapped),
            for: .touchUpInside
        )
        repeatDaySelectView.weekendButton.addTarget(
            self,
            action: #selector(weekendButtonTapped),
            for: .touchUpInside
        )
        repeatDaySelectView.everydayButton.addTarget(
            self,
            action: #selector(everydayButtonTapped),
            for: .touchUpInside
        )

        repeatDaySelectView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )

        view.addSubview(repeatDaySelectView)
        repeatDaySelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension RepeatDaySelectViewController {

    @objc private func weekdayButtonTapped(_ sender: DaySelectButton) {

    }

    @objc private func weekendButtonTapped(_ sender: DaySelectButton) {

    }

    @objc private func everydayButtonTapped(_ sender: DaySelectButton) {

    }

    @objc private func daySettingButtonTapped(_ sender: DaySelectButton) {
        if selectedButton == sender {
            selectedButton?.resetButtonAppearance()
            selectedPoint = nil
            selectedButton = nil
            return
        }
        selectedButton?.resetButtonAppearance()
        selectedButton = sender
        sender.setSelectedButtonAppearance()
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        let viewController = FinalConfirmViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct RDSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RepeatDaySelectViewController
    func makeUIViewController(context: Context) -> RepeatDaySelectViewController {
        return RepeatDaySelectViewController()
    }
    func updateUIViewController(_ uiViewController: RepeatDaySelectViewController, context: Context) {}
}
