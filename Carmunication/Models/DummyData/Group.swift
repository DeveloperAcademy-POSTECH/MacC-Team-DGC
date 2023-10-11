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
    var groupId: String
    var groupName: String
    var groupImage: String?
    var captainId: String
    var crewList: [String]  // [userId]
    var sessionDay: [Int]   // 그룹이 시작되는 요일
    var points: [Point]
    var accumulateDistance: Int = 0
}
