//
//  FriendAddViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/10.
//

import UIKit

final class FriendAddViewController: UIViewController {

    private let friendAddView = FriendAddView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "친구추가"
        view.addSubview(friendAddView)
        friendAddView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        friendAddView.friendSearchButton.addTarget(self, action: #selector(performFriendSearch), for: .touchUpInside)
        friendAddView.clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)

        friendAddView.friendSearchTextField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - @objc 메서드
extension FriendAddViewController {

    // [검색] 버튼을 눌렀을 때 동작
    @objc private func performFriendSearch() {
        // TODO: - 친구 검색 기능 구현 필요
        print("친구 검색")
    }

    // 텍스트필드 clear 버튼 눌렀을 때 동작
    @objc func clearButtonPressed() {
        friendAddView.friendSearchTextField.text = ""
    }

    // 텍스트 필드 비활성화 시 동작
    @objc func dismissTextField() {
        friendAddView.friendSearchTextFieldView.backgroundColor = .clear
        friendAddView.friendSearchTextFieldView.layer.borderWidth = 1.0
        friendAddView.friendSearchTextField.resignFirstResponder() // 최초 응답자 해제
    }
}

// MARK: - 텍스트 필드 관련 델리게이트 메서드 구현
extension FriendAddViewController: UITextFieldDelegate {

    // 텍스트 필드의 편집이 시작될 때 호출되는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        friendAddView.friendSearchTextFieldView.backgroundColor = UIColor.semantic.backgroundSecond
        friendAddView.friendSearchTextFieldView.layer.borderWidth = 0
    }

    // 리턴 키를 눌렀을 때 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissTextField()
        return true
    }
}
