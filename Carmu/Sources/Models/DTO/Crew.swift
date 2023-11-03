//
//  Crew.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

struct Crew: Codable {
    var id: String
    var name: String
    var captainID: UserIdentifier
    var crews: [UserIdentifier]
}
