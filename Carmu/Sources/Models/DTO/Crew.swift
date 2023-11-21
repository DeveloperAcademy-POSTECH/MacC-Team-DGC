//  Crew.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

/**
 id: 크루의 고유 id
 name: 크루의 이름(초기 랜덤 생성)
 captainID : 캡틴의 userID
 crews: 참여한 크루들의 userID
 points: 출발, 경유, 도착지의 Point 모델 배열
 inviteCode: 초대코드
 repeatDay: 반복요일 저장 Int 배열(월: 0 ~ 일: 6)
 sessionStatus: 당일 출발 여부
 crewStatus: 크루원의 출석 여부
 driverCoordinate: 운전자의 위치 정보(위도, 경도)
 lateTime: 운전자가
 */
struct Crew: Codable {
    var id: String?
    var name: String?
    var captainID: UserIdentifier?
    var startingPoint: Point?
    var stopover1: Point?
    var stopover2: Point?
    var stopover3: Point?
    var destination: Point?
    var inviteCode: String?
    var repeatDay: [Int]?
    var sessionStatus: Status?
    var memberStatus: [MemberStatus]?
    var driverCoordinate: Coordinate?
    var lateTime: UInt
    
    init(
        id: String? = nil,
        name: String? = nil,
        captainID: UserIdentifier? = nil,
        startingPoint: Point? = nil,
        stopover1: Point? = nil,
        stopover2: Point? = nil,
        stopover3: Point? = nil,
        destination: Point? = nil,
        inviteCode: String? = nil,
        repeatDay: [Int]? = nil,
        sessionStatus: Status? = nil,
        memberStatus: [MemberStatus]? = nil,
        driverCoordinate: Coordinate? = nil,
        lateTime: UInt = 0
    ) {
        self.id = id
        self.name = name
        self.captainID = captainID
        self.startingPoint = startingPoint
        self.stopover1 = stopover1
        self.stopover2 = stopover2
        self.stopover3 = stopover3
        self.destination = destination
        self.inviteCode = inviteCode
        self.repeatDay = repeatDay
        self.sessionStatus = sessionStatus
        self.memberStatus = memberStatus
        self.driverCoordinate = driverCoordinate
        self.lateTime = lateTime
    }
}

/**
 세션의 상태와 크루원의 상태를 구분하기 위한 enum 타입
 미응답, 승인, 거절, 세션 시작의 경우로 나누었습니다.
 */
enum Status: String, Codable {
    case waiting
    case accept
    case decline
    case sessionStart

    var statusValue: String {
        switch self {
        case .waiting: return "미응답"
        case .accept: return "참여"
        case .decline: return "불참"
        case .sessionStart: return "세션 시작"
        }
    }
}

// MARK: - Preview를 위한 더미 데이터
var dummyCrewData: Crew? = Crew(
    id: "1",
    name: "그룹 이름111",
    captainID: "ted",
    startingPoint: Point(
        name: "포항터미널",
        detailAddress: "경상북도 포항시 남구 중흥로 85",
        latitude: 36.0133,
        longitude: 129.3496,
        arrivalTime: Date(),
        crews: []
    ),
    stopover1: Point(
        name: "경유지 1번",
        detailAddress: "경유지 1번 상세 주소",
        latitude: 35.634,
        longitude: 128.523,
        arrivalTime: Date(),
        crews: ["uni"]
    ),
    stopover2: Point(
        name: "경유지 2번",
        detailAddress: "경유지 2번 상세 주소",
        latitude: 35.634,
        longitude: 128.523,
        arrivalTime: Date(),
        crews: ["rei"]
    ),
    stopover3: Point(
        name: "경유지 3번",
        detailAddress: "경유지 3번 상세 주소",
        latitude: 35.634,
        longitude: 128.523,
        arrivalTime: Date(),
        crews: ["bazzi"]
    ),
//    stopover1: nil,
//    stopover2: nil,
//    stopover3: nil,
    destination: Point(
        name: "C5",
        detailAddress: "경상북도 포항시 남구 지곡로 80",
        latitude: 36.0141,
        longitude: 129.3258,
        arrivalTime: Date(),
        crews: []
    ),
    inviteCode: "0101010",
    repeatDay: [1, 2, 3, 4, 5],
    sessionStatus: .waiting,
    memberStatus: [
        MemberStatus(id: "000", nickname: "uni", profileColor: "blue", status: .waiting, lateTime: 0),
        MemberStatus(id: "111", nickname: "rei", profileColor: "red", status: .waiting, lateTime: 0),
        MemberStatus(id: "222", nickname: "bazzi", profileColor: "red", status: .waiting, lateTime: 0)
    ],
    lateTime: 0
//    crewStatus: ["uni": .waiting, "rei": .waiting]
)

var dummyUserData: [User] = [
    User(
       id: "uni",
       deviceToken: "uniDT",
       nickname: "우니",
       profileImageColor: .aqua),
    User(
        id: "rei",
        deviceToken: "reiDT",
        nickname: "레이",
        profileImageColor: .red),
    User(
        id: "bazzi",
        deviceToken: "bazziDT",
        nickname: "배찌",
        profileImageColor: .blue),
    User(
        id: "jen",
        deviceToken: "jenDT",
        nickname: "젠",
        profileImageColor: .aquaBlue),
    User(
        id: "JellyBeen",
        deviceToken: "JellyBeenDT",
        nickname: "젤리빈",
        profileImageColor: .yellow)
]
