//
//  AddressSelectButton.swift
//  Carmu
//
//  Created by 김동현 on 11/8/23.
//

import Foundation

/**
 경유지 설정 화면에서 선택하는 버튼.
 */
final class AddressSelectButtonView: UIView, SelectAddressButtonProtocol {

    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    lazy var xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.theme.blue3
        button.isHidden = true
        return button
    }()

    internal var button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.carmuFont.body2Long
        button.setTitleColor(UIColor.semantic.textBody, for: .normal)
        button.layer.borderColor = UIColor.theme.blue3?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 17
        button.contentHorizontalAlignment = .left
        button.isSpringLoaded = true
        return button
    }()

    /**
     address: 출발지의 대표명
     isStart: 도착지라면 false(기본값 true)
     time: 출발 또는 도착 시간
     */
    init(textFieldTitle: String, hasXButton: Bool = false) {
        super.init(frame: .zero)

        label.text = textFieldTitle
        button.setTitle("     \(textFieldTitle) 검색", for: .normal)

        addSubview(label)
        addSubview(button)
        if hasXButton {
            addSubview(xButton)
            xButton.snp.makeConstraints { make in
                make.centerY.equalTo(label)
                make.trailing.equalToSuperview()
                make.width.height.equalTo(20)
            }
        }

        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(34)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct ASBViewPreview: PreviewProvider {
    static var previews: some View {
        SEPViewControllerRepresentable()
    }
}
