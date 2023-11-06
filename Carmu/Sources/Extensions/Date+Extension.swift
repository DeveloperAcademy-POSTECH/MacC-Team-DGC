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
}
