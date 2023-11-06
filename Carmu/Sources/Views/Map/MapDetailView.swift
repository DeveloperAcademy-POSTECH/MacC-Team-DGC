//
//  MapDetailView.swift
//  Carmu
//
//  Created by 허준혁 on 10/22/23.
//

import UIKit

import SnapKit

final class MapDetailView: UIView {

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

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.semantic.backgroundDefault

        showTitleLabel()
        showNoticeLateButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
}
