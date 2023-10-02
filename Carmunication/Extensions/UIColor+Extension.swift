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

    static let theme = ColorTheme()
    static let semantic = SemanticColor()
}
