//
//  RuleDescriptionView.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/10.
//

import UIKit

import SnapKit

final class RuleDescriptionView: UIView {

    private lazy var descriptionView: UIView = {
        let view = NoCrewBackView()
        view.driverDetailLabel.text = "시간 내 응답을 하지 않으면 자동으로\n 운행을 하지 않는다고 알려요"
        view.passengerDetailLabel.text = "시간 내 응답을 하지 않으면 자동으로\n 탑승을 하지 않는다고 알려요"
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension RuleDescriptionView {

    private func setupUI() {
        backgroundColor = UIColor.semantic.backgroundDefault
        layer.cornerRadius = 20

        addSubview(descriptionView)
    }

    private func setupConstraints() {
        descriptionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
