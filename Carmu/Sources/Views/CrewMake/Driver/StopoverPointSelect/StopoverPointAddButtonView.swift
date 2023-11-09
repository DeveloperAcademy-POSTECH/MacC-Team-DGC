//
//  StopoverPointAddButtonView.swift
//  Carmu
//
//  Created by 김동현 on 11/9/23.
//

import UIKit

import SnapKit

protocol SelectAddressButtonProtocol: UIView {
    var button: UIButton { get set }
    var label: UILabel { get set }
}

final class StopoverPointAddButtonView: UIView, SelectAddressButtonProtocol {
    var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("􀅼 경유지 추가", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead2
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.semantic.accPrimary ?? .white), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()

    var label: UILabel = {
        let label = UILabel()
        label.text = "경유지는 최대 3개까지 생성할 수 있습니다."
        label.font = UIFont.carmuFont.body1Long
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        addSubview(button)
        addSubview(label)

        button.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(108)
            make.height.equalTo(30)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(6)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
