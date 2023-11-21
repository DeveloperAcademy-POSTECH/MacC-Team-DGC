//
//  SelectAddressTableViewCell.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/12.
//

import UIKit

final class SelectAddressTableViewCell: UITableViewCell {

    let cellBackgroundImage = UIView()
    let buildingNameLabel = UILabel()
    let detailAddressLabel = UILabel()

    // MARK: - 기본 override function
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     셀 하이라이트 시 셀 색상을 변경하는 override Method
     */
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            if highlighted {
                // 셀이 하이라이트 상태일 때 색상
                cellBackgroundImage.backgroundColor = UIColor.semantic.accPrimary
                buildingNameLabel.textColor = UIColor.semantic.textSecondary
                detailAddressLabel.textColor = UIColor.semantic.textSecondary
            } else {
                // 셀이 하이라이트 상태가 아닐 때 원래 색상으로 변경
                cellBackgroundImage.backgroundColor = UIColor.semantic.backgroundAddress
                buildingNameLabel.textColor = UIColor.semantic.textPrimary
                detailAddressLabel.textColor = UIColor.semantic.textBody
            }
    }
}

// MARK: - UI Setup function
extension SelectAddressTableViewCell {

    private func setupUI() {
        cellBackgroundImage.backgroundColor = UIColor.semantic.backgroundAddress
        cellBackgroundImage.layer.cornerRadius = 20

        buildingNameLabel.font = UIFont.carmuFont.body2
        buildingNameLabel.textColor = UIColor.semantic.textPrimary
        detailAddressLabel.font = UIFont.carmuFont.body2
        detailAddressLabel.textColor = UIColor.semantic.textBody

        detailAddressLabel.textAlignment = .left

        contentView.addSubview(cellBackgroundImage)
        contentView.addSubview(buildingNameLabel)
        contentView.addSubview(detailAddressLabel)
    }

    private func setupConstraints() {
        cellBackgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(79)
        }

        buildingNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
        }

        detailAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(buildingNameLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Previewer
import SwiftUI

@available(iOS 13.0.0, *)
struct SelectAddressCellPreview: PreviewProvider {

    static var previews: some View {
        SelectAddressViewControllerRepresentable()
    }
}
