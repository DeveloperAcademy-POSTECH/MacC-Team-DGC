//
//  TimeTypeLabel.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/14.
//

import UIKit

// MARK: - 시간 타입 라벨
final class TimeTypeLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(timeType: TimeType) {
        super.init(frame: .zero)
        text = timeType.rawValue
        font = UIFont.carmuFont.body1
        textColor = UIColor.semantic.textTertiary
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
