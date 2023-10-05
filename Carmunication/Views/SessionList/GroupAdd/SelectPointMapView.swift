//
//  SelectPointMapView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

final class SelectPointMapView: UIView {

    private lazy var vStackContainer = {
        let vStack = UIStackView(arrangedSubviews: [titleLabel, backButton])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .fillEqually
        return vStack
    }()

    private let titleLabel = {
        let label = UILabel()
        label.text = "맵뷰"
        return label
    }()

    let backButton = {
        let backButton = UIButton()
        backButton.setTitle("뒤로", for: .normal)
        backButton.setBackgroundImage(.pixel(ofColor: .blue), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        addSubview(vStackContainer)
        vStackContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
