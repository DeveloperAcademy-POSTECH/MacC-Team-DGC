//
//  FriendAddViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/10.
//
import UIKit

import FirebaseDatabase
import FirebaseFunctions
import FirebaseStorage

final class FriendAddViewController: UIViewController {

    var searchedFriend: User? // 검색된 유저
    private let friendAddView = FriendAddView()
    private let encoder = JSONEncoder()
    private var friendDeviceToken = ""   // 친구의 디바이스 토큰값
    private let firebaseManager = FirebaseManager()

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
            forCellReuseIdentifier: FriendListTableViewCell.cellIdentifier
        )
        friendAddView.searchedFriendTableView.register(
            NoSearchedResultTableViewCell.self,
            forCellReuseIdentifier: NoSearchedResultTableViewCell.cellIdentifier
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
        setButtonState(isEnable: false)
    }

    // 친구 요청 완료 알럿
    private func showFriendRequestAlert() {
        let alert = UIAlertController(title: "친구 추가가 완료되었습니다.", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
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
        dismissTextField()
        print("검색 텍스트: \(friendAddView.friendSearchTextField.text ?? "")")
        guard let searchKeyword = friendAddView.friendSearchTextField.text else {
            return
        }
        firebaseManager.searchUserNickname(searchNickname: searchKeyword) { searchedResult in
            if let searchedResult = searchedResult {
                self.searchedFriend = searchedResult
                self.setButtonState(isEnable: true)
            } else {
                self.searchedFriend = nil
                self.setButtonState(isEnable: false)
            }
            self.friendAddView.searchedFriendTableView.reloadData()
        }
    }

    // 텍스트필드 clear 버튼 눌렀을 때 동작
    @objc private func clearButtonPressed() {
        friendAddView.friendSearchTextField.text = ""
    }

    // 텍스트 필드 비활성화 시 동작
    @objc private func dismissTextField() {
        friendAddView.textFieldUtilityView.isHidden = true
        friendAddView.friendSearchTextFieldView.backgroundColor = .clear
        friendAddView.friendSearchTextFieldView.layer.borderWidth = 1.0
        friendAddView.friendSearchTextField.resignFirstResponder() // 최초 응답자 해제
    }

    // [친구 추가하기] 버튼 눌렀을 때 동작
    @objc private func sendFriendRequest() {
        print("친구 추가하기 버튼 클릭됨")
        guard let myUID = KeychainItem.currentUserIdentifier else {
            return
        }
        guard let friendUID = searchedFriend?.id else {
            return
        }
        print("내Uid: \(myUID)")
        print("친구Uid: \(friendUID)")

        firebaseManager.addFriendship(myUID: myUID, friendUID: friendUID)
        firebaseManager.getFriendUser(friendID: friendUID) { friend in
            guard let friend = friend else {
                return
            }
            self.friendDeviceToken = friend.deviceToken
            print("친구의 Device Token -> ", self.friendDeviceToken)
            self.pushToReceiver(friendUID: self.friendDeviceToken)
        }
        showFriendRequestAlert()
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

// MARK: - 서버 푸시 관련 메서드
extension FriendAddViewController {

    // MARK: - 새로운 친구에게 서버 푸시 알림을 보내는 메서드
    private func pushToReceiver(friendUID: String) {
        let functions = Functions.functions()

        // Functions 호출
        functions
            .httpsCallable("pushToReceiver")
            .call(["token": self.friendDeviceToken]) { (result, error) in
            if let error = error {
                print("Error calling Firebase Functions: \(error.localizedDescription)")
            } else {
                if let data = (result?.data as? [String: Any]) {
                    print("Response data -> ", data)
                }
            }
        }

    }
}

// MARK: - UITextFieldDelegate 델리게이트 구현
extension FriendAddViewController: UITextFieldDelegate {

    // 텍스트 필드의 편집이 시작될 때 호출되는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        friendAddView.friendSearchTextFieldView.backgroundColor = UIColor.semantic.backgroundSecond
        friendAddView.friendSearchTextFieldView.layer.borderWidth = 0
        friendAddView.textFieldUtilityView.isHidden = false
    }

    // 리턴 키를 눌렀을 때 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissTextField()
        performFriendSearch()
        return true
    }

    // 친구 검색 결과에 따라 친구 추가 버튼의 활성화/비활성화를 처리해주는 함수
    func setButtonState(isEnable: Bool) {
        if isEnable {
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
                withIdentifier: FriendListTableViewCell.cellIdentifier,
                for: indexPath
            ) as? FriendListTableViewCell else {
                return UITableViewCell()
            }
            cell.nicknameLabel.text = searchedFriend.nickname
            cell.profileImageView.image = UIImage(profileImageColor: searchedFriend.profileImageColor)
            return cell
        } else {
            // MARK: - 검색된 친구가 없는 경우
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NoSearchedResultTableViewCell.cellIdentifier,
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
