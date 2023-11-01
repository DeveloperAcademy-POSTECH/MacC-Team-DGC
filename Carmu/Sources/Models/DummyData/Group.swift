//
//  Group.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

/**
id, name 등은 무조건적으로 값이 들어오지만, collectionView에서 개수를 셀 때 용이하게 하기 위해 전체를 옵셔널로 표기하였습니다.

 id : 그룹 모델의 고유 id
 name : 그룹의 이름. 이름을 꼭 설정하도록 되어 있어 옵셔널 X
 image : 그룹의 이미지로, SessionStartView 스토리 부분에서 사용될 이미지
 id : 캡틴의 user_id. 캡틴이 방을 생성하기 때문에 옵셔널 X
 crewAndPoint : 크루원과 해당 크루원이 동승할 지점. 첫 번째는 '캡틴: 출발지', 마지막은 '캡틴: 도착지'로 지정이기 때문에 옵셔널 X
 sessionDay: 세션이 시작하는 요일이기 때문에, 옵셔널 X (현재 기본값은 월 ~금으로 지정)
 accumulate_distance : 이 크루가 진행한 세션의 총 누적 거리(세션이 끝날 때 마다 더해줌.)
 -> 여유가 된다면, captain - crew 간의 friendship에 accumulate_distance 추가해줘야 함.

 cf. is_permitted의 경우 ERD에 있으나, 수락 부분이 빠지기 때문에, 속성에서 제외함
 */
struct Group: Codable {
    var id: String?
    var name: String?
    var image: String?
    var captainID: String?
    var sessionDay: [Int]?
    var crewAndPoint: [String: String]?    // [UserID: PointID]
    var accumulateDistance: Int?
}
