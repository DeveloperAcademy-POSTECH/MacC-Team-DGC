//
//  DayOfWeek.swift
//  Carmu
//
//  Created by 김동현 on 11/7/23.
//

import Foundation

enum DayOfWeek: Int {
    case mon = 0
    case tue = 1
    case wed = 2
    case thu = 3
    case fri = 4
    case sat = 5
    case sun = 6

    static let weekday: Set<DayOfWeek> = [.mon, .tue, .wed, .thu, .fri]
    static let weekend: Set<DayOfWeek> = [.sat, .sun]
    static let everyday: Set<DayOfWeek> = [.mon, .tue, .wed, .thu, .fri, .sat, .sun]

    var dayString: String {
        switch self {
        case .mon: return "월"
        case .tue: return "화"
        case .wed: return "수"
        case .thu: return "목"
        case .fri: return "금"
        case .sat: return "토"
        case .sun: return "일"
        }
    }
}

extension DayOfWeek {
    static func stringToInt(_ string: String) -> Int? {
        switch string {
        case "월": return 0
        case "화": return 1
        case "수": return 2
        case "목": return 3
        case "금": return 4
        case "토": return 5
        case "일": return 6
        default: return nil
        }
    }
}
