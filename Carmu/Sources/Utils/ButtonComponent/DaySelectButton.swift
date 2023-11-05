//
//  DaySelectButton.swift
//  Carmu
//
//  Created by 김동현 on 11/5/23.
//

import UIKit

final class DaySelectButton: UIButton {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }

    init(buttonTitle: String) {
        super.init(frame: .zero)

        setTitle(buttonTitle, for: .normal)
        backgroundColor = UIColor.theme.blue3
        setTitleColor(UIColor.theme.blue1, for: .normal)
        titleLabel?.font = UIFont.carmuFont.subhead3
        layer.cornerRadius = 15
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 버튼을 탭할 시 외형 변경에 필요한 메서드
extension DaySelectButton {

    // 선택한 버튼의 외관을 변경
    func setSelectedButtonAppearance() {
        backgroundColor = UIColor.semantic.accPrimary
        setTitleColor(UIColor.semantic.textSecondary, for: .normal)
    }

    // 선택한 버튼의 외관을 복구
    func resetButtonAppearance() {
        backgroundColor = UIColor.theme.blue3
        setTitleColor(UIColor.theme.blue1, for: .normal)
    }
}
