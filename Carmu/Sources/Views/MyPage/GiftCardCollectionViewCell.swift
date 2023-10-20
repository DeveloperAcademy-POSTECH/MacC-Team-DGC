//
//  GiftCardCollectionViewCell.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/11.
//

import UIKit

// MARK: - 친구 상세페이지 추천 선물 컬렉션 뷰 셀
final class GiftCardCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "giftCardCollectionViewCell"

    // 선물 이미지
    lazy var giftImageView: UIImageView = {
        let giftImageView = UIImageView()
        giftImageView.contentMode = .scaleAspectFit
        return giftImageView
    }()

    // 거리
    lazy var distanceLabel: UILabel = {
        let distanceLabel = UILabel()
        distanceLabel.textColor = UIColor.semantic.accPrimary
        distanceLabel.font = UIFont.carmuFont.subhead2
        return distanceLabel
    }()

    // 선물 이름
    lazy var giftNameLabel: UILabel = {
        let giftNameLabel = UILabel()
        giftNameLabel.textColor = UIColor.semantic.textPrimary
        giftNameLabel.font = UIFont.carmuFont.subhead3
        return giftNameLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setAutoLayout()

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.theme.blue3?.cgColor
        self.layer.cornerRadius = 20
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setAutoLayout()
    }

    func setupViews() {
        addSubview(giftImageView)
        addSubview(distanceLabel)
        addSubview(giftNameLabel)
    }

    func setAutoLayout() {
        giftImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(28.5)
            make.height.equalTo(self.frame.height/2.5)
        }
        distanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(giftImageView.snp.bottom).offset(8)
        }
        giftNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(distanceLabel.snp.bottom).offset(4)
        }
    }
}
