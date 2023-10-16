//
//  StartTimeSelectViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

class SelectStartTimeViewController: UIViewController {

    let selectStartTimeView = SelectStartTimeModalView()
    var timeSelectionHandler: ((Date) -> Void)?
    private var selectedTime: Date?
    weak var groupAddViewController: GroupAddViewController?

    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        groupAddViewController = presentingViewController as? GroupAddViewController
        view.backgroundColor = .systemBackground

        view.addSubview(selectStartTimeView)
        selectStartTimeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectStartTimeView.closeButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        selectStartTimeView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        selectStartTimeView.timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
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
        if let selectedTime = selectedTime { // 선택된 시간을 클로저에 전달
            timeSelectionHandler?(selectedTime)
        } else { // 바로 저장을 눌렀다면 현재시간을 주입
            timeSelectionHandler?(Date())
        }
        dismiss(animated: true)
    }

    @objc private func timePickerValueChanged() {
        selectedTime = selectStartTimeView.timePicker.date
    }
}

extension SelectStartTimeViewController: UISheetPresentationControllerDelegate {}
