//
//  AddressEditButton.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/16.
//

import UIKit

// MARK: - 주소 편집 버튼
final class AddressEditButton: UIButton {

    // 어떤 장소의 버튼인지를 식별하기 위한 값 (출발지,경유지,도착지)
    var pointType: PointType?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("주소를 입력해주세요", for: .normal)
        titleLabel?.font = UIFont.carmuFont.subhead2
        setTitleColor(.black, for: .normal)
        backgroundColor = UIColor.semantic.backgroundDefault
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.semantic.stoke?.cgColor
        contentHorizontalAlignment = .leading
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        configuration = config
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
