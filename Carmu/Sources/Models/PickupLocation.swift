//
//  Location.swift
//  Carmu
//
//  Created by 허준혁 on 10/23/23.
//

import Foundation

enum PickupLocation {
    case startingPoint
    case pickupLocation1
    case pickupLocation2
    case pickupLocation3
    case destination
}

extension PickupLocation {
    var description: String {
        switch self {
        case .startingPoint:
            return "출발지"
        case .pickupLocation1:
            return "경유지1"
        case .pickupLocation2:
            return "경유지2"
        case .pickupLocation3:
            return "경유지3"
        case .destination:
            return "도착지"
        }
    }
}
