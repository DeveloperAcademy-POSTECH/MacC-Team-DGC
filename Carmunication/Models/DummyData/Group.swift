//
//  Group.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

/**
 앱에서는 그룹을 "크루"라고 명하지만, 하위 Crew 모델로 인해 Group으로 명명함
 이 모델은 Crew, Point,

 group_id : 그룹 모델의 고유 id
 group_name : 그룹의 이름
 group_image : 그룹의 이미지(1차 스프린트에는 들어가지 않음. 기본 데이터로 들어갈 예정)
 captain_id : 캡틴의 user_id
 crew_list : 이 그룹에 속한 crew원의 userId
 points : Point 모델에서 각각의 장소에 대한 정보를 불러옴
 accumulate_distance : 이 크루가 진행한 세션의 총 누적 거리(세션이 끝날 때 마다 더해줌.)
 -> 여유가 된다면, captain - crew 간의 friendship에 accumulate_distance 추가해줘야 함.

 cf. is_permitted의 경우 ERD에 있으나, 수락 부분이 빠지기 때문에, 속성에서 제외함
 */
struct Group {
    var groupId: String?
    var groupName: String?
    var groupImage: String?
    var captainId: String?
    var crewList: [String]?  // [userId]
    var sessionDay: [Int]?   // 그룹이 시작되는 요일
    var points: [Point]?
    var accumulateDistance: Int?
}

// 데이터 확인을 위한 예시입니다.
let group1Point: [Point] = [
    Point(
        pointID: 1,
        pointSequence: 0,
        pointName: "C5",
        pointDetailAddress: "C5 주소",
        pointArrivalTime: Date(),
        pointLat: 235.15,
        pointLng: 236236.2354,
        boardingCrew: nil
    ),
    Point(
        pointID: 2,
        pointSequence: 1,
        pointName: "경유지 1",
        pointDetailAddress: "경유지 1 주소",
        pointArrivalTime: DateComponents(hour: 8, minute: 0).date,
        pointLat: 235.235,
        pointLng: 12.412,
        boardingCrew: ["1", "2", "3", "4"]
    ),
    Point(
        pointID: 3,
        pointSequence: 2,
        pointName: "유강리 테드 집",
        pointDetailAddress: "도착지 주소",
        pointArrivalTime: Date(),
        pointLat: 124.12,
        pointLng: 53.23,
        boardingCrew: ["1", "2", "3", "4"]
    )
]

let group2Point: [Point] = [
    Point(
        pointID: 0,
        pointSequence: 0,
        pointName: "지곡회관",
        pointDetailAddress: "출발지 주소",
        pointArrivalTime: Date(),
        pointLat: 12.21,
        pointLng: 124.521,
        boardingCrew: ["1", "2", "3", "4"]
    ),
    Point(
        pointID: 1,
        pointSequence: 1,
        pointName: "경유지 2",
        pointDetailAddress: "경유지 1 주소",
        pointArrivalTime: Date(),
        pointLat: 235.235,
        pointLng: 12.412,
        boardingCrew: ["1", "2", "3", "4"]
    ),
    Point(
        pointID: 2,
        pointSequence: 2,
        pointName: "형산강",
        pointDetailAddress: "도착지 주소",
        pointArrivalTime: Date(),
        pointLat: 124.12,
        pointLng: 53.23,
        boardingCrew: ["1", "2", "3", "4"]
    )
]

let group3Point: [Point] = [
    Point(
        pointID: 0,
        pointSequence: 0,
        pointName: "도서관",
        pointDetailAddress: "출발지 주소",
        pointArrivalTime: Date(),
        pointLat: 12.21,
        pointLng: 124.521,
        boardingCrew: ["1", "2", "3", "4"]
    ),
    Point(
        pointID: 1,
        pointSequence: 1,
        pointName: "경유지 1",
        pointDetailAddress: "경유지 1 주소",
        pointArrivalTime: Date(),
        pointLat: 235.235,
        pointLng: 12.412,
        boardingCrew: ["1", "2", "3", "4"]
    ),
    Point(
        pointID: 2,
        pointSequence: 2,
        pointName: "영일대 해수욕장",
        pointDetailAddress: "도착지 주소",
        pointArrivalTime: Date(),
        pointLat: 124.12,
        pointLng: 53.23,
        boardingCrew: ["1", "2", "3", "4"]
    )
]

let groupData: [Group]? = [
    Group(
        groupId: "1",
        groupName: "그룹 1",
        groupImage: "heart",
        captainId: "1",
        crewList: ["2", "3"],
        sessionDay: [2, 3, 4, 5, 6],
        points: group1Point
    ),
    Group(
        groupId: "2",
        groupName: "그룹 2",
        groupImage: "circle.fill",
        captainId: "2",
        crewList: ["2", "3", "4"],
        sessionDay: [2, 3, 4, 5, 6],
        points: group2Point
    ),
    Group(
        groupId: "3",
        groupName: "그룹 3",
        groupImage: "square",
        captainId: "3",
        crewList: ["2", "3", "4", "5"],
        sessionDay: [2, 3, 4, 5, 6],
        points: group3Point
    )
]

// 데이터가 없을 때
// let groupData: [Group]? = nil
