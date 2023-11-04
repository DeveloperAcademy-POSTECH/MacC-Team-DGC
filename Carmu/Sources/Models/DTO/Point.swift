//
//  Point.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/03.
//

import Foundation

/**
 id: 해당 Point의 고유 번호
 name: 해당 지점의 이름
 arrivalTime: 해당 경유지에서 출발하거나 도착하는 시간
 crews: 해당 경유지에서 타는 인원들
 */
struct Point: Codable {
    var id: String
    var name: String
    var arrivalTime: Date
    var crews: [UserIdentifier]
}

// Point 더미 데이터
let point1 = Point(id: "1", name: "출발지", arrivalTime: Date(), crews: ["ted"])
let point2 = Point(id: "2", name: "경유지1", arrivalTime: Date(), crews: ["uni", "rei"])
let point3 = Point(id: "3", name: "경유지2", arrivalTime: Date(), crews: ["rei"])
let point4 = Point(id: "4", name: "도착지", arrivalTime: Date(), crews: [])
