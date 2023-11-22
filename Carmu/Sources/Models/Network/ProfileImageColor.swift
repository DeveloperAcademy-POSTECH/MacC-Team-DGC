//
//  ProfileImageColor.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/02.
//

import Foundation

/**
 유저의 프로필 이미지 색을 구분하기 위한 enum 타입
 👉 피그마 프로토타입의 프로필 설정 화면 기준으로 좌상단→우하단 순서대로 색에 맞게 이름을 지정했습니다.
 */
enum ProfileImageColor: String, CaseIterable, Codable {
    case blue
    case aqua
    case red
    case yellow
    case aquaBlue
    case redBlue
    case purpleBlue
    case orangeBlue
    case green
    case navy
    case darkNavy
    case gray
}
