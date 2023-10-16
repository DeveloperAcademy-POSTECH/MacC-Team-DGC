//
//  Point2.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/16.
//

import Foundation

struct Point2 {
    var pointId: Int?
    var pointSequence: Int?
    var pointName: String?
    var pointDetailAddress: String?
    var pointArrivalTime: Date?
    var pointLat: Double?
    var pointLng: Double?
    var boardingCrew: [String]?  // [userId]
}

struct AddressDTO {
    var pointName: String?
    var pointDetailAddress: String?
    var pointLat: Double?
    var pointLng: Double?
}
