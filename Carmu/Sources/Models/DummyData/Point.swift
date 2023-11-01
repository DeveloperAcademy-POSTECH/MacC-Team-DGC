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

 id : 포인트 모델의 고유 번호
 sequence : 그룹에서 경유할 point의 순서(출발지 0) -> cf. 초기 ERD에 없음
 name : 포인트의 대표 이름 -> cf. 초기 ERD에 없음
 address : 포인트의 상세주소
 arrivalTime : 포인트에 도착하는 시간(출발지는 출발시간)
 latitude : 포인트의 위도
 longitude : 포인트의 경도
 boardingCrew : 그 장소에서 탑승하는 크루원의 고유 id (userId) -> User로 변경해야 할지도,,?
 */

struct Point: Codable {
    var id: String?
    var sequence: Int?
    var name: String?
    var address: String?
    var arrivalTime: Date?
    var latitude: Double?
    var longitude: Double?
    var boardingCrew: [String: String]? // [UserID : Nickname]

    // arrivalTime을 "HH:mm" 형식의 문자열로 반환하는 메서드
    func formattedArrivalTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: arrivalTime ?? Date())
    }
}
