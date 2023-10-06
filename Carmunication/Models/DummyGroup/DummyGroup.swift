//
//  DummyGroup.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/03.
//

import Foundation

struct DummyGroup {
    var groupTitle: String = "(주)좋좋소"
    var subTitle: String = "늦으면 큰일이 나요"
    var isDriver: Bool = false
    var startPoint = "출발지"
    var startPointDetailAddress = "울산광역시 남구 야음로 21"
    var endPoint = "도착지"
    var endPointDetailAddress = "경상북도 포항시 남구 지곡로 80"
    var stopoverPoint: [String: String] = ["경유지1": "경상북도 경주시", "경유지2": "경상북도 경주시"]
    var startTime = "08:30"
    var crewCount = 4
    var accumulateDistance = 224
}
