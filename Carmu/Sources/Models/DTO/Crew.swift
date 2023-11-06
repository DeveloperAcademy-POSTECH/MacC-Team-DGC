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
 repeatDay: 반복요일 저장 Int 배열(일: 0 ~ 토: 6)
 sessionStatus: 당일 출발 여부
 crewStatus: 크루원의 출석 여부
 */
struct Crew: Codable {
    var id: String
    var name: String
    var captainID: UserIdentifier
    var crews: [UserIdentifier]
    var startingPoint: Point
    var stopover1: Point?
    var stopover2: Point?
    var stopover3: Point?
    var destination: Point
    var inviteCode: String
    var repeatDay: [Int]
    var sessionStatus: Status
    var crewStatus: [UserIdentifier: Status]
}

/**
 세션의 상태와 크루원의 상태를 구분하기 위한 enum 타입
 미응답, 승인, 거절의 경우로 나누었습니다.
 */
enum Status: String, Codable {
    case waiting
    case accept
    case decline
}

// 더미 데이터
//    // 데이터가 없을 때
//    let crewData: Crew? = nil

    // 데이터가 있을 때
    let crewData: Crew? = Crew(
        id: "1",
        name: "그룹 이름111",
        captainID: "ted",
        crews: ["uni", "rei", "bazzi"],
        startingPoint: Point(
            name: "포항터미널",
            detailAddress: "경상북도 포항시 남구 중흥로 85",
            latitude: 36.0133,
            longitude: 129.3496,
            arrivalTime: Date(),
            crews: []
        ),
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
        crewStatus: ["uni": .waiting, "rei": .waiting, "bazzi": .waiting]
    )
