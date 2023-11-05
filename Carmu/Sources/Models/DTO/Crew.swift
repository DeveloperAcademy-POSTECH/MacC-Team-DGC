//  Crew.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/10.
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
struct Crew: Codable {
    var id: String
    var name: String
    var captainID: UserIdentifier
    var crews: [UserIdentifier]
    var points: [Point]
    var sessionStatus: Bool
    var crewStatus: [UserIdentifier: Bool]
}

// 더미 데이터
//    // 데이터가 없을 때
//    let crewData: Crew? = nil

// 데이터가 있을 때
let crewData: Crew? = Crew(id: "1",
                           name: "김테드",
                           captainID: "ted",
                           crews: ["uni", "rei", "bazzi"],
                           points: [point1, point2, point3, point4],
                           sessionStatus: true,
                           crewStatus: ["uni": false, "rei": false, "bazzi": false])
