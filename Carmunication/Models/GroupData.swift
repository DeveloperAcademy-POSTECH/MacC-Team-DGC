//
//  GroupData.swift
//  Carmunication
//
//  Created by 김태형 on 2023/09/28.
//

import Foundation
import UIKit

// TODO: - 데이터 구축되면 변수명 변경.
struct GroupData {
    var image: UIImage?
    var groupName: String?
    var start: String?   // 출발지
    var end: String?     // 도착지
    var startTime: String?   // 출발 시간
    var endTime: String?     // 도착 시간
    var date: String?        // 타는 요일
    var total: Int?          // 총 인원
}

let group1Point: [Point] = [
    Point(
        pointId: 0, pointSequence: 0, pointName: "출발지", pointDetailAddress: "출발지 주소",
        hour: 8, minute: 0, second: 0, pointLat: 12.21, pointLng: 124.521,
        boardingCrew: ["1", "2", "3", "4"]
    ),
    Point(
        pointId: 1, pointSequence: 1, pointName: "경유지 1", pointDetailAddress: "경유지 1 주소",
        hour: 8, minute: 40, second: 0, pointLat: 235.235, pointLng: 12.412,
        boardingCrew: ["1", "2", "3", "4"]
    ),
    Point(
        pointId: 2, pointSequence: 2, pointName: "도착지", pointDetailAddress: "도착지 주소",
        hour: 9, minute: 0, second: 0, pointLat: 124.12, pointLng: 53.23,
        boardingCrew: ["1", "2", "3", "4"]
    )
]

let groupData: [Group]? = [
    Group(groupId: "1", groupName: "그룹 1", captainId: "1",
          crewList: ["2", "3", "4"], sessionDay: [2, 3, 4, 5, 6], points: group1Point
         ),
    Group(groupId: "1", groupName: "그룹 1", captainId: "1",
          crewList: ["2", "3", "4"], sessionDay: [2, 3, 4, 5, 6], points: group1Point
         ),
    Group(groupId: "1", groupName: "그룹 1", captainId: "1",
          crewList: ["2", "3", "4"], sessionDay: [2, 3, 4, 5, 6], points: group1Point
         )
]

// 데이터가 없을 때
//let groupData: [Group]? = nil
