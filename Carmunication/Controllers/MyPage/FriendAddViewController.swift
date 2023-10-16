//
//  FriendAddViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/10.
//

import UIKit

import FirebaseDatabase

final class FriendAddViewController: UIViewController {

    var searchedFriend: User? // 검색된 유저
    private let friendAddView = FriendAddView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "친구추가"
        view.addSubview(friendAddView)
        friendAddView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 재사용 셀 등록
        friendAddView.searchedFriendTableView.register(
            FriendListTableViewCell.self,
            forCellReuseIdentifier: "friendListTableViewCell"
        )
        friendAddView.searchedFriendTableView.register(
            NoSearchedResultTableViewCell.self,
            forCellReuseIdentifier: "noSearchedResultTableViewCell"
        )
        friendAddView.searchedFriendTableView.dataSource = self
        friendAddView.searchedFriendTableView.delegate = self

        friendAddView.closeButton.addTarget(self, action: #selector(closeFriendAddView), for: .touchUpInside)
        friendAddView.friendSearchButton.addTarget(self, action: #selector(performFriendSearch), for: .touchUpInside)
        friendAddView.clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        friendAddView.friendAddButton.addTarget(self, action: #selector(sendFriendRequest), for: .touchUpInside)

        friendAddView.friendSearchTextField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        view.addGestureRecognizer(tapGesture)

        // 키보드 노티피케이션 옵저버 등록
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

    // 클래스의 인스턴스가 메모리에서 해제되기 전에 호출되는 메서드
    deinit {
        // 옵저버 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setButtonState(hasText: false)
    }
}

// MARK: - @objc 메서드
extension FriendAddViewController {

    // 상단 닫기 버튼 클릭 시 동작
    @objc private func closeFriendAddView() {
        self.dismiss(animated: true)
    }

    // [검색] 버튼을 눌렀을 때 동작
    @objc private func performFriendSearch() {
        print("친구 검색 수행")
        dismissTextField()
        guard let searchNickname = friendAddView.friendSearchTextField.text else {
            return
        }
        searchUserNickname(searchNickname: searchNickname) { searchedFriend in
            guard let searchedFriend = searchedFriend else {
                return
            }
            self.searchedFriend = searchedFriend
            self.friendAddView.searchedFriendTableView.reloadData()
        }
    }

    // 텍스트필드 clear 버튼 눌렀을 때 동작
    @objc private func clearButtonPressed() {
        friendAddView.friendSearchTextField.text = ""
    }

    // 텍스트 필드 비활성화 시 동작
    @objc private func dismissTextField() {
        friendAddView.friendSearchTextFieldView.backgroundColor = .clear
        friendAddView.friendSearchTextFieldView.layer.borderWidth = 1.0
        friendAddView.friendSearchTextField.resignFirstResponder() // 최초 응답자 해제
    }

    // [친구 추가하기] 버튼 눌렀을 때 동작
    @objc private func sendFriendRequest() {
        // TODO: - 친구 추가 구현 필요
        print("친구 추가하기 버튼 클릭됨")
    }

    // 키보드가 나타날 때 호출되는 메서드
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        // 애니메이션을 사용하여 레이아웃 업데이트 → 친구 추가하기 버튼을 위로 올려준다.
        UIView.animate(withDuration: 0.3) {
            self.friendAddView.friendAddButton.transform = CGAffineTransform(
                translationX: 0,
                y: -keyboardFrame.height+24
            )
        }
    }

    // 키보드가 사라질 때 호출되는 메서드
    @objc private func keyboardWillHide(notification: Notification) {
        self.friendAddView.friendAddButton.transform = .identity
    }
}

// MARK: - Firebase Realtime Database DB 관련 메서드
extension FriendAddViewController {

    // MARK: - 닉네임에 해당하는 친구를 DB에서 검색하는 메서드
    private func searchUserNickname(searchNickname: String, completion: @escaping (User?) -> Void) {
        Database.database().reference().child("users").observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                guard let snap = child as? DataSnapshot else {
                    return
                }
                guard let dict = snap.value as? [String: Any] else {
                    return
                }
                if dict["nickname"] as? String == searchNickname {
                    print("\(searchNickname)이(가) 검색되었습니다!!!")
                    let searchedFriend = User(
                        id: dict["id"] as? String ?? "",
                        nickname: dict["nickname"] as? String ?? "",
                        imageURL: dict["imageURL"] as? String ?? ""
                    )
                    completion(searchedFriend)
                }
            }
        }
    }

    // MARK: - 친구 요청을 보내는 메서드(유저의 친구 목록에 추가)
}

// MARK: - UITextFieldDelegate 델리게이트 구현
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

    // 텍스트 필드 텍스트가 변경될 때 호출되는 메서드
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            // 텍스트가 있는 경우
            setButtonState(hasText: true)
        } else {
            // 텍스트가 없는 경우
            setButtonState(hasText: false)
        }
    }

    // 텍스트필드 입력 값에 따라 친구 추가 버튼의 활성화/비활성화를 처리해주는 함수
    func setButtonState(hasText: Bool) {
        if hasText {
            // 활성화
            friendAddView.friendAddButton.backgroundColor = UIColor.theme.blue6
            friendAddView.friendAddButton.isEnabled = true
        } else {
            // 비활성화
            friendAddView.friendAddButton.backgroundColor = UIColor.semantic.backgroundSecond
            friendAddView.friendAddButton.isEnabled = false
        }
    }
}

// MARK: - UITableViewDataSource 델리게이트 구현
extension FriendAddViewController: UITableViewDataSource {

    // 셀의 개수 1개
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let searchedFriend = searchedFriend {
            // MARK: - 검색된 친구가 있는 경우
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "friendListTableViewCell",
                for: indexPath
            ) as? FriendListTableViewCell else {
                return UITableViewCell()
            }
            cell.nicknameLabel.text = searchedFriend.nickname
            if let imageURL = searchedFriend.imageURL {
                // TODO: - 이미지 불러오는 메서드 추가하기
            }
            return cell
        } else {
            // MARK: - 검색된 친구가 없는 경우
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "noSearchedResultTableViewCell",
                for: indexPath
            ) as? NoSearchedResultTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate 델리게이트 구현
extension FriendAddViewController: UITableViewDelegate {

    // 각 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    // 테이블 뷰 셀을 눌렀을 때에 대한 동작
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
