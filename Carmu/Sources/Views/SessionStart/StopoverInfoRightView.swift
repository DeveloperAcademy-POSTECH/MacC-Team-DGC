//
//  StopoverInfoRightView.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/11.
//

import UIKit

import SnapKit

final class StopoverInfoRightView: UIView {

    lazy var arrivalTime: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.semantic.textTertiary
        label.font = UIFont.carmuFont.subhead1
        label.textAlignment = .center
        return label
    }()

    private lazy var arriveLabel: UILabel = {
        let label = UILabel()
        label.text = "도착"
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.semantic.textTertiary
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StopoverInfoRightView {

    private func setupUI() {
        addSubview(arrivalTime)
        addSubview(arriveLabel)
    }

    private func setupConstraints() {
        arrivalTime.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        arriveLabel.snp.makeConstraints { make in
            make.leading.equalTo(arrivalTime.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
}
