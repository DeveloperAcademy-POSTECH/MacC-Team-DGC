//
//  SelectAddressTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/12.
//

import UIKit

class SelectAddressTableViewCell: UITableViewCell {

    private let cellBackgroundImage = UIView()
    let buildingNameLabel = UILabel()
    let detailAddressLabel = UILabel()
    private let selectLabel = UILabel()

    // MARK: - 기본 override function
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
    }

    // MARK: - UI Setup function
    private func setupUI() {
        cellBackgroundImage.backgroundColor = UIColor.semantic.backgroundAddress
        cellBackgroundImage.layer.cornerRadius = 20

        selectLabel.text = "선택"

        buildingNameLabel.font = UIFont.carmuFont.body2
        buildingNameLabel.textColor = UIColor.semantic.textPrimary
        detailAddressLabel.font = UIFont.carmuFont.body2
        detailAddressLabel.textColor = UIColor.semantic.textBody
        selectLabel.font = UIFont.carmuFont.body2
        selectLabel.textColor = UIColor.semantic.accPrimary

        detailAddressLabel.textAlignment = .left

        contentView.addSubview(cellBackgroundImage)
        contentView.addSubview(buildingNameLabel)
        contentView.addSubview(detailAddressLabel)
        contentView.addSubview(selectLabel)
    }

    private func setupConstraints() {
        cellBackgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
            make.height.equalTo(82)
        }
        buildingNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
        }

        detailAddressLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.greaterThanOrEqualTo(200)
        }

        selectLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(16)
                make.trailing.equalToSuperview().inset(20)
        }
    }
}
