//
//  FirebaseManager.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/19.
//

import UIKit

import FirebaseDatabase
import FirebaseStorage

class FirebaseManager {

    // MARK: - User 관련 메서드
    /**
     DB에서 유저의 nickname을 불러오는 메서드
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

    /**
     DB에서 유저의 friendID 목록을 불러오는 메서드
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

    /**
     uid와 friendship id를 받아서 유저의 특정 friendship 정보를 삭제해주는 메서드
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

    // MARK: - 파이어베이스 Storage 관련 메서드
    /**
     파이어베이스 Storage에서 유저 이미지 불러오기
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

    // MARK: - Point 관련 메서드
    /**
     DB의 Point에 새로운 Point를 추가하는 메서드
     */
    func addPoint(_ pointModel: Point) -> [String: String] {
        guard let key = Database.database().reference().child("point").childByAutoId().key else {
            return [String: String]()
        }
        var crewAndPoint = [String: String]()
        var newPoint = pointModel
        newPoint.pointID = key

        guard let boardingCrew = newPoint.boardingCrew else {
            return [String: String]()
        }
        for (element, _) in boardingCrew {
            crewAndPoint[element] = key
        }
        do {
            let data = try JSONEncoder().encode(newPoint)
            let json = try JSONSerialization.jsonObject(with: data)
            let childUpdates: [String: Any] = [
                "point/\(key)": json
            ]
            Database.database().reference().updateChildValues(childUpdates)
            print("포인트 값이 저장됨. 키: \(key)")
        } catch {
            print("Point CREATE fail...", error)
        }

        return crewAndPoint
    }

    // MARK: - Group 관련 메서드
    /**
     DB의 Group에 새로운 그룹을 추가하는 메서드
     */
    func addGroup(_ crewAndPoint: [String: String], _ groupName: String) {
        guard let key = Database.database().reference().child("group").childByAutoId().key else {
            return
        }
        guard let captainID = KeychainItem.currentUserIdentifier else { return }

        // DB에 추가할 그룹 객체
        let newGroup = Group(
            groupID: key,
            groupName: groupName,
            // groupImage 추가 필요
            captainID: captainID,
            sessionDay: [1, 2, 3, 4, 5],
            crewAndPoint: crewAndPoint,
            sessionList: [String](),
            accumulateDistance: 0

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

    // MARK: - SessionStartView 관련 메서드
    /**
        DB에서 유저의 Group 목록(groupList)을 불러오는 메서드
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

    // groupList의 uid로 DB에서 그룹 데이터 불러오기
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
                groupID: snapshotValue["groupID"] as? String ?? "",
                groupName: snapshotValue["groupName"] as? String ?? "",
                groupImage: snapshotValue["groupImage"] as? String ?? "profile",
                captainID: snapshotValue["captainID"] as? String ?? "",
                sessionDay: snapshotValue["sessionDay"] as? [Int] ?? [1, 2, 3, 4, 5],
                crewAndPoint: snapshotValue["crewAndPoint"] as? [String: String] ?? ["": ""],
                sessionList: snapshotValue["sessionList"] as? [String] ?? [],
                accumulateDistance: snapshotValue["accumulateDistance"] as? Int ?? 0
            )
            completion(group)
        }

    }

}
