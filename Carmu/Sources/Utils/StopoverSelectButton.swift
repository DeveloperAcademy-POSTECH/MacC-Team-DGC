//
//  StopoverSelectButton.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class StopoverSelectButton: UIButton {

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

    private let detailTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.subhead3

        return label
    }()

    // 버튼 컴포넌트의 기본 높이를 54로 지정
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 54)
    }

    init(address: String, _ isStart: Bool = true, time: Date) {
        super.init(frame: .zero)

        addressLabel.text = address
        timeLabel.text = isStart ? "출발" : "도착"
        detailTimeLabel.text = Date.formattedDate(from: time, dateFormat: "aa hh:mm")

        addSubview(addressLabel)
        addSubview(timeLabel)
        addSubview(detailTimeLabel)

        backgroundColor = UIColor.semantic.backgroundDefault
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.theme.blue6?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2

        self.addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.greaterThanOrEqualTo(timeLabel.snp.leading).offset(-30)
            make.width.equalTo(140)
        }

        self.timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(detailTimeLabel.snp.leading).offset(-5)
            make.width.equalTo(22)
        }

        self.detailTimeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(74)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
