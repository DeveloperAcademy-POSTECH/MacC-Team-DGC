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
 */
struct Crew: Codable {
    var id: String
    var name: String
    var captainID: UserIdentifier
    var crews: [UserIdentifier]
    var points: [Point]
    var inviteCode: String?
    var repeatDay: [Int]
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
        points: [
            Point(
                id: 0,
                name: "포항터미널",
                arrivalTime: Date(),
                crews: []
            ),
            Point(
                id: 1,
                name: "C5",
                arrivalTime: Date(),
                crews: []
            )
        ],
        repeatDay: [1, 2, 3, 4, 5]
    )
