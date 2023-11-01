//
//  LargeSelectButton.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

final class LargeSelectButton: UIButton {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let topTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    let bottomTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    init(topTitle: String, bottomTitle: String, imageName: String) {
        super.init(frame: .zero)

        // 서브뷰 내용 설정
        topTitleLabel.text = topTitle
        bottomTitleLabel.text = bottomTitle
        iconImageView.image = UIImage(named: imageName)

        // 백그라운드, 그림자 설정
        backgroundColor = UIColor.semantic.backgroundDefault
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.theme.blue6?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2

        // 서브뷰 추가
        addSubview(topTitleLabel)
        addSubview(iconImageView)
        addSubview(bottomTitleLabel)

        // Auto Layout 설정
        topTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(topTitleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(70)
        }

        bottomTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
