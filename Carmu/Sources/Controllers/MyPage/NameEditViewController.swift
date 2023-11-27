//
//  NicknameEditViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/07.
//

import UIKit

import SnapKit

// 수정된 이름 값을 이전 화면(MyPageView|CrewInfoCheckView)에 전달하기 위한 델리게이트 프로토콜
protocol NameEditViewControllerDelegate: AnyObject {

    func sendNewNameValue(newName: String)
}

// MARK: - 이름 편집 화면 뷰 컨트롤러
final class NameEditViewController: UIViewController {

    // 델리게이트 선언
    weak var delegate: NameEditViewControllerDelegate?
    var isCrewNameEditView: Bool = false // 크루명 편집과 닉네임 편집을 구분하기 위한 변수

    let nameEditView = NameEditView()

    private let firebaseManager = FirebaseManager()

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

    init(nowName: String, isCrewNameEditView: Bool) {
        super.init(nibName: nil, bundle: nil)
        nameEditView.nameEditTextField.text = nowName
        self.isCrewNameEditView = isCrewNameEditView
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        view.addSubview(nameEditView)
        nameEditView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 블러효과 적용
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)

        // 버튼에 타겟 추가
        nameEditView.textFieldEditCancelButton.addTarget(self, action: #selector(dismissNameEditView), for: .touchUpInside)
        nameEditView.textFieldEditDoneButton.addTarget(self, action: #selector(performNameChange), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissNameEditView))
        nameEditView.addGestureRecognizer(tapGesture)

        nameEditView.nameEditTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나올 때 바로 키보드 입력 가능하도록 최초 응답자 지정
        nameEditView.nameEditTextField.becomeFirstResponder()
    }
}

// MARK: - @objc 메서드
extension NameEditViewController {

    // 어두운 뷰 탭하면 텍스트 필드를 포함하고 있는 darkOverlayView 비활성화
    @objc private func dismissNameEditView() {
        presentingViewController?.dismiss(animated: false)
    }

    // [확인] 혹은 키보드의 엔터 버튼을 눌렀을 때 이름 수정사항을 반영해주는 메서드
    @objc private func performNameChange() {
        guard let newName = nameEditView.nameEditTextField.text else {
            return
        }

        if isCrewNameEditView { // 크루명 수정일 경우
            print("크루명 수정!!")
            // TODO: - 파이어베이스 DB에 크루명 업데이트

        } else { // 유저 닉네임 수정일 경우
            print("유저 닉네임 수정!!")
            // 파이어베이스 DB에 닉네임 업데이트
            firebaseManager.updateUserNickname(newNickname: newName)

        }

        delegate?.sendNewNameValue(newName: newName) // 델리게이트를 구현한 뷰 컨트롤러에 변경된 값 반영
        dismissNameEditView()
    }
}

// MARK: - 텍스트 필드 델리게이트 구현
extension NameEditViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performNameChange()
        return true
    }
}
