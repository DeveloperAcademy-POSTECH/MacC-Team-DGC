//
//  DefaultAddressTableViewCell.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/12.
//

import UIKit

final class DefaultAddressTableViewCell: UITableViewCell {

    private let cellBackgroundImage = UIView()
    private let cellTextLabel = UILabel()

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

        cellTextLabel.text = "주소지를 검색해주세요"
        cellTextLabel.font = UIFont.carmuFont.body2Long
        cellTextLabel.textColor = UIColor.semantic.textBody

        contentView.addSubview(cellBackgroundImage)
        contentView.addSubview(cellTextLabel)
    }

    private func setupConstraints() {
        cellBackgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(79)
        }

        cellTextLabel.snp.makeConstraints { make in
            make.center.equalTo(cellBackgroundImage)
        }
    }

}
