//
//  TitleUtil.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

final class CrewMakeUtil {
    static func defalutTitle(titleText: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.carmuFont.headline2
        titleLabel.textColor = UIColor.semantic.textPrimary
        return titleLabel
    }

    static func accPrimaryTitle(titleText: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.carmuFont.headline2
        titleLabel.textColor = UIColor.semantic.accPrimary
        return titleLabel
    }
}
