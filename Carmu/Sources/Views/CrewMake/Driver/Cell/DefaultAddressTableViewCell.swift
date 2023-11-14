//
//  NotFoundAddressTableViewCell.swift
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
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
            make.height.equalTo(82)
        }

        cellTextLabel.snp.makeConstraints { make in
            make.center.equalTo(cellBackgroundImage)
        }
    }

}
