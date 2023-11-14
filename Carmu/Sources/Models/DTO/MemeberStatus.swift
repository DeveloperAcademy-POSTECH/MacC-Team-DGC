//
//  CrewStatus.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/14.
//

import Foundation

struct MemeberStatus: Codable {

    var id: UserIdentifier?
    var deviceToken: String?
    var nickname: String?
    var profileColor: String?
    var status: Status?
}
