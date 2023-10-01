//
//  UIFont+Extension.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/01.
//

import UIKit

extension UIFont {
    /**
     let label = UILabel()
     label.text = "텍스트"
     UIFont.CarmuFont.subhead1.applyFont(to: label)
     형식으로 사용
     */
    enum CarmuFont {
        case subhead1
        case subhead2
        case subhead3
        case headline1
        case headline2
        case display1
        case display2
        case display3
        case body1
        case body1Long
        case body2
        case body2Long
        case body3
        case body3Long
        func applyFont(to label: UILabel) {
            let fontName: String // SF Pro 폰트의 이름
            var fontSize: CGFloat
            var lineHeight: CGFloat // Line height 조정
            var letterSpacing: CGFloat = -0.6// Letter spacing 조정
            switch self {
            case .subhead1:
                fontName = "SFPro-Bold"
                fontSize = 12
                lineHeight = 12
            case .subhead2:
                fontName = "SFPro-Bold"
                fontSize = 14
                lineHeight = 14
            case .subhead3:
                fontName = "SFPro-Bold"
                fontSize = 16
                lineHeight = 22
            case .headline1:
                fontName = "SFPro-Bold"
                fontSize = 20
                lineHeight = 28
            case .headline2:
                fontName = "SFPro-Bold"
                fontSize = 24
                lineHeight = 34
            case .display1:
                fontName = "SFPro-Bold"
                fontSize = 28
                lineHeight = 38
            case .display2:
                fontName = "SFPro-Bold"
                fontSize = 32
                lineHeight = 42
            case .display3:
                fontName = "SFPro-Bold"
                fontSize = 36
                lineHeight = 46
            case .body1:
                fontName = "SFPro-Regular"
                fontSize = 12
                lineHeight = 12
            case .body1Long:
                fontName = "SFPro-Regular"
                fontSize = 12
                lineHeight = 18
            case .body2:
                fontName = "SFPro-Regular"
                fontSize = 14
                lineHeight = 14
            case .body2Long:
                fontName = "SFPro-Regular"
                fontSize = 14
                lineHeight = 18
            case .body3:
                fontName = "SFPro-Regular"
                fontSize = 16
                lineHeight = 22
            case .body3Long:
                fontName = "SFPro-Regular"
                fontSize = 16
                lineHeight = 28
            }
            guard let customFont = UIFont(name: fontName, size: fontSize) else {
                // 폰트를 찾을 수 없는 경우 기본 시스템 폰트 사용
                return
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeight / fontSize
            let attributes: [NSAttributedString.Key: Any] = [
                .font: customFont,
                .kern: letterSpacing,
                .paragraphStyle: paragraphStyle
            ]
            label.attributedText = NSAttributedString(string: label.text ?? "", attributes: attributes)
        }
    }
}
