//
//  Session.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

/**
 여정으로 앱에서 사용되나, 편의상 Session으로 모델이름 설정

 session_id : Session 모델의 고유 id
 session_day_of_week : 세션이 열리는 요일 -> cf. 초기 ERD에 반영되지 않음
 session_start_time : 세션이 시작되는 시간
 session_end_time : 세션이 끝나는 시간
 group_id : 세션을 진행하는 그룹의 group_id
 boss_id : 세션을 진행하는 캡틴의 user_id
 stopover_point :  현재 세션에서 들를 출발, 경유, 도착지의 point 정보 -> cf. 초기 ERD에 반영되지 않음
 boss_current_lat : 캡틴의 현재 위치 위도
 boss_current_lng : 캡틴의 현재 위치 경도
 delay_time : 지연 시간
 is_finish : 세션이 끝났는지 여부
 session_distance : 세션에서 총 주행한 거리(group의 accumulate 거리와 합쳐짐)

 사용 예시)

 stopover_point의 경우, 내부에 Point를 가리키는 id가 들어있고, point 데이터로 가면 point_arrival_time이 들어있는데,
 전체 point 데이터의 array에서 특정 인덱스를 id로 데이터를 골라와서 도착 예정 시간을 추출해와야 함.
 */
struct Session: DummyData {
    var session_id: Int
    var session_day_of_week: [Int]
    var session_start_time: Date
    var session_end_time: Date
    var group_id: Int
    var boss_id: Int
    var stopover_point: [Int]
    var boss_current_lat: Double
    var boss_current_lng: Double
    var delay_time: Int
    var is_finish: Bool
    var session_distance: Int
}
