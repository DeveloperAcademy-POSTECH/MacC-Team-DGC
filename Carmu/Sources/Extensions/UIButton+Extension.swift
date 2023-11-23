//
//  UIButton+Extension.swift
//  Carmu
//
//  Created by 허준혁 on 11/23/23.
//

import UIKit

extension UIButton {

    func hideButton() {
        isHidden = true
        isEnabled = false
        backgroundColor = UIColor.semantic.backgroundThird
    }

    func showButton(title: String, buttonColor: UIColor? = nil, enabled: Bool = true) {
        isHidden = false
        setTitle(title, for: .normal)
        isEnabled = enabled
        backgroundColor = enabled ? buttonColor : UIColor.semantic.backgroundThird
    }
}
