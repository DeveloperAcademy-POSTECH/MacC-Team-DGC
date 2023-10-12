//
//  NotFoundAddressTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/12.
//

import UIKit

class DefaultAddressTableViewCell: UITableViewCell {

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
        cellTextLabel.text = "주소지를 검색해주세요"
        cellTextLabel.font = UIFont.carmuFont.body2Long
        cellTextLabel.textColor = UIColor.semantic.textBody

        contentView.addSubview(cellTextLabel)
    }

    private func setupConstraints() {
        cellTextLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

}
