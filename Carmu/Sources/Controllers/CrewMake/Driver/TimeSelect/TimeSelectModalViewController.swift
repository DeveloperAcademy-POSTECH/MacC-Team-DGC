//
//  TimeSelectModalViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/5/23.
//

import UIKit

final class TimeSelectModalViewController: UIViewController {

    let timeSelectModalView = TimeSelectModalView()
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

        view.addSubview(timeSelectModalView)
        timeSelectModalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        timeSelectModalView.closeButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        timeSelectModalView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        timeSelectModalView.timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
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
        selectedTime = timeSelectModalView.timePicker.date
    }
}

extension TimeSelectModalViewController: UISheetPresentationControllerDelegate {}
