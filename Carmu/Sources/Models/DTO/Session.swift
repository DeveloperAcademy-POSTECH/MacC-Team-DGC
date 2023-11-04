//
//  Session.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/03.
//

import Foundation

/**
 id: 해당 세션의 고유 번호
 name: 캡틴의 닉네임
 captainID: 캡틴의 userID
 points: 출발지, 경유지, 도착지 등
 sessionStatus: 당일 출발 여부
 crewStatus: 크루원의 출석 여부
 */
struct Session: Codable {
    var id: String
    var name: String
    var captainID: UserIdentifier
    var points: [Point]
    var sessionStatus: Bool
    var crewStatus: [UserIdentifier: Bool]

    // 추가적으로 캡틴의 현재 위치 설정
}
