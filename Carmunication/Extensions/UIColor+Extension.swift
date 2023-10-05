//
//  UIColor+Extension.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

/**
 Asset에 추가한 색상 컬러 사용 방법
 이렇게 사용할 경우 Black, White 와 같이 시스템과 비슷한 이름을 사용해도 충돌이 없다.
 ex)
 view.backgroundColor = UIColor.theme.red1

 시멘틱으로 정하지 않은 기본 컬러의 경우 theme을 쓴다.
 시멘틱컬러의 경우 semantic을 붙이고 그에 맞는 컬러를 쓴다.
 */
extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanedHex = cleanedHex.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: cleanedHex).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    static let theme = ColorTheme()
    static let semantic = SemanticColor()
}
