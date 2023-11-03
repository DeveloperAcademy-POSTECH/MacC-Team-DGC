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
