//
//  NicknameEditViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/07.
//

import UIKit

import SnapKit

final class NicknameEditViewController: UIViewController {

    private let nicknameEditView = NicknameEditView()
    lazy var blurEffectView: UIView = {
        let containerView = UIView()
        let blurEffect = UIBlurEffect(style: .dark)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.4)
        customBlurEffectView.frame = self.view.bounds
        let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.theme.trans60
        dimmedView.frame = self.view.bounds

        containerView.addSubview(customBlurEffectView)
        containerView.addSubview(dimmedView)
        return containerView
    }()

    init(nickname: String) {
        super.init(nibName: nil, bundle: nil)
        nicknameEditView.nicknameTextField.text = nickname
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        view.addSubview(nicknameEditView)
        nicknameEditView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)

        nicknameEditView.textFieldEditCancelButton.addTarget(self, action: #selector(dismissTextField), for: .touchUpInside)
        nicknameEditView.textFieldEditDoneButton.addTarget(self, action: #selector(changeNickname), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        nicknameEditView.addGestureRecognizer(tapGesture)

        nicknameEditView.nicknameTextField.delegate = self
    }
}

// MARK: - @objc 메서드
extension NicknameEditViewController {

    // 어두운 뷰 탭하면 텍스트 필드를 포함하고 있는 darkOverlayView 비활성화
    @objc private func dismissTextField() {
        presentingViewController?.dismiss(animated: false)
    }

    // [확인] 혹은 키보드의 엔터 버튼을 눌렀을 때 닉네임 수정사항을 DB에 반영해주는 메서드
    @objc private func changeNickname() {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let newNickname = nicknameEditView.nicknameTextField.text else {
            return
        }
        databasePath.child("nickname").setValue(newNickname as NSString)

//        myPageView.nicknameLabel.text = myPageView.nicknameTextField.text // TODO: - 마이페이지 텍스트에 반영
        dismissTextField()
    }
}

// MARK: - 텍스트 필드 델리게이트 구현
extension NicknameEditViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeNickname()
        return true
    }
}
