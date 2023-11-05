//
//  TimeSelectModalViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/5/23.
//

import UIKit

final class TimeSelectModalViewController: UIViewController {

    let timeSelectView = TimeSelectModalView()
    var timeSelectionHandler: ((Date) -> Void)?
    private var selectedTime: Date?
    weak var timeSelectViewController: TimeSelectViewController?

    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        timeSelectViewController = presentingViewController as? TimeSelectViewController
        view.backgroundColor = .systemBackground

        view.addSubview(timeSelectView)
        timeSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        timeSelectView.closeButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        timeSelectView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        timeSelectView.timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
    }
}

// MARK: - @objc Method
extension TimeSelectModalViewController {

    @objc private func backButtonAction() {
        dismiss(animated: true)
    }

    @objc private func saveButtonAction() {
        timeSelectionHandler?(selectedTime ?? Date())
        dismiss(animated: true)
    }

    @objc private func timePickerValueChanged() {
        selectedTime = timeSelectView.timePicker.date
    }
}

extension TimeSelectModalViewController: UISheetPresentationControllerDelegate {}
