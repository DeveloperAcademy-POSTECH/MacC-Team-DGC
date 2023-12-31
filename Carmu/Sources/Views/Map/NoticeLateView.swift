//
//  NoticeLateView.swift
//  Carmu
//
//  Created by 허준혁 on 10/23/23.
//

import UIKit

import SnapKit

final class NoticeLateView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "지각 알림을 보냅니다"
        label.font = UIFont.carmuFont.headline2
        label.textColor = UIColor.theme.black
        return label
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = UIColor(hex: "7F7F7F", alpha: 0.2)
        return button
    }()

    let lateThreeMinutesButton: UIButton = {
        var config = UIButton.Configuration.filled()

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.carmuFont.headline2
        titleContainer.foregroundColor = UIColor.semantic.textSecondary

        config.attributedTitle = AttributedString("3분", attributes: titleContainer)
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.semantic.accPrimary

        let button = UIButton(configuration: config)
        return button
    }()

    let lateFiveMinutesButton: UIButton = {
        var config = UIButton.Configuration.filled()

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.carmuFont.headline2
        titleContainer.foregroundColor = UIColor.semantic.textSecondary

        config.attributedTitle = AttributedString("5분", attributes: titleContainer)
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.semantic.accPrimary

        let button = UIButton(configuration: config)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        let padding = 20

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(36)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerY.trailing.equalTo(titleLabel)
            make.width.height.equalTo(28)
        }

        let buttonHeight = 60

        addSubview(lateThreeMinutesButton)
        lateThreeMinutesButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(48)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(buttonHeight)
        }

        addSubview(lateFiveMinutesButton)
        lateFiveMinutesButton.snp.makeConstraints { make in
            make.top.equalTo(lateThreeMinutesButton.snp.bottom).offset(padding)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(buttonHeight)
        }
    }
}
