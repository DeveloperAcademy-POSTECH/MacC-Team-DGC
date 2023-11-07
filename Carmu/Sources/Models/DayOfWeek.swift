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
