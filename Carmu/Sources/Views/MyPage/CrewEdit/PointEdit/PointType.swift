//
//  PointType.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/16.
//

enum PointType: String {
    case start = "출발지"
    case stopover1 = "경유지1"
    case stopover2 = "경유지2"
    case stopover3 = "경유지3"
    case destination = "도착지"

    // stopoverPoints 배열의 인덱스 값으로 사용하기 위한 계산 프로퍼티
    var stopoverIdx: Int {
        switch self {
        case .stopover1:
            return 0
        case .stopover2:
            return 1
        case .stopover3:
            return 2
        default:
            return -1
        }
    }
}
