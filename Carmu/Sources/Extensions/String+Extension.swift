//
//  File.swift
//  Carmunication
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
}
