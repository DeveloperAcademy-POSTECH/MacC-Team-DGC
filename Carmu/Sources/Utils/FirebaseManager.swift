//
//  FirebaseManager.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/19.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

// MARK: - 유저 관련 파이어베이스 메서드
class FirebaseManager {

    private let encoder = JSONEncoder()

    /**
     유저 신규 등록 메서드(CREATE)
     - 호출되는 곳
        - LoginViewController
     */
    func createUser(user firebaseUser: FirebaseAuth.User) {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let nickname = firebaseUser.displayName,
              let email = firebaseUser.email else {
            return
        }

        guard let fcmToken = KeychainItem.currentUserDeviceToken else {
            return
        }
        print("FCMToken -> ", fcmToken)
        let user = User(id: firebaseUser.uid, deviceToken: fcmToken, nickname: nickname, email: email)
        do {
            let data = try encoder.encode(user)

            let json = try JSONSerialization.jsonObject(with: data)
            databasePath.setValue(json)
            print("User CREATE success!!")
        } catch {
            print("User CREATE fail..", error)
        }
    }

    /**
     유저 업데이트 (UPDATE)
     - 호출되는 곳
        - LoginViewController
     */
    func updateUser(user firebaseUser: FirebaseAuth.User, updatedUser: User) {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let email = firebaseUser.email else {
            return
        }
        // 디바이스 토큰값 갱신
        guard let fcmToken = KeychainItem.currentUserDeviceToken else {
            return
        }
        var newUserValue = updatedUser
        newUserValue.email = email
        newUserValue.deviceToken = fcmToken
        let user = newUserValue

        do {
            let data = try encoder.encode(user)
            let json = try JSONSerialization.jsonObject(with: data)
            databasePath.setValue(json)
            print("User UPDATE success!!")
        } catch {
            print("User UPDATE fail..", error)
        }
    }

    /**
     파이어베이스에 저장된 유저 확인 메서드
     - 호출되는 곳
        - LoginViewController
     */
    func checkUser(databasePath: DatabaseReference, completion: @escaping (User?) -> Void) {
        databasePath.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            if let value = snapshot?.value as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: value)
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(user)
                } catch {
                    print("User decoding error", error)
                    completion(nil)
                }
            } else {
                print("Invalid data format")
                completion(nil)
            }
        }
    }

    /**
     DB에서 유저의 nickname을 불러오는 메서드
     - 호출되는 곳
        - MyPageViewController
     */
    func readNickname(databasePath: DatabaseReference, completion: @escaping (String?) -> Void) {
        databasePath.child("nickname").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            let nickname = snapshot?.value as? String
            completion(nickname)
        }
    }

    /**
     DB 유저 정보에 이미지 경로 저장
     - 호출되는 곳
        - MyPageViewController
     */
    func addImageUrlToDB(imageURL: String?) {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let imageURL = imageURL else {
            databasePath.child("imageURL").setValue(nil)
            return
        }
        databasePath.child("imageURL").setValue(imageURL as NSString)
    }

    /**
     DB에서 유저 이미지 경로 불러오기
     - 호출되는 곳
        - MyPageViewController
     */
    func readProfileImageURL(databasePath: DatabaseReference, completion: @escaping (String?) -> Void) {
        databasePath.child("imageURL").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshotValue = snapshot?.value else {
                completion(nil)
                return
            }
            let imageURL = snapshotValue as? String
            completion(imageURL)
        }
    }
}

// MARK: - 친구 관련 파이어베이스 메서드
extension FirebaseManager {

    /**
     DB에서 유저의 friendID 목록을 불러오는 메서드
     - 호출되는 곳
        - SessionStartViewController
        - NoticeLateViewController
        - SettingsViewController
        - FriendListViewController
     */
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

    /**
     friendID 값으로 DB에서 Friendship의 친구 id를 불러오는 메서드
     - 호출되는 곳
        - SessionStartViewController
        - NoticeLateViewController
        - SettingsViewController
        - FriendListViewController
    */
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

