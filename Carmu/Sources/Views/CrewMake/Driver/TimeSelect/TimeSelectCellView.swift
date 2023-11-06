//
//  TimeSelectCellView.swift
//  Carmu
//
//  Created by 김동현 on 11/5/23.
//

import UIKit

final class TimeSelectCellView: UIView {

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.headline1
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.body1
        return label
    }()

    let detailTimeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.semantic.backgroundThird
        button.setBackgroundImage(UIImage(color: UIColor.semantic.textSecondary ?? .white), for: .highlighted)
        button.setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        button.setTitleColor(UIColor.semantic.textSecondary, for: .highlighted)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    /**
     address: 출발지의 대표명
     isStart: 도착지라면 false(기본값 true)
     time: 출발 또는 도착 시간
     */
    init(address: String, _ isStart: Bool = true, time: Date) {
        super.init(frame: .zero)

        addressLabel.text = address
        timeLabel.text = isStart ? "출발" : "도착"
        detailTimeButton.setTitle(Date.formattedDate(from: time, dateFormat: "aa hh:mm"), for: .normal)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(addressLabel)
        addSubview(timeLabel)
        addSubview(detailTimeButton)
    }

    private func setupConstraints() {
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(150)
        }

        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(detailTimeButton.snp.leading).offset(-5)
        }

        detailTimeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(84)
            make.height.equalTo(30)
        }
    }
}
