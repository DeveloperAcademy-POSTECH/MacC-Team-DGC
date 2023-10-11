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

// 더미 데이터

// let groupData: [GroupData]? = [
//    GroupData(image: UIImage(systemName: "heart"), groupName: "group1", start: "양덕", end: "C5",
//              startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
//    GroupData(image: UIImage(systemName: "circle"), groupName: "group2", start: "포항", end: "부산",
//              startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
//    GroupData(image: UIImage(systemName: "heart.fill"), groupName: "group3", start: "인천", end: "서울",
//              startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
//    GroupData(image: UIImage(systemName: "circle.fill"), groupName: "group4", start: "부평", end: "일산",
//              startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
//    GroupData(image: UIImage(systemName: "square"), groupName: "group5", start: "서울", end: "포항",
//              startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4)
// ]

// 데이터가 없을 때
let groupData: [GroupData]? = nil
