//
//  FriendDetailViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/11.
//

import UIKit

import FirebaseDatabase
import FirebaseStorage

final class FriendDetailViewController: UIViewController {

    // 친구 리스트 화면에서 받아올 친구 정보
    var friend: User?
    var friendshipID: String? // 유저-친구 간의 friendshipID

    let dummyImage = ["coffee", "box", "shoppingBag", "letter"]
    let dummydistance = [200, 400, 500, 1000]
    let dummyName = ["커피 한 잔", "1만원 이내의 선물", "3만원 이내의 선물", "주유상품권"]

    private let friendDetailView = FriendDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "친구삭제",
            style: .plain,
            target: self,
            action: #selector(showDeleteFriendAlert)
        )

        view.addSubview(friendDetailView)
        friendDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        friendDetailView.giftCollectionView.register(
            GiftCardCollectionViewCell.self,
            forCellWithReuseIdentifier: GiftCardCollectionViewCell.cellIdentifier
        )
        friendDetailView.giftCollectionView.delegate = self
        friendDetailView.giftCollectionView.dataSource = self

        // 이전 친구 리스트 화면에서 전달받은 닉네임과 이미지를 반영
        if let friend = friend {
            friendDetailView.friendNickname.text = friend.nickname
            if let imageURL = friend.imageURL { // imageURL이 있다면 이미지를 로드해서 반영해준다.
                loadProfileImage(urlString: imageURL) { friendImage in
                    if let friendImage = friendImage {
                        self.friendDetailView.friendImage.image = friendImage
                    }
                }
            } else {
                self.friendDetailView.friendImage.image = UIImage(named: "profile")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.semantic.textSecondary
    }

    // 친구 삭제 알럿에서 [삭제] 선택 시 호출되는 메서드
    private func performDeletingFriend(myUID: String, friendUID: String, friendshipID: String) {
        deleteUserFriendship(uid: myUID, friendshipID: friendshipID)
        deleteUserFriendship(uid: friendUID, friendshipID: friendshipID)
        deleteFriendship(friendshipID: friendshipID)
    }
}

// MARK: - @objc 메서드
extension FriendDetailViewController {

    // [친구삭제] 버튼 클릭 시 알럿 띄우기
    @objc private func showDeleteFriendAlert() {
        let deleteAlertController = UIAlertController(
            title: "친구를 삭제하시겠어요?",
            message: nil,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let performDelete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            guard let uid = KeychainItem.currentUserIdentifier,
                  let friendUID = self.friend?.id,
                  let friendshipID = self.friendshipID else {
                return
            }
            self.performDeletingFriend(myUID: uid, friendUID: friendUID, friendshipID: friendshipID)
        }
        deleteAlertController.addAction(cancel)
        deleteAlertController.addAction(performDelete)
        self.present(deleteAlertController, animated: true)
    }
}

// MARK: - Firebase Realtime Database DB 관련 메서드
extension FriendDetailViewController {

    // MARK: - uid와 friendship id를 받아서 유저의 특정 friendship 정보를 삭제해주는 메서드
    private func deleteUserFriendship(uid: String, friendshipID: String) {
        let databaseRef = Database.database().reference().child("users/\(uid)/friends")
        databaseRef.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if var friends = snapshot?.value as? [String] {
                // 배열에서 friendshipID 값을 제거하고, 해당 값으로 업데이트 해준다.
                friends = friends.filter { $0 != friendshipID }
                databaseRef.setValue(friends as NSArray)
            }
        }
    }

    // MARK: - friendship에서 특정 friendship id에 해당하는 노드를 삭제해주는 메서드
    private func deleteFriendship(friendshipID: String) {
        let databaseRef = Database.database().reference().child("friendship/\(friendshipID)")
        databaseRef.removeValue()
        print("\(friendshipID)에 해당하는 Friendship이 삭제되었습니다!!")
    }
}

// MARK: - Firebase Storage 관련 메서드
extension FriendDetailViewController {
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

// MARK: - UICollectionViewDataSource 델리게이트 구현
extension FriendDetailViewController: UICollectionViewDataSource {

    // 컬렉션 뷰의 아이템이 몇개인지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    // 컬렉션 뷰 셀 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GiftCardCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? GiftCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.giftImageView.image = UIImage(named: dummyImage[indexPath.row])
        cell.distanceLabel.text = "\(dummydistance[indexPath.row])km"
        cell.giftNameLabel.text = dummyName[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout 델리게이트 구현 (UICollectionViewDelegate는 해당 프로토콜에서 채택 중)
extension FriendDetailViewController: UICollectionViewDelegateFlowLayout {

    // 위 아래 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }

    // 좌우 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }

    // 컬렉션 뷰의 사이즈
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 컬렉션 뷰의 프레임을 기준으로 셀의 크기를 잡아준다.
        let cellWidth: CGFloat = friendDetailView.giftCollectionView.frame.width / 2 - 5
        let cellHeight: CGFloat = friendDetailView.giftCollectionView.frame.height / 2 - 6

        return CGSize(width: cellWidth, height: cellHeight)
    }
}
