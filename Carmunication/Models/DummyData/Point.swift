//
//  Point.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

/**
 cf. 출발지, 경유지, 도착지 모두 "포인트"라고 본 문서에서 명명함

 point_id : 포인트 모델의 고유 번호
 point_sequence : 그룹에서 경유할 point의 순서(출발지 0) -> cf. 초기 ERD에 없음
 point_name : 포인트의 대표 이름 -> cf. 초기 ERD에 없음
 point_detail_address : 포인트의 상세주소
 point_arrival_time : 포인트에 도착하는 시간(출발지는 출발시간)
 point_lat : 포인트의 위도
 point_lng : 포인트의 경도
 boarding_crew : 그 장소에서 탑승하는 크루의 고유 id (userId)
 */
struct Point {
    var pointId: Int
    var pointSequence: Int
    var pointName: String
    var pointDetailAddress: String
    var pointArrivalTime: Date
    var pointLat: Double
    var pointLng: Double
    var boardingCrew: [String]  // [userId]

    // 시간 데이터 생성을 위한 이니셜라이저
    init(
        pointId: Int, pointSequence: Int, pointName: String, pointDetailAddress: String,
        hour: Int, minute: Int, second: Int,
        pointLat: Double, pointLng: Double, boardingCrew: [String]
    ) {
        self.pointId = pointId
        self.pointSequence = pointSequence
        self.pointName = pointName
        self.pointDetailAddress = pointDetailAddress

        // Calendar 객체를 생성하여 시간대를 설정합니다.
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")! // 시간대를 GMT로 설정합니다.

        // 시간, 분, 초에 해당하는 Date를 생성합니다.
        self.pointArrivalTime = calendar.date(bySettingHour: hour, minute: minute, second: second, of: Date())!

        self.pointLat = pointLat
        self.pointLng = pointLng
        self.boardingCrew = boardingCrew
    }
}
