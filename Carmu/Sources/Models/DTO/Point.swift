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
