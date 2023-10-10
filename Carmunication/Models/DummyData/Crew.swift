//
//  Crew.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

/**
 ERD와 상이하니, 참고해야 함.

 crew_id: 그룹에서 크루를 인식하는 고유 id
 crew_list : 그룹(크루)에 등록된 유저 id 배열
 crew_status : 당일 여정에 참여하겠다는 의사를 담은 status. 여정 종료시 모두 false로 초기화 되어야 함.
 */
struct Crew: DummyData {
    var crew_id: Int
    var crew_list: [Int]
    var crew_status: [Int: Bool]
}
