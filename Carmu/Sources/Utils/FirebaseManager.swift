//
//  FirebaseManager.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/19.
//

import CoreLocation
import UIKit

import FirebaseAuth
import FirebaseDatabase

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
        let user = User(
            id: firebaseUser.uid,
            deviceToken: fcmToken,
            nickname: nickname,
            email: email,
            profileImageColor: .blue // 기본 프로필
        )
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
     uid값으로 DB에서 저장된 유저 정보 불러오기 (READ)
     - 호출되는 곳
        - LoginViewController
        - MyPageViewController
     */
    func readUser(databasePath: DatabaseReference, completion: @escaping (User?) -> Void) {
        databasePath.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let value = snapshot?.value as? [String: Any] else {
                completion(nil)
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: value)
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user)
            } catch {
                print("User decoding error", error)
                completion(nil)
            }
        }
    }

    /**
     DB에서 유저의 닉네임 값 업데이트
     - 호출되는 곳
        - NicknameEditViewController
     */
    func updateUserNickname(newNickname: String) {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        databasePath.child("nickname").setValue(newNickname as NSString)
    }

    /**
     DB에서 유저의 프로필 이미지 값 업데이트
     - 호출되는 곳
        - ProfileChangeViewController
     */
    func updateUserProfileImageColor(imageColor: ProfileImageColor) {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        let profileImageColorValue = imageColor.rawValue
        databasePath.child("profileImageColor").setValue(profileImageColorValue as NSString)
    }
}

// MARK: - 친구 관련 파이어베이스 메서드
extension FirebaseManager {

    /**
     DB에서 유저의 friendID 목록을 불러오는 메서드
     - 호출되는 곳
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
     유저가 속한 크루의
     */

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
                profileImageColor: .blue // TODO: - 일단 기본 프로필로 불러오게 했는데 수정 필요함
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
                        profileImageColor: .blue // TODO: - 일단 기본 프로필로 불러오게 했는데 수정 필요함
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

// MARK: - 크루 관련 파이어베이스 메서드
extension FirebaseManager {

    /**
     DB의 Crew에 새로운 크루를 추가하는 메서드
        호출되는 곳
            FinalConfirmViewController
     */
    func addCrew(crewData: Crew) {
        guard let key = Database.database().reference().child("crew").childByAutoId().key else {
            return
        }
        guard let captainID = KeychainItem.currentUserIdentifier else { return }
        // DB에 추가할 크루 객체
        var newCrew = crewData
        newCrew.captainID = captainID
        newCrew.id = key
        setCrewToUser(captainID, key)

        do {
            let data = try JSONEncoder().encode(newCrew)
            let json = try JSONSerialization.jsonObject(with: data)
            let childUpdates: [String: Any] = [
                "crew/\(key)": json
            ]
            Database.database().reference().updateChildValues(childUpdates)
        } catch {
            print("Crew CREATE fail...", error)
        }
    }

    /**
     크루 만들기에서 추가된 탑승자들의 User/crewList에 crewID를 추가하는 메서드
        호출되는 곳
            BoardingPointSelectViewController
            FinalConfirmViewController
     */
    func setCrewToUser(_ userID: String, _ crewID: String) {
        let databaseRef = Database.database().reference().child("users/\(userID)/crewList")

        databaseRef.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if var crewList = snapshot?.value as? [String] {
                crewList.append(crewID)
                databaseRef.setValue(crewList as NSArray)
            } else {
                // 아직 크루가 없는 경우 배열을 새로 만들어준다.
                var newCrew = []
                newCrew.append(crewID)
                databaseRef.setValue(newCrew as NSArray)
            }
        }
    }

    /**
     크루 만들기에서 추가된 크루의 crews, crewStatus에 user의 값을 집어넣는 메서드
         호출되는 곳
             BoardingPointSelectViewController
     */
    func setUserToCrew(_ userID: String, _ crewID: String) {
        let databaseRef = Database.database().reference().child("crew/\(crewID)")

        databaseRef.child("crews").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if var crews = snapshot?.value as? [String] {
                crews.append(userID)
                databaseRef.child("crews").setValue(crews as NSArray)
            } else {
                // 아직 크루가 없는 경우 배열을 새로 만들어준다.
                var newCrew = []
                newCrew.append(userID)
                databaseRef.child("crews").setValue(newCrew as NSArray)
            }
        }

