//
//  TimeEditButton.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/16.
//

import UIKit

// MARK: - 시간 설정 버튼
final class TimeEditButton: UIButton {

    // 어떤 장소의 버튼인지를 식별하기 위한 값 (출발지,경유지,도착지)
    var pointType: PointType?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("오전 08:00", for: .normal)
        titleLabel?.font = UIFont.carmuFont.subhead3
        setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        backgroundColor = UIColor.semantic.backgroundThird
        layer.cornerRadius = 4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
