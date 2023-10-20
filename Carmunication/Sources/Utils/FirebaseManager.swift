//
//  FirebaseManager.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/19.
//

import UIKit

import FirebaseDatabase
import FirebaseStorage

class FirebaseManager {

    // MARK: - DB에서 유저의 friendID 목록을 불러오는 메서드
    func readUserFriendshipList(databasePath: DatabaseReference, completion: @escaping ([String]?) -> Void) {
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
    func getFriendUid(friendshipID: String, completion: @escaping (String?) -> Void) {
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
    func getFriendUser(friendID: String, completion: @escaping (User?) -> Void) {
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

    // MARK: - 파이어베이스 Storage에서 유저 이미지 불러오기
    // TODO: - MyPageViewController와 중복되는 메서드 -> 정리 필요함
    func loadProfileImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
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