        databaseRef.child("crewStatus").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if var crewStatus = snapshot?.value as? [String: String] {
                crewStatus[userID] = Status.waiting.rawValue
                databaseRef.child("crewStatus").setValue(crewStatus)
            } else {
                let newCrewStatus = [userID: Status.waiting.rawValue]
                databaseRef.child("crewStatus").setValue(newCrewStatus)
            }
        }
    }

    /**
     크루 만들기에서 추가된 크루 특정 Point의 crews에 userID 값을 집어넣는 메서드
         호출되는 곳
             BoardingPointSelectViewController
     */
    func setUserToPoint(_ userID: String, _ crewID: String, _ point: String) {
        let databaseRef = Database.database().reference().child("crew/\(crewID)/\(point)/crews")

        databaseRef.getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if var crews = snapshot?.value as? [String] {
                crews.append(userID)
                databaseRef.setValue(crews as NSArray)
            } else {
                // 아직 크루가 없는 경우 배열을 새로 만들어준다.
                var newCrew = []
                newCrew.append(userID)
                databaseRef.setValue(newCrew as NSArray)
            }
        }
    }

    /**
     DB에서 유저의 Crew 목록(crewList)을 불러오는 메서드
     - 호출되는 곳
        - SessionStartViewController
     */
    func readCrewID(databasePath: DatabaseReference) async throws -> [String]? {
        do {
            let snapshot = try await databasePath.child("crewList").getData()
            return snapshot.value as? [String]
        } catch {
            throw error
        }
    }

    /**
     crewList의 uid로 DB에서 크루 데이터 불러오는 메서드
     - 호출되는 곳
        - SessionStartViewController
     */
    func getUserCrew(crewID: String) async throws -> Crew? {
        let crewRef = Database.database().reference().child("crew/\(crewID)")

        do {
            let snapshot = try await crewRef.getData()

            guard let crewData = snapshot.value as? [String: Any] else {
                return nil
            }

            var crew = Crew(
                id: crewData["id"] as? String ?? "",
                name: crewData["name"] as? String ?? "",
                captainID: crewData["captainID"] as? UserIdentifier ?? "",
                crews: crewData["crews"] as? [UserIdentifier] ?? [""],
                startingPoint: self.convertDataToPoint(crewData["startingPoint"] as? [String: Any] ?? [:]),
                destination: self.convertDataToPoint(crewData["destination"] as? [String: Any] ?? [:]),
                inviteCode: crewData["inviteCode"] as? String ?? "",
                repeatDay: crewData["repeatDay"] as? [Int] ?? [1, 2, 3, 4, 5],
                sessionStatus: crewData["sessionStatus"] as? Status ?? .waiting,
                crewStatus: crewData["crewStatus"] as? [UserIdentifier: Status] ?? [:]
            )

            if crewData["stopover1"] != nil {
                crew.stopover1 = self.convertDataToPoint(crewData["stopover1"] as? [String: Any] ?? [:])
            }
            if crewData["stopover2"] != nil {
                crew.stopover2 = self.convertDataToPoint(crewData["stopover2"] as? [String: Any] ?? [:])
            }
            if crewData["stopover3"] != nil {
                crew.stopover3 = self.convertDataToPoint(crewData["stopover3"] as? [String: Any] ?? [:])
            }

            return crew
        } catch {
            throw error
        }
    }

    /**
     crew 데이터 불러오기

     사용 예시
     firebaseManager.getCrewData { crew in
         if let crew = crew {
             self.firebaseCrewData = crew
             print("크루 있음 ", crew)
         } else {
             print("크루없음")
         }
     }
     */
    func getCrewData() async throws -> Crew? {
        guard let databasePath = User.databasePathWithUID else {
            return nil
        }

        guard let crewList = try await readCrewID(databasePath: databasePath) else {
            return nil
        }

        guard let crewID = crewList.first else {
            return nil
        }

        return try await getUserCrew(crewID: crewID)
    }

    /**
     유저가 운전자인지 여부를 확인

     사용 예시
     firebaseManager.isCaptain { isCaptain in
         if isCaptain {
             print("캡틴임")
         } else {
             print("캡틴 아님")
         }
     }
     */
    func checkCaptain() async throws -> Bool {
        guard let databasePath = User.databasePathWithUID else {
            return false
        }

        guard let crewList = try await readCrewID(databasePath: databasePath) else {
            return false
        }

        guard let crewID = crewList.first else {
            return false
        }

        if let crew = try await getUserCrew(crewID: crewID), crew.captainID == KeychainItem.currentUserIdentifier {
            return true
        } else {
            return false
        }
    }

    func getCrewByInviteCode(inviteCode: String, completion: @escaping (Crew?) -> Void) {
        let crewsRef = Database.database().reference().child("crew")

        crewsRef
            .queryOrdered(byChild: "inviteCode")
            .queryEqual(toValue: inviteCode)
            .observeSingleEvent(of: .value) { snapshot in
                guard let crewData = snapshot.children.allObjects
                    .compactMap({ ($0 as? DataSnapshot)?.value as? [String: Any] })
                    .first else {
                    // Invite code에 해당하는 크루가 없음
                    completion(nil)
                    return
                }

                var crew = Crew(
                    id: crewData["id"] as? String ?? "",
                    name: crewData["name"] as? String ?? "",
                    captainID: crewData["captainID"] as? UserIdentifier ?? "",
                    crews: crewData["crews"] as? [UserIdentifier] ?? [""],
                    startingPoint: self.convertDataToPoint(crewData["startingPoint"] as? [String: Any] ?? [:]),
                    destination: self.convertDataToPoint(crewData["destination"] as? [String: Any] ?? [:]),
                    inviteCode: crewData["inviteCode"] as? String ?? "",
                    repeatDay: crewData["repeatDay"] as? [Int] ?? [1, 2, 3, 4, 5],
                    crewStatus: crewData["crewStatus"] as? [UserIdentifier: Status] ?? [:]
                )
                if crewData["stopover1"] != nil {
                    crew.stopover1 = self.convertDataToPoint(crewData["stopover1"] as? [String: Any] ?? [:])
                }
                if crewData["stopover2"] != nil {
                    crew.stopover2 = self.convertDataToPoint(crewData["stopover2"] as? [String: Any] ?? [:])
                }
                if crewData["stopover3"] != nil {
                    crew.stopover3 = self.convertDataToPoint(crewData["stopover3"] as? [String: Any] ?? [:])
                }

                completion(crew)
            }
    }

    /**
     json ->  Point 객체로 바꿔주는 메서드
        사용처
            getCrewByInviteCode()
     */
    func convertDataToPoint(_ data: [String: Any]) -> Point {
        var point = Point()

        point.name = data["name"] as? String
        point.detailAddress = data["detailAddress"] as? String
        point.latitude = data["latitude"] as? Double
        point.longitude = data["longitude"] as? Double

        if let timestamp = data["arrivalTime"] as? TimeInterval {
            point.arrivalTime = Date(timeIntervalSince1970: timestamp)
        }

        // crews에 대한 처리
        if let crewsData = data["crews"] as? [UserIdentifier] {
            point.crews = crewsData
        }

        return point
    }

    func convertDataToCrewStatus(_ data: [String: Any]) -> CrewStatus {
        var crewStatus = CrewStatus()

        crewStatus.name = data["name"] as? String
        crewStatus.profileColor = data["profileColor"] as? String
        crewStatus.status = data["status"] as? Status

        return crewStatus
    }
}

extension FirebaseManager {

    func updateDriverCoordinate(coordinate: CLLocationCoordinate2D) {
        // TODO: - 가입되어있는 크루로 연결 필요
        Database.database().reference().child("test/coordinate").setValue([
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ])
    }

    func startObservingDriveLocation(completion: @escaping (Double, Double) -> Void) {
        Database.database().reference().child("test").observe(.childChanged, with: { snapshot in
            if let messageData = snapshot.value as? [String: Any],
               let latitude = messageData["latitude"] as? Double,
               let longitude = messageData["longitude"] as? Double {
                completion(latitude, longitude)
            }
        })
    }
}
