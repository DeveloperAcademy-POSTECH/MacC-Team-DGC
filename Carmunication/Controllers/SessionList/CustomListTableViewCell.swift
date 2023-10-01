//
//  CustomListTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

final class CustomListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let driverLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        driverLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(driverLabel)
        // Auto Layout 설정(셀 내부)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
        driverLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
