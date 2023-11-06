//
//  NextButton.swift
//  Carmu
//
//  Created by 김동현 on 11/5/23.
//

import UIKit

final class NextButton: UIButton {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 64)
    }

    init(buttonTitle: String) {
        super.init(frame: .zero)

        setTitle(buttonTitle, for: .normal)
        backgroundColor = UIColor.semantic.accPrimary
        titleLabel?.font = UIFont.carmuFont.headline2
        setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        setBackgroundImage(
            UIImage(color: UIColor.semantic.textSecondary ?? .white),
            for: .highlighted
        )
        layer.cornerRadius = 30
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
