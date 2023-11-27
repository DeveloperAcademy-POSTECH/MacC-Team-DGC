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
    func readUser(databasePath: DatabaseReference) async throws -> User? {
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
            let user = try await readUser(databasePath: databasePath)
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
        updateMemberNicknameInCrew(nickname: newNickname)
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
        updateMemberProfileImageColorInCrew(profileImageColor: imageColor)
    }
}

// MARK: - 크루 관련 파이어베이스 메서드
extension FirebaseManager {

    /**
    새로운 Crew 추가
     - 호출되는 곳
        - FinalConfirmViewController
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
        Task {
            try await setCrewToUser(captainID, key)
        }

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
     Crew를 수정된 내용으로 업데이트
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
     Crew의 name(크루명) 업데이트
     - 호출되는 곳
        - CrewInfoCheckViewController
     */
    func updateCrewName(crewID: String, newCrewName: String) {
        let databaseRef = Database.database().reference().child("crew/\(crewID)/name")
        databaseRef.setValue(newCrewName)
    }

    /**
     크루 만들기에서 추가된 탑승자들의 User/crewList에 crewID를 추가하는 메서드
     - 호출되는 곳
        - BoardingPointSelectViewController
     */
    func setCrewToUser(_ userID: String, _ crewID: String) async throws {
        let databaseRef = Database.database().reference().child("users/\(userID)")
        let snapshot = try await databaseRef.getData()
        if var userData = snapshot.value as? [String: Any] {
            var crewList = userData["crewList"] as? [String] ?? []
            crewList.append(crewID)
            userData["crewList"] = crewList
            try await databaseRef.setValue(userData)
//            databaseRef.setValue(userData) { error, _ in
//                if let error = error {
//                    print("Error updating crewList for \(userID): \(error.localizedDescription)")
//                } else {
//                    print("CrewList updated successfully for \(userID).")
//                }
//            }
        } else {
            print("Data does not exist for \(userID)")
        }
    }

    /**
     크루 만들기에서 추가된 크루의 crews, memberStatus에 user의 값을 집어넣는 메서드
     - 호출되는 곳
        - BoardingPointSelectViewController
     */
    func setUserToCrew(_ userID: String, _ crewID: String) async throws {
        let databaseRef = Database.database().reference().child("crew/\(crewID)")
        guard let databasePath = User.databasePathWithUID else { return }
        let user = try await readUser(databasePath: databasePath)
        guard let user = user else { return }

        // 크루 데이터에서 필요한 값을 가져와서 newMemberStatus 객체에 설정
        let newMemberStatus = MemberStatus(
            id: userID,
            deviceToken: user.deviceToken,
            nickname: user.nickname,
            profileColor: user.profileImageColor.rawValue,
            status: .waiting,
            lateTime: 0
        )

        // 데이터베이스에서 크루 정보를 가져온 후 업데이트
        let snapshot = try await databaseRef.getData()
        guard let snapshotValue = snapshot.value as? [String: Any] else { return }
        let jsonData = try JSONSerialization.data(withJSONObject: snapshotValue)
        var crewData = try JSONDecoder().decode(Crew.self, from: jsonData)
        if var memberStatus = crewData.memberStatus {
            // memberStatus가 있으면 추가
            memberStatus.append(newMemberStatus)
            crewData.memberStatus = memberStatus
            updateCrew(crewID: crewID, newCrewData: crewData)
        } else {
            // memberStatus가 없으면 생성
            let newMemberStatusArr: [MemberStatus] = [newMemberStatus]
            let memberStatusData = try JSONEncoder().encode(newMemberStatusArr)
            let jsonData = try JSONSerialization.jsonObject(with: memberStatusData)
            try await databaseRef.child("memberStatus").setValue(jsonData)
        }
    }

    /**
     크루 만들기에서 추가된 크루 특정 Point의 crews에 userID 값을 집어넣는 메서드
     - 호출되는 곳
        - BoardingPointSelectViewController
     */
    func setUserToPoint(_ userID: String, _ crewID: String, _ point: String) async throws {
        let databaseRef = Database.database().reference().child("crew/\(crewID)/\(point)")
        // 데이터베이스에서 해당 포인트의 크루 정보를 가져온 후 업데이트
        let snapshot = try await databaseRef.getData()
        guard var pointData = snapshot.value as? [String: Any] else { return }
        if var crews = pointData["crews"] as? [String] {
            // crews 배열에 userID 추가
            crews.append(userID)
            pointData["crews"] = crews
        } else {
            // crews 배열이 없으면 새로운 배열 생성 후 userID 추가
            pointData["crews"] = [userID]
        }

        // 업데이트된 pointData를 다시 Firebase에 저장
        try await databaseRef.setValue(pointData)
    }

    /**
     DB에서 유저의 크루 id를 불러오는 메서드
     - 배열 형태지만 유저의 크루는 무조건 1개이기 때문에 first로 첫 번째 원소만 사용
     */
    func readUserCrewID() async throws -> String? {
        guard let databasePath = User.databasePathWithUID else { return nil }
        do {
            let snapshot = try await databasePath.child("crewList").getData()
            guard let crewList = snapshot.value as? [String] else { return nil }
            return crewList.first ?? nil
        } catch {
            throw error
        }
    }

