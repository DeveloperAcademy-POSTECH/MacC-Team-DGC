//
//  DayButtonCollectionViewCell.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/14.
//

import UIKit

// MARK: - 요일 버튼 셀
final class DayButtonCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "dayButtonCollectionViewCell"

    let dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.textColor = UIColor.semantic.textBody
        dayLabel.font = UIFont.carmuFont.headline2
        dayLabel.textAlignment = .center
        return dayLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        backgroundColor = UIColor.semantic.backgroundSecond
        setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
