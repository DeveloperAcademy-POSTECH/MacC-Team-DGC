//
//  Point.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/03.
//

import Foundation

/**
 id: 해당 Point의 탑승 순서(출발지 0, 도착지 마지막 인덱스)
 name: 해당 지점의 이름
 detailAddress: 해당 지점의 상세주소
 pointLat: 해당 지점의 위도
 pointLng: 해당 지점의 경도
 arrivalTime: 해당 경유지에서 출발하거나 도착하는 시간
 crews: 해당 경유지에서 타는 인원들
 */
struct Point: Codable {
    var name: String
    var detailAddress: String
    var latitude: Double
    var longitude: Double
    var arrivalTime: Date
    var crews: [UserIdentifier]
}

// Point 더미 데이터
let point1 = Point(name: "출발지",
                   detailAddress: "출발지의 상세 주소",
                   latitude: 128.00,
                   longitude: 62.42,
                   arrivalTime: Date(),
                   crews: ["ted"])
let point2 = Point(name: "경유지1",
                   detailAddress: "경유지1 상세 주소",
                   latitude: 218.214,
                   longitude: 63.125,
                   arrivalTime: Date(),
                   crews: ["uni", "rei"])
let point3 = Point(name: "경유지2",
                   detailAddress: "경유지2 상세 주소",
                   latitude: 127.436,
                   longitude: 52.662,
                   arrivalTime: Date(),
                   crews: ["rei"])
let point4 = Point(name: "도착지",
                   detailAddress: "도착지 상세 주소",
                   latitude: 127.458,
                   longitude: 62.125,
                   arrivalTime: Date(),
                   crews: [])