    /**
     크루ID로 크루 데이터 불러오기 (getData)
     - 호출되는곳
        - SessionStartViewController
     */
    func getCrewData(crewID: String) async throws -> Crew? {
        let crewRef = Database.database().reference().child("crew/\(crewID)")
        print("crewRef: \(crewRef)")
        do {
            let snapshot = try await crewRef.getData()
            guard let snapshotValue = snapshot.value as? [String: Any] else { return nil }
            print("snapshotValue: \(snapshotValue)")
            let jsonData = try JSONSerialization.data(withJSONObject: snapshotValue)
            print("jsonData: \(jsonData)")
            let crewData = try JSONDecoder().decode(Crew.self, from: jsonData)
            print("crewData ---> \(crewData)")
            return crewData
        } catch {
            print("ERROR, \(error.localizedDescription)")
            throw error
        }
    }

    /**
     크루ID로 크루 데이터 불러오기 (observeSingleEvent)
     - 호출되는 곳
        - MyPageViewController
        - CrewInfoCheckViewController
     */
    func observeCrewDataSingle(crewID: String, completion: @escaping (Crew) -> Void) {
        let crewRef = Database.database().reference().child("crew/\(crewID)")
        print("crewRef: \(crewRef)")
        crewRef.observeSingleEvent(of: .value) { snapshot in
            do {
                if let snapshotValue = snapshot.value as? [String: Any] {
                    let jsonData = try JSONSerialization.data(withJSONObject: snapshotValue)
                    let crewData = try JSONDecoder().decode(Crew.self, from: jsonData)
                    completion(crewData)
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }

    /**
     (동승자가 크루를 나갈 경우) 크루에서 동승자의 정보를 삭제한 뒤 업데이트
     - memberStatus에서 동승자 정보를 제거
     - startingPoint, stopover1, stopover2, stopover3 중 동승자의 정보가 있는 곳을 삭제
     */
    func deletePassengerInfoFromCrew() async throws {
        guard let crewID = try await readUserCrewID() else { return }
        guard var crewData = try await getCrewData(crewID: crewID) else { return }

        var newPoints = [Point?]()
        // 해당 동승자의 memberStatus 삭제
        let newMemberStatus = crewData.memberStatus?.filter { memberStatus in
            memberStatus.id != KeychainItem.currentUserIdentifier
        }
        // 해당 동승자가 있는 point에서 동승자 정보 삭제
        var pointArray = [
            crewData.startingPoint,
            crewData.stopover1,
            crewData.stopover2,
            crewData.stopover3
        ]
        for idx in 0..<pointArray.count {
            if var crews = pointArray[idx]?.crews {
                for crewIdx in 0..<crews.count {
                    if crews[crewIdx] == KeychainItem.currentUserIdentifier {
                        crews.remove(at: crewIdx)
                        pointArray[idx]?.crews = crews
                    }
                }
            }
        }
        newPoints = pointArray

        crewData.memberStatus = newMemberStatus
        crewData.startingPoint = newPoints[0]
        crewData.stopover1 = newPoints[1]
        crewData.stopover2 = newPoints[2]
        crewData.stopover3 = newPoints[3]
        updateCrew(crewID: crewID, newCrewData: crewData)
        print("셔틀에서 동승자 정보가 삭제되었습니다!!")

        guard let uid = KeychainItem.currentUserIdentifier else { return }
        try await deleteCrewInfoFromUser(uid: uid)
        print("유저의 crewList 정보가 삭제되었습니다!!")
    }

    /**
     (운전자가 셔틀을 나갈 경우) 운전자와 동승자들의 데이터에서 셔틀 정보를 삭제하고, 셔틀도 삭제해준다.
     - 크루의 탑승자들의 유저 정보에서 셔틀 정보(crewList)를 삭제
     - 셔틀 삭제
     - 운전자의 유저 정보에서 셔틀 정보(crewList) 삭제
     */
    func deleteCrewByDriver() async throws {
        guard let crewID = try await readUserCrewID() else { return }
        guard let crewData = try await getCrewData(crewID: crewID) else { return }
        var passengerList = [UserIdentifier]()
        // 동승자들의 uid 배열 불러오기
        if let memberStatus = crewData.memberStatus {
            for member in memberStatus {
                if let passengerID = member.id {
                    passengerList.append(passengerID)
                }
            }
        }
        do {
            // 동승자들의 크루 정보(crewList) 삭제
            for passengerID in passengerList {
                try await deleteCrewInfoFromUser(uid: passengerID)
                print("동승자의 crewList 정보 삭제")
            }
            // 크루 삭제
            try await deleteCrew(crewID: crewID)
            print("셔틀이 삭제되었습니다")
            // 운전자의 크루 정보(crewList) 삭제
            if let driverID = KeychainItem.currentUserIdentifier {
                try await deleteCrewInfoFromUser(uid: driverID)
                print("운전자의 crewList 정보 삭제")
            }
        } catch {
            print("셔틀 삭제 중 오류가 발생했습니다.")
            throw error
        }
    }

    /**
     유저의 정보에서 셔틀 정보(crewList)를 삭제
     */
    func deleteCrewInfoFromUser(uid: String) async throws {
        let userRef = Database.database().reference().child("users/\(uid)")
        try await userRef.child("crewList").setValue(nil)
    }

    /**
     크루ID에 해댱하는 셔틀 정보를 삭제
     */
    func deleteCrew(crewID: String) async throws {
        let crewRef = Database.database().reference().child("crew/\(crewID)")
        try await crewRef.setValue(nil)
    }

    /// 내가 운전자인지 확인하는 메서드
    func isDriver(crewData: Crew?) -> Bool {
        return KeychainItem.currentUserIdentifier == crewData?.captainID
    }

    /**
     초대코드로 크루를 검색
     */
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

    func resetSessionData(crew: Crew) {
        guard let crewID = crew.id else { return }
        let crewReference = Database.database().reference().child("crew/\(crewID)")
        crewReference.child("lateTime").setValue(0)
        guard let memberStatus = crew.memberStatus else { return }
        for index in memberStatus.indices {
            crewReference.child("memberStatus/\(index)/lateTime").setValue(0)
            crewReference.child("memberStatus/\(index)/status").setValue(Status.waiting.rawValue)
        }
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

    func startObservingSessionStatus(crewID: String?, completion: @escaping (Status) -> Void) {
        guard let crewID = crewID else { return }
        Database.database().reference().child("crew/\(crewID)").observe(.childChanged, with: { snapshot in
            if snapshot.key == "sessionStatus", let sessionStatus = Status(rawValue: snapshot.value as? String ?? "") {
                completion(sessionStatus)
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

    /// 나(키체인에 등록된 UserIdenfier)의 MemberStatus를 변경해주는 메서드
    func updateMemberStatus(crewData: Crew?, status: Status) {
        guard let crewData = crewData,
              let crewID = crewData.id,
              let memberStatus = crewData.memberStatus else {
            return
        }

        for (index, member) in memberStatus.enumerated() where member.id == KeychainItem.currentUserIdentifier {
            Database.database().reference().child("crew/\(crewID)/memberStatus/\(index)/status").setValue(status.rawValue)
        }
    }

    // 따로가요 클릭 시 해당 동승자의 status decline으로 변경
    func passengerIndividualButtonTapped(crewData: Crew?) {
        updateMemberStatus(crewData: crewData, status: .decline)
    }

    // 함께가요 클릭 시 해당 동승자의 status accept로 변경
    func passengerTogetherButtonTapped(crewData: Crew?) {
        updateMemberStatus(crewData: crewData, status: .accept)
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

    func endSession(crew: Crew?) {
        guard let crew = crew else { return }
        updateSessionStatus(to: .waiting, crew: crew)
        resetSessionData(crew: crew)
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

    func isAnyMemberAccepted(crewData: Crew) -> Bool {
        guard let crewMember = crewData.memberStatus else { return false }
        return crewMember.contains { $0.status == .accept }
    }
}

// MARK: - AppDelegate 관련 메서드
extension FirebaseManager {

    // users의 디바이스 토큰값 변경
    func updateDeviceTokenInUser(newToken: String) {
        guard let databasePath = User.databasePathWithUID else { return }
        databasePath.child("deviceToken").setValue(newToken as NSString)
    }

    // crews의 디바이스 토큰값 변경
    func updateDeviceTokenInCrews(newToken: String) {
        Task {
            guard let crewID = try await readUserCrewID() else { return }
            guard let crewData = try await getCrewData(crewID: crewID) else { return }

            if let memberStatus = crewData.memberStatus {
                for (index, member) in memberStatus.enumerated() {
                    if member.id == KeychainItem.currentUserIdentifier {
                        try await Database.database().reference().child("crew/\(crewID)/memberStatus/\(index)/deviceToken") .setValue(newToken)
                        break
                    }
                }
            }
        }
    }

    private func updateMemberNicknameInCrew(nickname: String) {
        Task {
            guard let crewID = try await readUserCrewID(),
                  let crewData = try await getCrewData(crewID: crewID),
                  let memberStatus = crewData.memberStatus else { return }

            for (index, member) in memberStatus.enumerated() where member.id == KeychainItem.currentUserIdentifier {
                try await Database.database().reference().child("crew/\(crewID)/memberStatus/\(index)/nickname").setValue(nickname)
            }
        }
    }

    private func updateMemberProfileImageColorInCrew(profileImageColor: ProfileImageColor) {
        Task {
            guard let crewID = try await readUserCrewID(),
                  let crewData = try await getCrewData(crewID: crewID),
                  let memberStatus = crewData.memberStatus else { return }

            for (index, member) in memberStatus.enumerated() where member.id == KeychainItem.currentUserIdentifier {
                try await Database.database().reference().child("crew/\(crewID)/memberStatus/\(index)/profileImageColor").setValue(profileImageColor.rawValue)
            }
        }
    }
}
