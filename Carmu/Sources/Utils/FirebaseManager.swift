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

    // TODO: - MyPageViewController와 중복되는 메서드 -> 정리 필요함
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
        newPoint.id = key

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
            id: key,
            name: groupName,
            // groupImage 추가 필요
            captainID: captainID,
            sessionDay: [1, 2, 3, 4, 5],
            crewAndPoint: crewAndPoint,
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
                id: snapshotValue["groupID"] as? String ?? "",
                name: snapshotValue["groupName"] as? String ?? "",
                image: snapshotValue["groupImage"] as? String ?? "profile",
                captainID: snapshotValue["captainID"] as? String ?? "",
                sessionDay: snapshotValue["sessionDay"] as? [Int] ?? [1, 2, 3, 4, 5],
                crewAndPoint: snapshotValue["crewAndPoint"] as? [String: String] ?? ["": ""],
                accumulateDistance: snapshotValue["accumulateDistance"] as? Int ?? 0
            )
            completion(group)
        }

    }

}
