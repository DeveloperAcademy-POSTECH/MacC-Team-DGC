//
//  Point.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

/**
 cf. 출발지, 경유지, 도착지 모두 "포인트"라고 본 문서에서 명명함
 group과 마찬가지로, collectionView에서 개수를 셀 때 용이하게 하기 위해 전체를 옵셔널로 표기하였습니다.

 point_id : 포인트 모델의 고유 번호
 point_sequence : 그룹에서 경유할 point의 순서(출발지 0) -> cf. 초기 ERD에 없음
 point_name : 포인트의 대표 이름 -> cf. 초기 ERD에 없음
 point_detail_address : 포인트의 상세주소
 point_arrival_time : 포인트에 도착하는 시간(출발지는 출발시간)
 point_lat : 포인트의 위도
 point_lng : 포인트의 경도
 boarding_crew : 그 장소에서 탑승하는 크루원의 고유 id (userId) -> User로 변경해야 할지도,,?
 */

struct Point {
    var pointID: String?
    var pointSequence: Int?
    var pointName: String?
    var pointDetailAddress: String?
    var pointArrivalTime: Date?
    var pointLat: Double?
    var pointLng: Double?
    var boardingCrew: [String]? // TODO: - [User]로 변경해야 함

    // pointArrivalTime을 "HH:mm" 형식의 문자열로 반환하는 메서드
    func formattedArrivalTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: pointArrivalTime ?? Date())
    }
}

struct AddressDTO {
    var pointName: String?
    var pointDetailAddress: String?
    var pointLat: Double?
    var pointLng: Double?
}
