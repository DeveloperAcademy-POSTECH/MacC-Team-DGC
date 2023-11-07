//
//  RightNavigationBarButton.swift
//  Carmu
//
//  Created by 김동현 on 11/6/23.
//

import UIKit

final class RightNavigationBarButton: UIBarButtonItem {

    init(buttonTitle: String) {
        super.init()
        title = buttonTitle
        tintColor = UIColor.semantic.accPrimary
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
