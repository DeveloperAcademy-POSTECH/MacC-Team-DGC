//
//  StopoverPointAddButtonView.swift
//  Carmu
//
//  Created by 김동현 on 11/9/23.
//

import UIKit

import SnapKit

final class StopoverPointAddButtonView: UIView {

    let addPointButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("􀅼 경유지 추가", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead2
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.semantic.accPrimary ?? .white), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "경유지는 최대 3개까지 생성할 수 있습니다."
        label.font = UIFont.carmuFont.body1Long
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {

        addSubview(addPointButton)
        addSubview(buttonLabel)

        addPointButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(108)
            make.height.equalTo(30)
        }

        buttonLabel.snp.makeConstraints { make in
            make.top.equalTo(addPointButton.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
}
