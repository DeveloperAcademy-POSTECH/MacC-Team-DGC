//
//  File.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/17.
//

import Foundation

extension String {

    static func removeCountryAndPostalCode(from subtitle: String) -> String {
        var modifiedSubtitle = subtitle
        modifiedSubtitle = modifiedSubtitle.replacingOccurrences(of: "대한민국", with: "")
        if let range = modifiedSubtitle.range(of: ", \\d{5}", options: .regularExpression) {
            modifiedSubtitle = modifiedSubtitle.replacingCharacters(in: range, with: "")
        }
        if let range = modifiedSubtitle.range(of: "\\d{5}", options: .regularExpression) {
            modifiedSubtitle = modifiedSubtitle.replacingCharacters(in: range, with: "")
        }

        return modifiedSubtitle.trimmingCharacters(in: .whitespaces)
    }

    // 문자열의 앞글자만 대문자로 바꿔주는 메서드 (프로필 이미지 초기화에 필요)
    func capitalizedFirstCharacter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
