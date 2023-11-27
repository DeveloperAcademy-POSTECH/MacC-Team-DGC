//
//  Date+Extension.swift
//  Carmu
//
//  Created by 김태형 on 2023/10/10.
//

import UIKit

extension Date {

    /**
     Date -> String으로 변환.
     dateFormat으로 출력 형식을 지정할 수 있음. ex("aa hh:mm")
     */
    static func formattedDate(from date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }

    /**
     String -> Date로 변환.
     dateFormat을 현재 표현된 형식으로 지정해 주어야 함. ex("aa hh:mm")
     */
    static func formattedDate(string: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.date(from: string)
    }

    /**
     Date -> String (HH:mm 형태)
     */
    var toString24HourClock: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }

    /**
     요일을 반환
     ex) "월", "화", "수", "목", "금", "토", "일"
     */
    var toDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = .autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
}
