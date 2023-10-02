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
        case subhead1, subhead2, subhead3
        case headline1, headline2
        case display1, display2, display3
        case body1, body1Long
        case body2, body2Long
        case body3, body3Long

        func applyFont(to label: UILabel) {
            // Letter spacing 조정
            let letterSpacing = -0.6
            // 폰트를 찾을 수 없는 경우 기본 시스템 폰트 사용
            guard let customFont = UIFont(name: fontName, size: fontSize) else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeight / fontSize
            let attributes: [NSAttributedString.Key: Any] = [
                .font: customFont,
                .kern: letterSpacing,
                .paragraphStyle: paragraphStyle
            ]
            label.attributedText = NSAttributedString(string: label.text ?? "", attributes: attributes)
        }

        private var fontName: String {
            switch self {
            case .subhead1, .subhead2, .subhead3, .headline1, .headline2, .display1, .display2, .display3:
                return "SFPro-Bold"
            case .body1, .body1Long, .body2, .body2Long, .body3, .body3Long:
                return "SFPro-Regular"
            }
        }

        private var fontSize: CGFloat {
            switch self {
            case .subhead1, .body1, .body1Long:
                return 12
            case .subhead2, .body2, .body2Long:
                return 14
            case .subhead3, .body3, .body3Long:
                return 16
            case .headline1:
                return 20
            case .headline2:
                return 24
            case .display1:
                return 28
            case .display2:
                return 32
            case .display3:
                return 36
            }
        }

        private var lineHeight: CGFloat {
            switch self {
            case .subhead1, .body1:
                return 12
            case .subhead2, .body2:
                return 14
            case .body1Long, .body2Long:
                return 18
            case .subhead3, .body3:
                return 22
            case .headline1, .body3Long:
                return 28
            case .headline2:
                return 34
            case .display1:
                return 38
            case .display2:
                return 42
            case .display3:
                return 46
            }
        }
    }
}