    /**
     친구의 uid로 DB에서 친구 데이터를 불러오기
     - 호출되는 곳
        - SessionStartViewController
        - NoticeLateViewController
        - FriendListViewController
        - FriendAddViewController
    */
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
                id: snapshotValue["id"] as? UserIdentifier ?? "",
                deviceToken: snapshotValue["deviceToken"] as? String ?? "",
                nickname: snapshotValue["nickname"] as? String ?? "",
                email: snapshotValue["email"] as? String,
                imageURL: snapshotValue["imageURL"] as? String,
                friends: snapshotValue["friends"] as? [String]
            )
            completion(friend)
        }
    }

    /**
     uid와 friendship id를 받아서 유저의 특정 friendship 정보를 삭제해주는 메서드
     - 호출되는 곳
        - SettingsViewController
        - FriendDetailViewController
     */
    func deleteUserFriendship(uid: String, friendshipID: String) {
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

    /**
     friendship에서 특정 friendship id에 해당하는 노드를 삭제해주는 메서드
     - 호출되는 곳
        - FriendDetailViewController
     */
    func deleteFriendship(friendshipID: String) {
        let databaseRef = Database.database().reference().child("friendship/\(friendshipID)")
        databaseRef.removeValue()
        print("\(friendshipID)에 해당하는 Friendship이 삭제되었습니다!!")
    }

    /**
     닉네임에 해당하는 친구를 DB에서 검색하는 메서드
     - 호출되는 곳
        - FriendAddViewController
     */
    func searchUserNickname(searchNickname: String, completion: @escaping (User?) -> Void) {
        Database.database().reference().child("users").observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                guard let snap = child as? DataSnapshot else {
                    completion(nil)
                    return
                }
                guard let dict = snap.value as? [String: Any] else {
                    completion(nil)
                    return
                }
                if dict["nickname"] as? String == searchNickname {
                    print("\(searchNickname)이(가) 검색되었습니다!!!")
                    let searchedFriend = User(
                        id: dict["id"] as? UserIdentifier ?? "",
                        deviceToken: dict["deviceToken"] as? String ?? "",
                        nickname: dict["nickname"] as? String ?? "",
                        email: dict["email"] as? String,
                        imageURL: dict["imageURL"] as? String,
                        friends: dict["friends"] as? [String]
                    )
                    completion(searchedFriend)
                    return
                }
            }
            completion(nil)
        }
    }

    /**
     DB의 friendship에 새로운 친구 관계를 추가하는 메서드
     - 호출되는 곳
        - FriendAddViewController
     */
    func addFriendship(myUID: String, friendUID: String) {
        guard let key = Database.database().reference().child("friendship").childByAutoId().key else {
            return
        }
        print("새로운 Friendship Key: \(key)")
        // DB의 friendship에 새로 추가할 친구 관계 객체
        let newFriendship = Friendship(
            friendshipID: key,
            senderID: myUID,
            receiverID: friendUID,
            status: true // TODO: - 이후 친구 수락 시 true로 바뀌게끔 수정 필요
        )
        // 사용자와 친구 DB의 friends에 새로운 friendship의 key를 추가해서 업데이트
        addNewValueToUserFriends(uid: myUID, newValue: key)
        addNewValueToUserFriends(uid: friendUID, newValue: key)
        // 호환되는 타입으로 캐스팅 후 DB에 Friendship 추가
        do {
            let data = try JSONEncoder().encode(newFriendship)
            let json = try JSONSerialization.jsonObject(with: data)
            let childUpdates: [String: Any] = [
                "friendship/\(key)": json
            ]
            Database.database().reference().updateChildValues(childUpdates)
        } catch {
            print("Friendship CREATE fail...", error)
        }
    }

    /**
     DB에서 유저의 friends 목록에 새로운 friendshipId를 추가하는 메서드
     - 호출되는 곳
        -
     */
    func addNewValueToUserFriends(uid: String, newValue: String) {
        let databaseRef = Database.database().reference().child("users/\(uid)/friends")
        print("다음 경로에 추가합니다!!! \(databaseRef)")
        databaseRef.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if var friends = snapshot?.value as? [String] {
                friends.append(newValue)
                databaseRef.setValue(friends as NSArray)
            } else {
                // 아직 친구가 없는 경우 배열을 새로 만들어준다.
                var newFriends = []
                newFriends.append(newValue)
                databaseRef.setValue(newFriends as NSArray)
            }
        }
    }
}

