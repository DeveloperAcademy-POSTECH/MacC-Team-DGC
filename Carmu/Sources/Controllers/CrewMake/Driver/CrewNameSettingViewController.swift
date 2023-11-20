//
//  CrewNameSettingViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/19/23.
//

import UIKit

final class CrewNameSettingViewController: UIViewController {

    private let crewNameSettingView = CrewNameSettingView()
    private var crewData = Crew(crews: [UserIdentifier](), memberStatus: [MemberStatus]())

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))

        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)
        view.addSubview(crewNameSettingView)
        crewNameSettingView.codeSearchTextField.returnKeyType = .search
        crewNameSettingView.codeSearchTextField.delegate = self
        crewNameSettingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addGestureRecognizer(tapGesture)

        crewNameSettingView.clearButton.addTarget(
            self,
            action: #selector(clearButtonPressed),
            for: .touchUpInside
        )
        crewNameSettingView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
        crewNameSettingView.codeSearchTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        crewNameSettingView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
        crewNameSettingView.nextButton.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        crewNameSettingView.codeSearchTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - @objc Method
extension CrewNameSettingViewController {

    @objc private func clearButtonPressed() {
        crewNameSettingView.codeSearchTextField.text = ""
        textFieldDidChange(crewNameSettingView.codeSearchTextField)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }

        // 입력 길이 8까지 제한
        if text.count > 0 && text.count <= 8 {
            self.crewNameSettingView.conformCodeLabel.isHidden = false
            self.crewNameSettingView.rejectCodeLabel.isHidden = true
            self.crewNameSettingView.nextButton.isEnabled = true
            self.crewNameSettingView.nextButton.backgroundColor = UIColor.semantic.accPrimary
        } else {
            self.crewNameSettingView.conformCodeLabel.isHidden = true
            self.crewNameSettingView.rejectCodeLabel.isHidden = false
            self.crewNameSettingView.nextButton.isEnabled = false
            self.crewNameSettingView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
        }
    }

    @objc private func nextButtonTapped() {
        let viewController = StartEndPointSelectViewController()
        crewData.name = crewNameSettingView.codeSearchTextField.text
        viewController.crewData = crewData
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func dismissTextField() {
        crewNameSettingView.codeSearchTextField.resignFirstResponder()
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let bottomInset = view.safeAreaInsets.bottom

        UIView.animate(withDuration: 0.3) {
            self.crewNameSettingView.nextButton.transform = CGAffineTransform(
                translationX: 0,
                y: -keyboardFrame.height + bottomInset + 40
            )
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        self.crewNameSettingView.nextButton.transform = .identity
    }
}

// MARK: - TextFieldDelegate Method
extension CrewNameSettingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonTapped()
        return true
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CNSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CrewNameSettingViewController
    func makeUIViewController(context: Context) -> CrewNameSettingViewController {
        return CrewNameSettingViewController()
    }
    func updateUIViewController(_ uiViewController: CrewNameSettingViewController, context: Context) {}
}
