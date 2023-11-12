//
//  StopOverInfoBackView.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/11.
//

import UIKit

import SnapKit

final class StopOverInfoLeftView: UIView {

    private lazy var dotImage: UIImageView = {
        let image = UIImage(systemName: "circle.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.theme.blue3 ?? UIColor.systemBlue
        return imageView
    }()

    lazy var locationName: UILabel = {
        let label = UILabel()
        label.text = "경유지 이름"
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textPrimary
        label.textAlignment = .left
        return label
    }()

    lazy var crewMember: UILabel = {
        let label = UILabel()
        label.text = "배찌 레이"
        label.numberOfLines = 0
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension StopOverInfoLeftView {

    private func setupUI() {
        addSubview(dotImage)
        addSubview(locationName)
        addSubview(crewMember)
    }

    private func setupConstraints() {
        dotImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(8)
        }
        locationName.snp.makeConstraints { make in
            make.leading.equalTo(dotImage.snp.trailing).offset(8)
            make.centerY.equalTo(dotImage)
        }
        crewMember.snp.makeConstraints { make in
            make.leading.equalTo(locationName)
            make.top.equalTo(locationName.snp.bottom).offset(8)
            make.width.lessThanOrEqualTo(112)
        }
    }
}
