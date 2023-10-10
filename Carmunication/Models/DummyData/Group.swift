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
 crew_list : 이 그룹에 속한 crew의 crew_id
 start_point : 출발지의 point_id
 end_point : 도착지의 point_id
 stopover_point : 경유지의 point_id를 모아둔 배열
 accumulate_distance : 이 크루가 진행한 세션의 총 누적 거리(세션이 끝날 때 마다 더해줌.) -> 여유가 된다면, captain - crew 간의 friendship에 accumulate_distance 추가해줘야 함.
 session_array : 이 크루가 진행한 세션들의 id 배열 -> cf. 초기 ERD에 반영되지 않음

 cf. is_permitted의 경우 ERD에 있으나, 수락 부분이 빠지기 때문에, 속성에서 제외함
 */
struct Group: DummyData {
    var group_id: Int
    var group_name: String
    var group_image: String
    var captain_id: Int
    var crew_list: Int
    var start_point: Int
    var end_point: Int
    var stopover_point: [Int] = []
    var accumulate_distance: Int = 0
    var session_array: [Int] = []
}
