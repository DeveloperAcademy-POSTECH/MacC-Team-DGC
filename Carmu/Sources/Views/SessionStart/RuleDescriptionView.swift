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
