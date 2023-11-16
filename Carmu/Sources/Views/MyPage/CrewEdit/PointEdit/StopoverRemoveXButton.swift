//
//  StopoverRemoveXButton.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/16.
//

import UIKit

// MARK: - 경유지 삭제 X 버튼
final class StopoverRemoveXButton: UIButton {

    // 어떤 장소의 버튼인지를 식별하기 위한 값 (출발지,경유지,도착지)
    var pointType: PointType?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init() {
        super.init(frame: .zero)
        setImage(UIImage(systemName: "xmark"), for: .normal)
        tintColor = UIColor.semantic.stoke
        isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
