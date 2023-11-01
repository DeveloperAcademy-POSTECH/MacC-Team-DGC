//
//  Group.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

/**
groupID, groupName 등은 무조건적으로 값이 들어오지만, collectionView에서 개수를 셀 때 용이하게 하기 위해 전체를 옵셔널로 표기하였습니다.

 group_id : 그룹 모델의 고유 id
 group_name : 그룹의 이름. 이름을 꼭 설정하도록 되어 있어 옵셔널 X
 group_image : 그룹의 이미지로, SessionStartView 스토리 부분에서 사용될 이미지
 captain_id : 캡틴의 user_id. 캡틴이 방을 생성하기 때문에 옵셔널 X
 crewAndPoint : 크루원과 해당 크루원이 동승할 지점. 첫 번째는 '캡틴: 출발지', 마지막은 '캡틴: 도착지'로 지정이기 때문에 옵셔널 X
 sessionDay: 세션이 시작하는 요일이기 때문에, 옵셔널 X (현재 기본값은 월 ~금으로 지정)
 sessionList : 해당 그룹의 세션에 대한 리스트
 accumulate_distance : 이 크루가 진행한 세션의 총 누적 거리(세션이 끝날 때 마다 더해줌.)
 -> 여유가 된다면, captain - crew 간의 friendship에 accumulate_distance 추가해줘야 함.

 cf. is_permitted의 경우 ERD에 있으나, 수락 부분이 빠지기 때문에, 속성에서 제외함
 */
struct Group: Codable {
    var groupID: String?
    var groupName: String?
    var groupImage: String?
    var captainID: String?
    var sessionDay: [Int]?
    var crewAndPoint: [String: String]?    // [UserID: PointID]
    var sessionList: [String]?  // [Session]
    var accumulateDistance: Int?
}

// 데이터 확인을 위한 예시입니다.
let user1 = User(   // user1을 운전자로 가정
    id: "user1",
    deviceToken: "token1",
    nickname: "User 1",
    friends: ["user2", "user3"],
    groupList: ["1", "2"]
)
let user2 = User(
    id: "user2",
    deviceToken: "token2",
    nickname: "User 2",
    email: "user2@example.com",
    imageURL: "user2_image.jpg",
    friends: ["user1", "user3"],
    groupList: ["1", "3"]
)
let user3 = User(
    id: "user3",
    deviceToken: "token3",
    nickname: "User 3",
    email: "user3@example.com",
    imageURL: "user3_image.jpg",
    friends: ["user1", "user2"],
    groupList: ["2", "3"]
)
let user4 = User(
    id: "user4",
    deviceToken: "token4",
    nickname: "User 4",
    email: "user4@example.com",
    friends: ["user1", "user2"]
)

let point1 = Point(
    pointID: "point1",
    pointSequence: 1,
    pointName: "출발지",
    pointDetailAddress: "123 Main St",
    pointArrivalTime: Date(),
    pointLat: 37.123456,
    pointLng: -122.123456,
    boardingCrew: ["UUID": "user1"]
)
let point2 = Point(
    pointID: "point2",
    pointSequence: 2,
    pointName: "Point 2",
    pointDetailAddress: "456 Elm St",
    pointArrivalTime: Date(),
    pointLat: 37.654321,
    pointLng: -122.654321,
    boardingCrew: ["uuid": "user2", "UUID": "user3"]
)
let point3 = Point(
    pointID: "point3",
    pointSequence: 3,
    pointName: "Point 3",
    pointDetailAddress: "789 Oak St",
    pointArrivalTime: Date(),
    pointLat: 37.987654,
    pointLng: -122.987654,
    boardingCrew: ["uuid": "user3"]
)
let point4 = Point(
    pointID: "point4",
    pointSequence: 4,
    pointName: "도착지",
    pointDetailAddress: "789 Oak St",
    pointArrivalTime: Date(),
    pointLat: 37.987654,
    pointLng: -122.987654,
    boardingCrew: ["uuid": "user1"]
)

//    let groupData: [Group]? = [
//        Group(
//            groupID: "1",
//            groupName: "그룹 1",
//            groupImage: "heart",
//            captainID: "user1",
//            sessionDay: [2, 3, 4, 5, 6],
//            crewAndPoint: ["user1": "point1", "user2": "point2", "user3": "point3", "user4": "point4"],
//            sessionList: nil,
//            accumulateDistance: 1000
//        ),
//        Group(
//            groupID: "2",
//            groupName: "그룹 2",
//            groupImage: "circle.fill",
//            captainID: "2",
//            sessionDay: [2, 3, 4, 5, 6],
//            crewAndPoint: ["user2": "point2", "user3": "point3", "user4": "point4"],
//            sessionList: nil,
//            accumulateDistance: 1500
//        ),
//        Group(
//            groupID: "3",
//            groupName: "그룹 3",
//            groupImage: "square",
//            captainID: "3",
//            sessionDay: [2, 3, 4, 5, 6],
//            crewAndPoint: ["user1": "point1", "user2": "point2", "user3": "point3"],
//            sessionList: nil,
//            accumulateDistance: 2000
//        )
//    ]

// 데이터가 없을 때
 let groupData: [Group]? = nil
