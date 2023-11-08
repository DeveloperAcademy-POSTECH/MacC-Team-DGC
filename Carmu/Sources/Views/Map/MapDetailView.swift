//
//  MapDetailView.swift
//  Carmu
//
//  Created by 허준혁 on 10/22/23.
//

import UIKit

import SnapKit

final class MapDetailView: UIView {

    let titleLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        label.backgroundColor = UIColor.semantic.backgroundSecond
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.subhead3
        label.textAlignment = .left
        return label
    }()

    let giveUpButton: UIButton = {
        var config = UIButton.Configuration.filled()

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.carmuFont.headline2
        titleContainer.foregroundColor = UIColor.semantic.textSecondary

        config.attributedTitle = AttributedString("포기하기", attributes: titleContainer)
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.semantic.negative

        let button = UIButton(configuration: config)
        return button
    }()

    let noticeLateButton: UIButton = {
        var config = UIButton.Configuration.filled()

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.carmuFont.headline2
        titleContainer.foregroundColor = UIColor.semantic.textSecondary

        config.attributedTitle = AttributedString("지각 알리기", attributes: titleContainer)
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.semantic.accPrimary

        let button = UIButton(configuration: config)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.semantic.backgroundDefault
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        showTitleLabel()
        showBottomButtons()
    }

    private func showTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }

    private func showBottomButtons() {
        let bottomPadding = 48
        let outsidePadding = 20
        let insidePadding = frame.size.width / 2 + 5

        addSubview(giveUpButton)
        giveUpButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(outsidePadding)
            make.trailing.equalToSuperview().inset(insidePadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
        }

        addSubview(noticeLateButton)
        noticeLateButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(insidePadding)
            make.trailing.equalToSuperview().inset(outsidePadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
        }
    }
}
