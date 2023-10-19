//
//  FriendListViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//
import UIKit

import FirebaseDatabase
import FirebaseStorage

final class FriendListViewController: UIViewController {

    var friendList: [[Any]] = [] // [friendshipID, 친구의User객체] 의 배열을 담을 2차원 배열
    private let friendListView = FriendListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "친구관리"
        view.addSubview(friendListView)
        friendListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 재사용 셀 등록
        friendListView.friendListTableView.register(
            FriendListTableViewCell.self,
            forCellReuseIdentifier: FriendListTableViewCell.cellIdentifier
        )
        friendListView.friendListTableView.dataSource = self
        friendListView.friendListTableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "친구추가",
            style: .plain,
            target: self,
            action: #selector(showFriendAddView)
        )
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        // 유저의 친구 관계 리스트를 불러온다.
        readUserFriendshipList(databasePath: databasePath) { friendshipList in
            guard let friendshipList = friendshipList else {
                return
            }
            // 친구 관계 id값으로 친구의 uid를 받아온다.
            for friendshipID in friendshipList {
                self.getFriendUid(friendshipID: friendshipID) { friendID in
                    guard let friendID  = friendID else {
                        return
                    }
                    // 친구의 uid값으로 친구의 User객체를 불러온다.
                    self.getFriendUser(friendID: friendID) { friend in
                        guard let friend = friend else {
                            return
                        }
                        self.friendList.append([friendshipID, friend])
                        self.friendListView.friendListTableView.reloadData()
                        print("친구목록: \(self.friendList)")

                        self.checkFriendListIsEmpty(friendListCount: self.friendList.count)
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.semantic.accPrimary
    }

    // 친구 목록에 값이 있는지 확인하고, 뷰에 표시해줄 요소를 결정하는 메서드
    private func checkFriendListIsEmpty(friendListCount: Int) {
        if friendListCount < 1 {
            // 친구 목록에 친구가 있으면 테이블 뷰를 보여준다.
            friendListView.friendListTableView.isHidden = true
            friendListView.emptyView.isHidden = false
            friendListView.emptyFriendLabel.isHidden = false
        } else {
            // 친구 목록에 친구가 없으면 테이블 뷰를 숨기고 친구가 없을 때의 화면을 보여준다.
            friendListView.friendListTableView.isHidden = false
            friendListView.emptyView.isHidden = true
            friendListView.emptyFriendLabel.isHidden = true
        }
    }
}

// MARK: @objc 메서드
extension FriendListViewController {
    // [친구추가] 내비게이션 바 버튼 클릭 시 동작
    @objc private func showFriendAddView() {
        let friendAddVC = FriendAddViewController()
        friendAddVC.modalPresentationStyle = .formSheet
        self.present(friendAddVC, animated: true)
    }
}

// MARK: - Firebase Realtime Database DB 관련 메서드
extension FriendListViewController {

    // MARK: - DB에서 유저의 friendID 목록을 불러오는 메서드
    private func readUserFriendshipList(databasePath: DatabaseReference, completion: @escaping ([String]?) -> Void) {
        databasePath.child("friends").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            let friends = snapshot?.value as? [String]
            completion(friends)
        }
    }
    // MARK: - friendID 값으로 DB에서 Friendship의 친구 id를 불러오는 메서드
    private func getFriendUid(friendshipID: String, completion: @escaping (String?) -> Void) {
        Database.database().reference().child("friendship/\(friendshipID)").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshotValue = snapshot?.value as? [String: Any] else {
                return
            }
            guard let currentUserID = KeychainItem.currentUserIdentifier else {
                return
            }
            // sender와 receiver 중 현재 사용자에 해당하지 않는 uid를 뽑는다.
            var friendID: String = ""
            let senderValue = snapshotValue["senderID"] as? String ?? ""
            let receiverValue = snapshotValue["receiverID"] as? String ?? ""
            if currentUserID != senderValue {
                friendID = senderValue
            } else {
                friendID = receiverValue
            }
            completion(friendID)
        }
    }

    // MARK: - 친구의 uid로 DB에서 친구 데이터를 불러오기
    private func getFriendUser(friendID: String, completion: @escaping (User?) -> Void) {
        Database.database().reference().child("users/\(friendID)").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshotValue = snapshot?.value as? [String: Any] else {
                return
            }
            let friend = User(
                id: snapshotValue["id"] as? String ?? "",
                deviceToken: snapshotValue["deviceToken"] as? String ?? "",
                nickname: snapshotValue["nickname"] as? String ?? "",
                email: snapshotValue["email"] as? String,
                imageURL: snapshotValue["imageURL"] as? String,
                friends: snapshotValue["friends"] as? [String]
            )
            completion(friend)
        }
    }
}

// MARK: - Firebae Storage 관련 메서드
extension FriendListViewController {
    // MARK: - 파이어베이스 Storage에서 유저 이미지 불러오기
    // TODO: - MyPageViewController와 중복되는 메서드 -> 정리 필요함
    private func loadProfileImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let firebaseStorageRef = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        firebaseStorageRef.getData(maxSize: megaByte) { data, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
}

// MARK: - UITableViewDataSource 델리게이트 구현
extension FriendListViewController: UITableViewDataSource {
    // 섹션 당 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendList.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    // 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FriendListTableViewCell.cellIdentifier,
            for: indexPath
        ) as? FriendListTableViewCell else {
            return UITableViewCell()
        }
        if let friend = friendList[indexPath.section][1] as? User {
            cell.nicknameLabel.text = friend.nickname
            // 친구 이미지 불러오기
            if let imageURL = friend.imageURL {
                loadProfileImage(urlString: imageURL) { friendImage in
                    if let friendImage = friendImage {
                        cell.profileImageView.image = friendImage
                    } else {
                        cell.profileImageView.image = UIImage(named: "profile")
                    }
                }
            }
        }
        let chevronImage = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImage.tintColor = UIColor.semantic.textBody
        cell.accessoryView = chevronImage
        return cell
    }
}

// MARK: - UITableViewDelegate 델리게이트 구현
extension FriendListViewController: UITableViewDelegate {
    // 각 섹션 사이의 간격
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    // 각 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    // 테이블 뷰 셀을 눌렀을 때에 대한 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friendDetailVC = FriendDetailViewController()
        // 친구와의 friendshipID와 친구의 User 객체를 전달
        friendDetailVC.friendshipID = friendList[indexPath.section][0] as? String
        friendDetailVC.friend = friendList[indexPath.section][1] as? User
        self.navigationController?.pushViewController(friendDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
