//
//  SelectAddressModel.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/14.
//

import Foundation
import CoreLocation

/**
 주소 검색 -> 상세 위치 설정으로 데이터 넘기는 DTO
 */
struct SelectAddressDTO {
    var pointName: String?
    var buildingName: String?
    var detailAddress: String?
    var coordinate: CLLocationCoordinate2D?
}


