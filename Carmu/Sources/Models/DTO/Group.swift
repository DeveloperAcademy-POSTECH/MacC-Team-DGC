//
//  Group.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

struct Group: Codable {
    var id: String
    var name: String
    var captainID: UserIdentifier
    var crews: [UserIdentifier]
}

/// 더미 데이터
//    // 데이터가 없을 때
//    let groupData: Group? = nil

    // 데이터가 있을 때
    let groupData: Group? = Group(id: "1", name: "aa", captainID: "ted", crews: ["uni", "rei", "bazzi"])
