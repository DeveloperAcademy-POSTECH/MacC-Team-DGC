//
//  NicknameEditViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/07.
//

import UIKit

import SnapKit

// 수정된 닉네임 값을 이전 화면(MyPageView)에 전달하기 위한 델리게이트 프로토콜
protocol NicknameEditViewControllerDelegate: AnyObject {

    func sendNewNickname(newNickname: String)
}

// MARK: - 닉네임 변경 화면 뷰 컨트롤러
final class NicknameEditViewController: UIViewController {

    // 델리게이트 선언
    weak var delegate: NicknameEditViewControllerDelegate?

    private let nicknameEditView = NicknameEditView()

    // 뒷배경을 흐리게 하기 위한 블러 뷰
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
        // 블러효과 적용
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)

        // 버튼에 타겟 추가
        nicknameEditView.textFieldEditCancelButton.addTarget(
            self,
            action: #selector(dismissNicknameEditView),
            for: .touchUpInside
        )
        nicknameEditView.textFieldEditDoneButton.addTarget(
            self,
            action: #selector(performNicknameChange),
            for: .touchUpInside
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissNicknameEditView))
        nicknameEditView.addGestureRecognizer(tapGesture)

        nicknameEditView.nicknameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나올 때 바로 키보드 입력 가능하도록 최초 응답자 지정
        nicknameEditView.nicknameTextField.becomeFirstResponder()
    }
}

// MARK: - @objc 메서드
extension NicknameEditViewController {

    // 어두운 뷰 탭하면 텍스트 필드를 포함하고 있는 darkOverlayView 비활성화
    @objc private func dismissNicknameEditView() {
        presentingViewController?.dismiss(animated: false)
    }

    // [확인] 혹은 키보드의 엔터 버튼을 눌렀을 때 닉네임 수정사항을 반영해주는 메서드
    @objc private func performNicknameChange() {
        // 파이어베이스 DB에 닉네임 업데이트
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let newNickname = nicknameEditView.nicknameTextField.text else {
            return
        }
        databasePath.child("nickname").setValue(newNickname as NSString)

        delegate?.sendNewNickname(newNickname: newNickname) // 마이페이지 뷰에 변경된 값 반영
        dismissNicknameEditView()
    }
}

// MARK: - 텍스트 필드 델리게이트 구현
extension NicknameEditViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performNicknameChange()
        return true
    }
}
