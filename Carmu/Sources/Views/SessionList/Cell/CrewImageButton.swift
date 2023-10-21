//
//  CrewImageButton.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/17.
//

import UIKit

final class CrewImageButton: UIButton {

    private let crewImagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    let crewImage1 = UIImageView()
    let crewImage2 = UIImageView()
    let crewImage3 = UIImageView()

    init() {
        super.init(frame: .zero)

        crewImagesStackView.addArrangedSubview(crewImage1)
        crewImagesStackView.addArrangedSubview(crewImage2)
        crewImagesStackView.addArrangedSubview(crewImage3)
        crewImage1.image = UIImage(named: "CrewPlusImage")
        crewImage2.image = UIImage(named: "CrewPlusImage")
        crewImage3.image = UIImage(named: "CrewPlusImage")
        crewImage1.contentMode = .scaleAspectFit
        crewImage2.contentMode = .scaleAspectFit
        crewImage3.contentMode = .scaleAspectFit

        addSubview(crewImagesStackView)

        layer.cornerRadius = 18
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.semantic.backgroundTouchable?.cgColor

        crewImagesStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(8) // 1번 이미지
            make.trailing.equalToSuperview().inset(8) // 3번 이미지
        }
    }

    // hitTest 메서드를 재정의하여 터치 이벤트를 뷰 스택에 전달
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            return self
        }
        for subview in subviews {
            let convertedPoint = subview.convert(point, from: self)
            if let hitView = subview.hitTest(convertedPoint, with: event) {
                return hitView
            }
        }
        return nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
