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
    // TODO: - async 코드로 대체되면 삭제
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
     uid값으로 DB에서 저장된 유저 정보 불러오기 (READ)
     - 호출되는 곳
        - LoginViewController
        - MyPageViewController
     */
    func readUserAsync(databasePath: DatabaseReference) async throws -> User? {
        do {
            let data = try await databasePath.getData()
            guard let value = data.value as? [String: Any] else {
                return nil
            }
            let jsonData = try JSONSerialization.data(withJSONObject: value)
            let userData = try JSONDecoder().decode(User.self, from: jsonData)
            return userData
        } catch {
            throw error
        }
    }

    func checkHasCrewAsync() async -> Bool {
        guard let databasePath = User.databasePathWithUID else {
            return false
        }

        do {
            let user = try await readUserAsync(databasePath: databasePath)
            return user?.crewID != nil
        } catch {
            return false
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
        newCrew.sessionStatus = Status.waiting
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
     Crew를 수정된 내용으로 업데이트해주는 메서드
     - 호출되는 곳
        - CrewEditViewController
     */
    func updateCrew(crewID: String, newCrewData: Crew) {
        let databaseRef = Database.database().reference().child("crew/\(crewID)")
        do {
            let data = try encoder.encode(newCrewData)
            let json = try JSONSerialization.jsonObject(with: data)
            databaseRef.setValue(json)
            print("Crew UPDATE success!!")
        } catch {
            print("Crew UPDATE fail...", error)
        }
    }

    /**
     DB에서 크루명 업데이트
     - 호출되는 곳
        - CreInfoCheckViewController
     */
    func updateCrewName(crewID: String, newCrewName: String) {
        let databaseRef = Database.database().reference().child("crew/\(crewID)/name")
        databaseRef.setValue(newCrewName)
    }

    /**
     크루 만들기에서 추가된 탑승자들의 User/crewList에 crewID를 추가하는 메서드
        호출되는 곳
            BoardingPointSelectViewController
            FinalConfirmViewController
     */
    func setCrewToUser(_ userID: String, _ crewID: String) {
        // Firebase 데이터베이스 참조 생성
        let databaseRef = Database.database().reference().child("users/\(userID)")

        // 데이터베이스에서 해당 유저의 정보를 가져온 후 업데이트
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if var userData = snapshot.value as? [String: Any] {
                    // userData에서 crewList 키의 값을 가져오고, 없으면 빈 배열 생성
                    var crewList = userData["crewList"] as? [String] ?? []

                    // crewList 배열에 crewID 추가
                    crewList.append(crewID)

                    // userData에 업데이트된 crewList 값을 설정
                    userData["crewList"] = crewList

                    // 업데이트된 userData를 다시 Firebase에 저장
                    databaseRef.setValue(userData) { error, _ in
                        if let error = error {
                            print("Error updating crewList for \(userID): \(error.localizedDescription)")
                        } else {
                            print("CrewList updated successfully for \(userID).")
                        }
                    }
                } else {
                    print("Invalid data format for \(userID)")
                }
            } else {
                // 데이터가 존재하지 않는 경우
                print("Data does not exist for \(userID)")
            }
        }
    }

    /**
     크루 만들기에서 추가된 크루의 crews, memberStatus에 user의 값을 집어넣는 메서드
         호출되는 곳
             BoardingPointSelectViewController
     */
    func setUserToCrew(_ userID: String, _ crewID: String) {
        Task {
            // Firebase 데이터베이스 참조 생성
            let databaseRef = Database.database().reference().child("crew/\(crewID)")

            guard let databasePath = User.databasePathWithUID else {
                return
            }

            let user = try await readUserAsync(databasePath: databasePath)
            guard let user = user else { return }
            // 크루 데이터에서 필요한 값을 가져와서 newMemberStatus 객체에 설정
            let newMemberStatus: [String: Any] = [
                "id": userID,
                "deviceToken": user.deviceToken,
                "nickname": user.nickname,
                "profileColor": user.profileImageColor.rawValue,
                "status": "waiting"
            ]

            // 데이터베이스에서 크루 정보를 가져온 후 업데이트
            databaseRef.observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    if var crewData = snapshot.value as? [String: Any] {

                        // memberStatus 배열을 가져오고, 없으면 빈 배열 생성
                        var memberStatusArray = crewData["memberStatus"] as? [[String: Any]] ?? []

                        // 새로운 memberStatus 객체를 배열에 추가
                        memberStatusArray.append(newMemberStatus)

                        // crewData에 업데이트된 memberStatus 값을 설정
                        crewData["memberStatus"] = memberStatusArray

                        // 업데이트된 crewData를 다시 Firebase에 저장
                        databaseRef.setValue(crewData) { error, _ in
                            if let error = error {
                                print("Error updating crews: \(error.localizedDescription)")
                            } else {
                                print("Crews updated successfully.")
                            }
                        }
                    } else {
                        print("Invalid crew data format for \(crewID)")
                    }
                } else {
                    // 데이터가 존재하지 않는 경우
                    print("Crew data does not exist for \(crewID)")
                }
            }
        }
    }

    /**
     크루 만들기에서 추가된 크루 특정 Point의 crews에 userID 값을 집어넣는 메서드
         호출되는 곳
             BoardingPointSelectViewController
     */
    func setUserToPoint(_ userID: String, _ crewID: String, _ point: String) {
            // Firebase 데이터베이스 참조 생성
            let databaseRef = Database.database().reference().child("crew/\(crewID)/\(point)")
            // 데이터베이스에서 해당 포인트의 크루 정보를 가져온 후 업데이트
            databaseRef.observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    if var pointData = snapshot.value as? [String: Any] {
                        // crews 배열 확인
                        if var crews = pointData["crews"] as? [String] {
                            // crews 배열에 userID 추가
                            crews.append(userID)
                            pointData["crews"] = crews
                        } else {
                            // crews 배열이 없으면 새로운 배열 생성 후 userID 추가
                            pointData["crews"] = [userID]
                        }

                        // 업데이트된 pointData를 다시 Firebase에 저장
                        databaseRef.setValue(pointData) { error, _ in
                            if let error = error {
                                print("Error updating crews for \(point): \(error.localizedDescription)")
                            } else {
                                print("Crews updated successfully for \(point).")
                            }
                        }
                    } else {
                        print("Invalid data format for \(point)")
                    }
                } else {
                    // 데이터가 존재하지 않는 경우
                    print("Data does not exist for \(point)")
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
    // 기존의 식 (안되는 것)
//    func getUserCrew(crewID: String) async throws -> Crew? {
//        let crewRef = Database.database().reference().child("crew/\(crewID)")
//
//        print("CREWREF ---> ", crewRef.url)
//        do {
//            let snapshot = try await crewRef.getData()
//
//            print("snapSHot --> ", snapshot)
//
//            guard let crewData = snapshot.value as? [String: Any] else {
//                return nil
//            }
//            // MARK: - CrewData 값이 이상하게 들어옴
//            // 처음아닐 때 부터 생성하면 crew자체가 배열로 들어옴.
//            // but, 생성되어 있으면, crew/(crewID)에 있는 값이 제대로 들어옴
//            var crew = Crew(
//                id: crewData["id"] as? String ?? "",
//                name: crewData["name"] as? String ?? "",
//                captainID: crewData["captainID"] as? UserIdentifier ?? "",
//                crews: crewData["crews"] as? [UserIdentifier] ?? [""],
//                startingPoint: self.convertDataToPoint(crewData["startingPoint"] as? [String: Any] ?? [:]),
//                destination: self.convertDataToPoint(crewData["destination"] as? [String: Any] ?? [:]),
//                inviteCode: crewData["inviteCode"] as? String ?? "",
//                repeatDay: crewData["repeatDay"] as? [Int] ?? [1, 2, 3, 4, 5],
//                sessionStatus: Status(rawValue: crewData["sessionStatus"] as? String ?? "waiting") ?? .waiting,
//                memberStatus: self.convertDataToMemberStatus(crewData["memberStatus"] as? [[String: Any]] ?? [])
//            )
//
//            if crewData["stopover1"] != nil {
//                crew.stopover1 = self.convertDataToPoint(crewData["stopover1"] as? [String: Any] ?? [:])
//            }
//            if crewData["stopover2"] != nil {
//                crew.stopover2 = self.convertDataToPoint(crewData["stopover2"] as? [String: Any] ?? [:])
//            }
//            if crewData["stopover3"] != nil {
//                crew.stopover3 = self.convertDataToPoint(crewData["stopover3"] as? [String: Any] ?? [:])
//            }
//
//            return crew
//        } catch {
//            throw error
//        }
//    }

    // 되긴 되지만 수정이 필요할 것 같은 메서드
    func getUserCrew(crewID: String) async throws -> Crew? {
        let crewRef = Database.database().reference().child("crew/\(crewID)")

        do {
            let snapshot = try await crewRef.getData()
            guard let crewData = snapshot.value as? [String: Any] else {
                return nil
            }
            if let nestedCrewData = crewData[crewID] as? [String: Any] {
                // 데이터 형식 1: crewData가 딕셔너리 안에 또 다른 딕셔너리가 있는 경우

                guard let crewIDValue = nestedCrewData["id"] as? String, crewIDValue == crewID else {
                    return nil
                }

                // 필요한 데이터를 가져와 Crew 객체를 초기화
                var crew = Crew(
                    id: crewIDValue,
                    name: nestedCrewData["name"] as? String ?? "",
                    captainID: nestedCrewData["captainID"] as? UserIdentifier ?? "",
                    startingPoint: self.convertDataToPoint(nestedCrewData["startingPoint"] as? [String: Any] ?? [:]),
                    destination: self.convertDataToPoint(nestedCrewData["destination"] as? [String: Any] ?? [:]),
                    inviteCode: nestedCrewData["inviteCode"] as? String ?? "",
                    repeatDay: nestedCrewData["repeatDay"] as? [Int] ?? [1, 2, 3, 4, 5],
                    sessionStatus: Status(rawValue: nestedCrewData["sessionStatus"] as? String ?? "waiting") ?? .waiting,
                    memberStatus: self.convertDataToMemberStatus(nestedCrewData["memberStatus"] as? [[String: Any]] ?? []),
                    lateTime: nestedCrewData["lateTime"] as? UInt ?? 0
                )

                // 나머지 부분은 그대로 유지
                if nestedCrewData["stopover1"] != nil {
                    crew.stopover1 = self.convertDataToPoint(nestedCrewData["stopover1"] as? [String: Any] ?? [:])
                }
                if nestedCrewData["stopover2"] != nil {
                    crew.stopover2 = self.convertDataToPoint(nestedCrewData["stopover2"] as? [String: Any] ?? [:])
                }
                if nestedCrewData["stopover3"] != nil {
                    crew.stopover3 = self.convertDataToPoint(nestedCrewData["stopover3"] as? [String: Any] ?? [:])
                }

                return crew
            } else {
                // 데이터 형식 2: crewData 자체가 바로 Crew 객체인 경우
                guard let crewIDValue = crewData["id"] as? String, crewIDValue == crewID else {
                    return nil
                }

                // 필요한 데이터를 가져와 Crew 객체를 초기화
                var crew = Crew(
                    id: crewIDValue,
                    name: crewData["name"] as? String ?? "",
                    captainID: crewData["captainID"] as? UserIdentifier ?? "",
                    startingPoint: self.convertDataToPoint(crewData["startingPoint"] as? [String: Any] ?? [:]),
                    destination: self.convertDataToPoint(crewData["destination"] as? [String: Any] ?? [:]),
                    inviteCode: crewData["inviteCode"] as? String ?? "",
                    repeatDay: crewData["repeatDay"] as? [Int] ?? [1, 2, 3, 4, 5],
                    sessionStatus: Status(rawValue: crewData["sessionStatus"] as? String ?? "waiting") ?? .waiting,
                    memberStatus: self.convertDataToMemberStatus(crewData["memberStatus"] as? [[String: Any]] ?? []),
                    lateTime: crewData["lateTime"] as? UInt ?? 0
                )

                // 나머지 부분은 그대로 유지
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
            }
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

        do {
            guard let crewList = try await readCrewID(databasePath: databasePath) else { return nil }
            guard let crewID = crewList.first else { return nil }

            return try await getUserCrew(crewID: crewID)
        } catch {
            // 어떤 에러가 발생했을 경우
            print("Error: \(error)")
            return nil
        }
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
    func checkCaptain(crewData: Crew) -> Bool {
        guard let captainID = crewData.captainID else { return false }
        if captainID == KeychainItem.currentUserIdentifier {
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
                    startingPoint: self.convertDataToPoint(crewData["startingPoint"] as? [String: Any] ?? [:]),
                    destination: self.convertDataToPoint(crewData["destination"] as? [String: Any] ?? [:]),
                    inviteCode: crewData["inviteCode"] as? String ?? "",
                    repeatDay: crewData["repeatDay"] as? [Int] ?? [1, 2, 3, 4, 5],
                    memberStatus: self.convertDataToMemberStatus(crewData["memberStatus"] as? [[String: Any]] ?? []),
                    lateTime: crewData["lateTime"] as? UInt ?? 0
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

    // Data를 MemberStatus로 불러옴
    func convertDataToMemberStatus(_ data: [[String: Any]]) -> [MemberStatus] {
        var memberStatusArray = [MemberStatus]()

        for statusData in data {
            if let nickname = statusData["nickname"] as? String,
               let id = statusData["id"] as? String,
               let deviceToken = statusData["deviceToken"] as? String,
               let profileColor = statusData["profileColor"] as? String,
               let statusString = statusData["status"] as? String,
               let statusEnum = Status(rawValue: statusString),
               let lateTime = statusData["lateTime"] as? UInt {
                let status = MemberStatus(
                    id: id,
                    deviceToken: deviceToken,
                    nickname: nickname,
                    profileColor: profileColor,
                    status: statusEnum,
                    lateTime: lateTime
                )
                memberStatusArray.append(status)
            }
        }
        return memberStatusArray
    }

    /// 운전자의 위도, 경도 정보로 변환해주는 메서드
    func convertDataToDriverCoordinate(_ data: [String: Any]) -> Coordinate {
        Coordinate(
            latitude: data["latitude"] as? Double ?? 0.0,
            longitude: data["longitude"] as? Double ?? 0.0
        )
    }
}

// MARK: - 맵뷰 관련 메서드
extension FirebaseManager {

    func updateDriverCoordinate(coordinate: CLLocationCoordinate2D, crewID: String?) {
        guard let crewID = crewID else { return }
        Database.database().reference().child("crew/\(crewID)/driverCoordinate").setValue([
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ])
    }

    func updateLateTime(lateTime: UInt, crew: Crew) {
        let isDriver = KeychainItem.currentUserIdentifier == crew.captainID
        if isDriver {
            updateCrewLateTime(lateTime: lateTime, crew: crew)
        } else {
            updateMemberLateTime(lateTime: lateTime, crew: crew)
        }
    }

    /// [운전자] '지각 알리기' 버튼 눌렀을 때의 동작. Crew의 lateTime을 갱신한다.
    private func updateCrewLateTime(lateTime: UInt, crew: Crew) {
        guard let crewID = crew.id else { return }
        guard KeychainItem.currentUserIdentifier == crew.captainID else { return }

        let crewReference = Database.database().reference().child("crew/\(crewID)/lateTime")
        crewReference.observeSingleEvent(of: .value, with: { snapshot in
            guard let beforeLateTime = snapshot.value as? UInt else {
                return
            }
            crewReference.setValue(beforeLateTime + lateTime)
        })
    }

    /// [탑승자] '지각 알리기' 버튼 눌렀을 때의 동작. 해당 MemberStatus의 lateTime을 갱신한다.
    private func updateMemberLateTime(lateTime: UInt, crew: Crew) {
        guard let myUID = KeychainItem.currentUserIdentifier else { return }
        guard let crewID = crew.id else { return }

        let memberStatusReference = Database.database().reference().child("crew/\(crewID)/memberStatus")
        memberStatusReference.observeSingleEvent(of: .value, with: { snapshot in
            guard let memberStatus = snapshot.value as? [[String: Any]] else {
                return
            }
            for (index, member) in memberStatus.enumerated() {
                guard let uid = member["id"] as? String, let beforeLateTime = member["lateTime"] as? UInt else {
                    continue
                }
                if uid == myUID {
                    memberStatusReference.child("\(index)/lateTime").setValue(beforeLateTime + lateTime)
                    break
                }
            }
        })
    }

    func startObservingMemberStatus(crewID: String?, completion: @escaping ([MemberStatus]) -> Void) {
        guard let crewID = crewID else { return }
        Database.database().reference().child("crew/\(crewID)").observe(.value) { snapshot in
            guard let crewData = snapshot.value as? [String: Any] else {
                return
            }
            let memberStatus = self.convertDataToMemberStatus(crewData["memberStatus"] as? [[String: Any]] ?? [])
            completion(memberStatus)
        }
    }

    func startObservingDriverCoordinate(crewID: String?, completion: @escaping (Double, Double) -> Void) {
        guard let crewID = crewID else { return }
        Database.database().reference().child("crew/\(crewID)").observe(.childChanged, with: { snapshot in
            if let messageData = snapshot.value as? [String: Any],
               let latitude = messageData["latitude"] as? Double,
               let longitude = messageData["longitude"] as? Double {
                completion(latitude, longitude)
            }
        })
    }

    func startObservingCrewLateTime(crewID: String?, completion: @escaping (UInt) -> Void) {
        guard let crewID = crewID else { return }
        Database.database().reference().child("crew/\(crewID)").observe(.childChanged, with: { snapshot in
            if snapshot.key == "lateTime", let lateTime = snapshot.value as? UInt {
                completion(lateTime)
            }
        })
    }

    /// 내 탑승지 정보 받아오는 메서드
    func myPickUpLocation(crew: Crew) -> Point? {
        guard let myUID = KeychainItem.currentUserIdentifier else {
            return nil
        }
        if let location = crew.startingPoint, let crews = location.crews {
            for crew in crews where crew == myUID {
                return location
            }
        }
        if let location = crew.stopover1, let crews = location.crews {
            for crew in crews where crew == myUID {
                return location
            }
        }
        if let location = crew.stopover2, let crews = location.crews {
            for crew in crews where crew == myUID {
                return location
            }
        }
        if let location = crew.stopover2, let crews = location.crews {
            for crew in crews where crew == myUID {
                return location
            }
        }
        return nil
    }
}

// MARK: - SessionStartView Actions
extension FirebaseManager {

    // 따로가요 클릭 시 해당 동승자의 status decline으로 변경
    func passengerIndividualButtonTapped(crewData: Crew?) {

        guard let crewData = crewData else { return }
        guard let memberStatus = crewData.memberStatus else { return }

        for (index, member) in memberStatus.enumerated() where member.id == KeychainItem.currentUserIdentifier {
            if let crewID = crewData.id {
                let statusRef = Database.database().reference().child("crew/\(crewID)/memberStatus/\(index)/status")
                statusRef.setValue(Status.decline.rawValue) { error, _ in
                    if let error = error {
                        print("Error occured: ", error)
                    }
                }
            }
        }
    }

    // 함께가요 클릭 시 해당 동승자의 status accept로 변경
    func passengerTogetherButtonTapped(crewData: Crew?) {
        guard let crewData = crewData else { return }
        guard let memberStatus = crewData.memberStatus else { return }

        for (index, member) in memberStatus.enumerated() where member.id == KeychainItem.currentUserIdentifier {
            if let crewID = crewData.id {
                let statusRef = Database.database().reference().child("crew/\(crewID)/memberStatus/\(index)/status")

                statusRef.setValue(Status.accept.rawValue) { error, _ in
                    if let error = error {
                        print("Error occured: ", error)
                    }
                }
            }
        }
    }

    /// Crew의 sessionStatus를 변경하는 메서드
    func updateSessionStatus(to sessionStatus: Status, crew: Crew) {
        guard let crewID = crew.id else { return }
        Database.database().reference().child("crew/\(crewID)/sessionStatus").setValue(sessionStatus.rawValue)
    }

    // 따로가요 클릭 시 sessionStatus를 decline으로 변경
    func driverIndividualButtonTapped(crewData: Crew?) {
        guard let crewData = crewData else { return }
        print("DRIVER ", crewData)
        updateSessionStatus(to: .decline, crew: crewData)
    }

    // 운행해요 클릭 시 sessionStatus를 accpet으로 변경
    func driverTogetherButtonTapped(crewData: Crew?) {
        guard let crewData = crewData else { return }
        print("DRIVER ", crewData)
        updateSessionStatus(to: .accept, crew: crewData)
    }

    // 카풀 운행해요 클릭 시 sessionStatus를 sessionStart로 변경
    func carpoolStartButtonTapped(crewData: Crew?) {
        guard let crewData = crewData else { return }
        print("DRIVER ", crewData)
        updateSessionStatus(to: .sessionStart, crew: crewData)
    }

    // 탑승자 기준 본인의 Status를 감지하는 메서드
    func passengerStatus(crewData: Crew?) -> Status {
        guard let crewData = crewData else { return .waiting }
        guard let memberStatus = crewData.memberStatus else { return .waiting }

        for member in memberStatus where member.id == KeychainItem.currentUserIdentifier {
            return member.status ?? .waiting
        }
        return .waiting
    }

    func startObservingCrewData(crewID: String, completion: @escaping (Crew?) -> Void) {

        let crewRef = Database.database().reference().child("crew/\(crewID)")

        crewRef.observe(.value, with: { snapshot in
            if let crewData = snapshot.value as? [String: Any] {
                var crew = Crew(
                    id: crewData["id"] as? String ?? "",
                    name: crewData["name"] as? String ?? "",
                    captainID: crewData["captainID"] as? UserIdentifier ?? "",
                    startingPoint: self.convertDataToPoint(crewData["startingPoint"] as? [String: Any] ?? [:]),
                    destination: self.convertDataToPoint(crewData["destination"] as? [String: Any] ?? [:]),
                    inviteCode: crewData["inviteCode"] as? String ?? "",
                    repeatDay: crewData["repeatDay"] as? [Int] ?? [1, 2, 3, 4, 5],
                    sessionStatus: Status(rawValue: crewData["sessionStatus"] as? String ?? "waiting") ?? .waiting,
                    memberStatus: self.convertDataToMemberStatus(crewData["memberStatus"] as? [[String: Any]] ?? []),
                    lateTime: crewData["lateTime"] as? UInt ?? 0
                )
                // 경유지를 확인하고 설정합니다.
                if let stopover1Data = crewData["stopover1"] as? [String: Any] {
                    crew.stopover1 = self.convertDataToPoint(stopover1Data)
                }
                if let stopover2Data = crewData["stopover2"] as? [String: Any] {
                    crew.stopover2 = self.convertDataToPoint(stopover2Data)
                }
                if let stopover3Data = crewData["stopover3"] as? [String: Any] {
                    crew.stopover3 = self.convertDataToPoint(stopover3Data)
                }
                completion(crew)
            }
        })
    }
}
