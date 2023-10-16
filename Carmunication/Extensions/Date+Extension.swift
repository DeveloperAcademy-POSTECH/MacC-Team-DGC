//
//  Date+Extension.swift
//  Carmunication
//
//  Created by 김태형 on 2023/10/10.
//

import UIKit

extension Date {

    /**
     날짜 형식을 "2023.10.10 월요일"과 같은 형식으로 출력해주는 메서드입니다.

     ex)
     let customDate = Date()  // 원하는 날짜로 대체하십시오
     let formattedDate = Date.formattedDate(from: customDate)
     print(formattedDate) // 예: "2023.10.10 월요일"
     */

    static func formattedDate(from date: Date) -> String {
        // 원하는 날짜를 표시할 DateFormatter 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd EEEE"  // 원하는 날짜 형식으로 설정
        dateFormatter.locale = Locale(identifier: "ko_KR")  // 한글 요일로 설정

        // 지정된 날짜를 원하는 형식으로 변환
        let formattedDate = dateFormatter.string(from: date)

        return formattedDate
    }

    static func formatTime(_ time: Date?) -> String {

        guard let time = time else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: time)
    }
}
