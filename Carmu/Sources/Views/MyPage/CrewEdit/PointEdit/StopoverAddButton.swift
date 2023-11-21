//
//  StopoverAddButton.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/16.
//

import UIKit

// MARK: - 경유지 추가 버튼
final class StopoverAddButton: UIButton {

    // 경유지 추가 버튼을 눌렀을 때 추가되어야 하는 경유지
    var pointType: PointType?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("+ 경유지 추가", for: .normal)
        titleLabel?.font = UIFont.carmuFont.subhead2
        setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        setBackgroundImage(UIImage(color: UIColor.semantic.accPrimary ?? .white), for: .normal)
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
