//
//  AddressDTO.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import Foundation

/**
  상세위치 설정 -> 출발, 도착, 경유지 설정 화면으로 데이터 넘기는 모델
 */
struct AddressDTO {
    var pointName: String?
    var pointDetailAddress: String?
    var pointLat: Double?
    var pointLng: Double?
}
