//
//  Coordinate.swift
//  Carmu
//
//  Created by 허준혁 on 11/20/23.
//

import Foundation

struct Coordinate: Codable {

    var latitude: Double
    var longitude: Double

    init(latitude: Double = 0.0, longitude: Double = 0.0) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
