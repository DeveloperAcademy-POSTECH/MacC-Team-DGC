//
//  CarpoolPlanLabel.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/10.
//

import UIKit

final class CarpoolPlanLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        text = "카풀 계획 보러가기 >"
        font = UIFont.carmuFont.body1Long
        textColor = UIColor.semantic.accPrimary
    }
}
