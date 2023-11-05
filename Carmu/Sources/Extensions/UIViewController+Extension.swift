//
//  UIViewController+Extension.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/05.
//

import UIKit

extension UIViewController {

    // TODO: - Firebase 형식에 맞게 변경
    /// 운전자인지 여부 확인
    func isCaptain() -> Bool {
        crewData?.captainID == "ted"
    }
}
