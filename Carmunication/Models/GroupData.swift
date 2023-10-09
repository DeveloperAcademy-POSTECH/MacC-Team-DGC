//
//  GroupData.swift
//  Carmunication
//
//  Created by 김태형 on 2023/09/28.
//

import Foundation
import UIKit

// TODO: - 데이터 구축되면 변수명 변경.
struct GroupData {
    var image: UIImage?
    var groupName: String?
    var start: String?   // 출발지
    var end: String?     // 도착지
    var startTime: String?   // 출발 시간
    var endTime: String?     // 도착 시간
    var date: String?        // 타는 요일
    var total: Int?          // 총 인원
}
