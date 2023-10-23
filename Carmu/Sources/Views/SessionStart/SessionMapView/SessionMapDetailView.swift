//
//  SessionMapDetailView.swift
//  Carmu
//
//  Created by 허준혁 on 10/22/23.
//

import UIKit

import SnapKit

final class SessionMapDetailView: UIView {

    private let titleLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        label.backgroundColor = UIColor.semantic.backgroundSecond
        label.text = "🍎 C5 출근팟 늦으면 죽음 뿐 🍎"
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.subhead3
        label.textAlignment = .center
        return label
    }()

    let noticeLateButton: UIButton = {
        var config = UIButton.Configuration.filled()

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.carmuFont.headline2
        titleContainer.foregroundColor = UIColor.semantic.textSecondary

        config.attributedTitle = AttributedString("지각 알리기", attributes: titleContainer)
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.semantic.accPrimary

        let button = UIButton(configuration: config)
        return button
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    private let pointLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    private let actualTime = TimeDataView()
    private let plannedTime = TimeDataView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.semantic.backgroundDefault

        showTitleLabel()
        showNoticeLateButton()
        showAddressLabel()
        showPointLabel()
        showTimeInfo()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setDetailView(location: PickupLocation, address: String) {
        pointLabel.text = location.description
        addressLabel.text = address
    }

    private func showTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }

    private func showNoticeLateButton() {
        addSubview(noticeLateButton)
        noticeLateButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(48)
        }
    }

    private func showAddressLabel() {
        addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(noticeLateButton.snp.top).offset(-20)
        }
    }

    private func showPointLabel() {
        addSubview(pointLabel)
        pointLabel.snp.makeConstraints { make in
            make.leading.equalTo(addressLabel)
            make.bottom.equalTo(addressLabel.snp.top).offset(-4)
        }
    }

    private func showTimeInfo() {
        // 실제 시간
        addSubview(actualTime)
        actualTime.snp.makeConstraints { make in
            make.trailing.equalTo(noticeLateButton)
            make.bottom.equalTo(addressLabel)
        }
        actualTime.titleLabel.text = "예정"
        actualTime.titleLabel.textColor = UIColor.semantic.accPrimary
        actualTime.titleLabel.backgroundColor = UIColor.semantic.backgroundSecond
        actualTime.timeLabel.text = "00:00"
        actualTime.timeLabel.textColor = UIColor.semantic.accPrimary

        // 계획 시간
        addSubview(plannedTime)
        plannedTime.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-103)
            make.bottom.equalTo(actualTime)
        }
        plannedTime.titleLabel.text = "계획"
        plannedTime.titleLabel.textColor = UIColor.semantic.textBody
        plannedTime.titleLabel.backgroundColor = UIColor.semantic.backgroundList
        plannedTime.timeLabel.text = "00:00"
        plannedTime.timeLabel.textColor = UIColor.semantic.textBody
    }
}
