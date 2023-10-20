//
//  SelectAddressModel.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/14.
//

import Foundation
import CoreLocation

struct SelectAddressModel {
    var pointName: String?
    var buildingName: String?
    var detailAddress: String?
    var coordinate: CLLocationCoordinate2D?
}
