//
//  NoSearchedResultTableViewCell.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/17.
//

import UIKit

final class NoSearchedResultTableViewCell: UITableViewCell {

    static let cellIdentifier = "noSearchedResultTableViewCell"

    // 검색 결과 없음 라벨
    lazy var noResultLabel: UILabel = {
        let noResultLabel = UILabel()
        noResultLabel.text = "검색된 친구가 없습니다."
        noResultLabel.font = UIFont.carmuFont.body1
        noResultLabel.textColor = UIColor.semantic.textPrimary
        return noResultLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setAutoLayout()

        // 셀 배경 설정
        self.backgroundColor = UIColor.semantic.backgroundAddress
        self.layer.cornerRadius = 16
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setAutoLayout()
    }

    func setupViews() {
        addSubview(noResultLabel)
    }

    func setAutoLayout() {
        noResultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
