//
//  InviteCodeInputViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

final class InviteCodeInputViewController: UIViewController {

    private let inviteCodeInputView = InviteCodeInputView()
    private let firebaseManager = FirebaseManager()
    private var crewData = Crew(crews: [UserIdentifier](), memberStatus: [MemeberStatus]())

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))

        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)
        view.addSubview(inviteCodeInputView)
        inviteCodeInputView.codeSearchTextField.returnKeyType = .search
        inviteCodeInputView.codeSearchTextField.delegate = self
        inviteCodeInputView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addGestureRecognizer(tapGesture)

        inviteCodeInputView.clearButton.addTarget(
            self,
            action: #selector(clearButtonPressed),
            for: .touchUpInside
        )
        inviteCodeInputView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
        inviteCodeInputView.codeSearchTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        inviteCodeInputView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
        inviteCodeInputView.nextButton.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        inviteCodeInputView.codeSearchTextField.becomeFirstResponder()
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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - @objc Method
extension InviteCodeInputViewController {

    @objc private func clearButtonPressed() {
        inviteCodeInputView.codeSearchTextField.text = ""
        textFieldDidChange(inviteCodeInputView.codeSearchTextField)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }

        // 입력 길이가 8 이상인 경우
        if text.count >= 8 {
            firebaseManager.getCrewByInviteCode(inviteCode: text) { crewData in
                if let crewData = crewData {
                    self.inviteCodeInputView.conformCodeLabel.isHidden = false
                    self.inviteCodeInputView.rejectCodeLabel.isHidden = true
                    self.inviteCodeInputView.nextButton.isEnabled = true
                    self.inviteCodeInputView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                    self.crewData = crewData
                } else {
                    self.inviteCodeInputView.conformCodeLabel.isHidden = true
                    self.inviteCodeInputView.rejectCodeLabel.isHidden = false
                }
            }
        } else {
            self.inviteCodeInputView.conformCodeLabel.isHidden = true
            self.inviteCodeInputView.rejectCodeLabel.isHidden = true
            self.inviteCodeInputView.nextButton.isEnabled = false
            self.inviteCodeInputView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
        }
    }

    @objc private func nextButtonTapped() {
        let viewController = BoardingPointSelectViewController(crewData: crewData)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func dismissTextField() {
        inviteCodeInputView.codeSearchTextField.resignFirstResponder()
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let bottomInset = view.safeAreaInsets.bottom

        UIView.animate(withDuration: 0.3) {
            self.inviteCodeInputView.nextButton.transform = CGAffineTransform(
                translationX: 0,
                y: -keyboardFrame.height + bottomInset + 40
            )
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        self.inviteCodeInputView.nextButton.transform = .identity
    }
}

// MARK: - TextFieldDelegate Method
extension InviteCodeInputViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonTapped()
        return true
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct ICIViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = InviteCodeInputViewController
    func makeUIViewController(context: Context) -> InviteCodeInputViewController {
        return InviteCodeInputViewController()
    }
    func updateUIViewController(_ uiViewController: InviteCodeInputViewController, context: Context) {}
}
