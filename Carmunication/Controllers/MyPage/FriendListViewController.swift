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

    let dummyFriends = ["홍길동", "우니", "배찌", "젠", "레이", "테드", "젤리빈", "김영빈", "피카츄"]
    var friendList: [User] = []
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
            forCellReuseIdentifier: "friendListTableViewCell"
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
            guard let friendshipList else {
                return
            }
            // 친구 관계 id값으로 친구의 uid를 받아온다.
            for friendshipId in friendshipList {
                self.getFriendUid(friendshipID: friendshipId) { friendId in
                    guard let friendId else {
                        return
                    }
                    // 친구의 uid값으로 친구의 User객체를 불러온다.
                    self.getFriendUser(friendId: friendId) { friend in
                        guard let friend else {
                            return
                        }
                        self.friendList.append(friend)
                        self.friendListView.friendListTableView.reloadData()
                        print("친구목록: \(self.friendList)")
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.semantic.accPrimary
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
            guard let currentUserId = KeychainItem.currentUserIdentifier else {
                return
            }
            // sender와 receiver 중 현재 사용자에 해당하지 않는 uid를 뽑는다.
            var friendId: String = ""
            let senderValue = snapshotValue["senderId"] as? String ?? ""
            let receiverValue = snapshotValue["receiverId"] as? String ?? ""
            if currentUserId != senderValue {
                friendId = senderValue
            } else {
                friendId = receiverValue
            }
            completion(friendId)
        }
    }

    // MARK: - 친구의 uid로 DB에서 친구 데이터를 불러오기
    private func getFriendUser(friendId: String, completion: @escaping (User?) -> Void) {
        Database.database().reference().child("users/\(friendId)").getData { error, snapshot in
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
                nickname: snapshotValue["nickname"] as? String ?? "",
                imageURL: snapshotValue["imageURL"] as? String ?? "",
                friends: snapshotValue["friends"] as? [String] ?? []
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
            withIdentifier: "friendListTableViewCell",
            for: indexPath
        ) as? FriendListTableViewCell else {
            return UITableViewCell()
        }
        cell.nicknameLabel.text = friendList[indexPath.section].nickname
        // 친구 이미지 불러오기
        let imageURL = friendList[indexPath.section].imageURL
        if imageURL != "" {
            loadProfileImage(urlString: imageURL) { friendImage in
                if let friendImage = friendImage {
                    cell.profileImageView.image = friendImage
                } else {
                    cell.profileImageView.image = UIImage(named: "profile")
                }
            }
        } else {
            cell.profileImageView.image = UIImage(named: "profile")
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
        friendDetailVC.friendName = friendList[indexPath.section].nickname
        let imageURL = friendList[indexPath.section].imageURL
        self.loadProfileImage(urlString: imageURL) { friendImage in
            if let friendImage = friendImage {
                friendDetailVC.friendImage = friendImage
                self.navigationController?.pushViewController(friendDetailVC, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                friendDetailVC.friendImage = UIImage(named: "profile")
                self.navigationController?.pushViewController(friendDetailVC, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FriendListViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FriendListViewController
    func makeUIViewController(context: Context) -> FriendListViewController {
        return FriendListViewController()
    }
    func updateUIViewController(_ uiViewController: FriendListViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct FriendListViewPreview: PreviewProvider {
    static var previews: some View {
        FriendListViewControllerRepresentable()
    }
}
