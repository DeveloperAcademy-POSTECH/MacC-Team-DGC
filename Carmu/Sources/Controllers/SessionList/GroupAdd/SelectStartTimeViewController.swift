//
//  StartTimeSelectViewController.swift
//  Carmu
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
        timeSelectionHandler?(selectedTime ?? Date())
        dismiss(animated: true)
    }

    @objc private func timePickerValueChanged() {
        selectedTime = selectStartTimeView.timePicker.date
    }
}

extension SelectStartTimeViewController: UISheetPresentationControllerDelegate {}
