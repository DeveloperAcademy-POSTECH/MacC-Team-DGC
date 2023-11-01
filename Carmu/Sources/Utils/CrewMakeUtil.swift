//
//  TitleUtil.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

/**
 주요 화면 상단에 표시되는 타이틀 텍스트의 Util
 */
final class CrewMakeUtil {
    /**
     textPrimary색 제목
     */
    static func defalutTitle(titleText: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.carmuFont.headline2
        titleLabel.textColor = UIColor.semantic.textPrimary
        return titleLabel
    }

    /**
     accPrimary색 제목
     */
    static func accPrimaryTitle(titleText: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.carmuFont.headline2
        titleLabel.textColor = UIColor.semantic.accPrimary
        return titleLabel
    }
}
