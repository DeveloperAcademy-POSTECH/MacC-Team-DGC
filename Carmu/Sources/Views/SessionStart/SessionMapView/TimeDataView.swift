//
//  TimeDataView.swift
//  Carmu
//
//  Created by 허준혁 on 10/22/23.
//

import UIKit

import SnapKit

final class TimeDataView: UIView {

    let titleLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        label.font = UIFont.carmuFont.body1
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10.0
        label.backgroundColor = UIColor.semantic.backgroundList // 임시로 넣음
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.body3
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(3)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(timeLabel.snp.leading).offset(-2)
            make.top.bottom.equalTo(timeLabel)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
