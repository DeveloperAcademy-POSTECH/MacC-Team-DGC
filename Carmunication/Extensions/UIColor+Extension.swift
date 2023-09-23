//
//  UIColor+Extension.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

extension UIColor {
    static let lightModePointColor = UIColor(hexCode: "#627AF3")
    static let darkModePointColor = UIColor(hexCode: "#2CFFDC")
}

extension UIColor {

    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
