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
    private let crewData = Crew(crews: [UserIdentifier](), crewStatus: [UserIdentifier: Status]())

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))

        view.backgroundColor = UIColor.semantic.backgroundDefault
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

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - @objc Method
extension InviteCodeInputViewController {

    @objc private func clearButtonPressed() {
        inviteCodeInputView.codeSearchTextField.text = ""
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }

        // 입력 길이가 8 이상인 경우
        if text.count >= 8 {
            // TODO: 8자 이상일 때 수행할 액션 추가
            firebaseManager.getCrewByInviteCode(inviteCode: text) { crewData in
                if crewData != nil {
                    self.inviteCodeInputView.conformCodeLabel.isHidden = false
                    self.inviteCodeInputView.rejectCodeLabel.isHidden = true
                    self.inviteCodeInputView.nextButton.isEnabled = true
                    self.inviteCodeInputView.nextButton.backgroundColor = UIColor.semantic.accPrimary
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
        // TODO: 코드 유효성 텍스트 라벨 표시 로직 추가 필요
        let viewController = BoardingPointSelectViewController(crewData: crewData)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func dismissTextField() {
        inviteCodeInputView.codeSearchTextField.resignFirstResponder() // 최초 응답자 해제
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        // 애니메이션을 사용하여 레이아웃 업데이트 → 친구 추가하기 버튼을 위로 올려준다.
        UIView.animate(withDuration: 0.3) {
            self.inviteCodeInputView.nextButton.transform = CGAffineTransform(
                translationX: 0,
                y: -keyboardFrame.height + 80
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
        // 리턴 키를 누를 때 호출될 메서드
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