// MARK: - 그룹 관련 파이어베이스 메서드
extension FirebaseManager {

    /**
     DB의 Group에 새로운 그룹을 추가하는 메서드
     - 호출되는 곳
        - XXX
     */
    func addGroup(_ crewAndPoint: [String: String], _ groupName: String) {
        guard let key = Database.database().reference().child("group").childByAutoId().key else {
            return
        }
        guard let captainID = KeychainItem.currentUserIdentifier else { return }

        // DB에 추가할 그룹 객체
        let newGroup = Group(
            id: key,
            name: groupName,
            // groupImage 추가 필요
            captainID: captainID,
            crews: []
        )
        setGroupToUser(captainID, key)
        for (crewKey, _) in crewAndPoint {
            setGroupToUser(crewKey, key)
        }

        do {
            let data = try JSONEncoder().encode(newGroup)
            let json = try JSONSerialization.jsonObject(with: data)
            let childUpdates: [String: Any] = [
                "group/\(key)": json
            ]
            Database.database().reference().updateChildValues(childUpdates)
        } catch {
            print("Group CREATE fail...", error)
        }
    }

    /**
     크루 만들기에서 추가된 탑승자들의 User/groupList에 groupID를 추가하는 메서드
     - 호출되는 곳
        -
     */
    func setGroupToUser(_ userID: String, _ groupID: String) {
        let databaseRef = Database.database().reference().child("users/\(userID)/groupList")

        databaseRef.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if var groupList = snapshot?.value as? [String] {
                groupList.append(groupID)
                databaseRef.setValue(groupList as NSArray)
            } else {
                // 아직 그룹이 없는 경우 배열을 새로 만들어준다.
                var newGroup = []
                newGroup.append(groupID)
                databaseRef.setValue(newGroup as NSArray)
            }
        }
    }

    /**
     DB에서 유저의 Group 목록(groupList)을 불러오는 메서드
     - 호출되는 곳
        - SessionStartViewController
     */
    func readGroupID(databasePath: DatabaseReference, completion: @escaping ([String]?) -> Void) {
        databasePath.child("groupList").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            let groups = snapshot?.value as? [String]
            completion(groups)
        }
    }

    /**
     groupList의 uid로 DB에서 그룹 데이터 불러오는 메서드
     - 호출되는 곳
        - SessionStartViewController
     */
    func getUserGroup(groupID: String, completion: @escaping (Group?) -> Void) {
        Database.database().reference().child("group/\(groupID)").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshotValue = snapshot?.value as? [String: Any] else {
                return
            }
            let group = Group(
                id: snapshotValue["id"] as? String ?? "",
                name: snapshotValue["name"] as? String ?? "",
                captainID: snapshotValue["captainID"] as? String ?? "",
                crews: snapshotValue["crews"] as? [UserIdentifier] ?? [""]
            )
            completion(group)
        }

    }
}

// MARK: - 파이어베이스 Storage 관련 메서드
extension FirebaseManager {

    /**
     파이어베이스 Storage에서 유저 이미지 불러오기
     - 호출되는 곳
        - MyPageViewController
        - FriendListViewController
        - FriendAddViewController
        - FriendDetailViewController
     */
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

    /**
     파이어베이스 Storage에 이미지 업로드
     - 호출되는 곳
        - MyPageViewController
     */
    func uploadImageToStorage(image: UIImage, imageName: String, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        // 파이어베이스 Storage에 대한 참조
        let firebaseStorageRef = Storage.storage().reference().child("images/\(imageName)")
        firebaseStorageRef.putData(imageData, metadata: metaData) { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            firebaseStorageRef.downloadURL { url, _ in
                completion(url)
            }
        }
    }

    /**
     파이어베이스 Storage에서 유저 이미지 삭제하기
     - 호출되는 곳
        - MyPageViewController
        - SettingsViewController
     */
    func deleteProfileImage(imageName: String) {
        let firebaseStorageRef = Storage.storage().reference().child("images/\(imageName)")
        firebaseStorageRef.delete { error in
            if let error = error {
                print("이미지 삭제에 실패했습니다.", error.localizedDescription)
            } else {
                print("이미지가 성공적으로 삭제되었습니다.")
            }
        }
    }
}
