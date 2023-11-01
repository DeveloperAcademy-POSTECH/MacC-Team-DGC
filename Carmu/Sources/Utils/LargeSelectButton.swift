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

    let topTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    let bottomTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    init(topTitle: String, bottomTitle: String, imageName: String) {
        super.init(frame: .zero)
        self.topTitle.text = topTitle
        self.bottomTitle.text = bottomTitle
        iconImageView.image = UIImage(named: imageName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {

        layer.cornerRadius = 20
        backgroundColor = UIColor.semantic.backgroundDefault
        layer.shadowColor = UIColor.theme.black?.cgColor
        layer.shadowOffset = CGSize(width: -5, height: 5)
        layer.shadowRadius = 20
        layer.shadowOpacity = 1

        // 서브뷰 추가
        addSubview(topTitle)
        addSubview(iconImageView)
        addSubview(bottomTitle)

        topTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.bottom.greaterThanOrEqualTo(-10)
            make.centerX.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(topTitle.snp.bottom).offset(16)
            make.bottom.greaterThanOrEqualTo(-15)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(70)
        }

        bottomTitle.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(25)
            make.bottom.equalToSuperview().offset(-28)
            make.centerX.equalToSuperview()
        }
    }

}
