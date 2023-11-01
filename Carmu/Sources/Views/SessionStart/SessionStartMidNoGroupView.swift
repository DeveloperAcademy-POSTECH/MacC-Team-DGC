//
//  SessionStartMidNoGroupView.swift
//  Carmu
//
//  Created by 김태형 on 2023/10/18.
//

import UIKit

import SnapKit

final class SessionStartMidNoGroupView: UIView {

    private lazy var isFlipped = false
    private lazy var contentView = UIView()  // 앞면, 뒷면을 담을 뷰
    private lazy var frontView = UIView() // 앞면 뷰
    private lazy var backView = UIView() // 뒷면 뷰


    init() {
        super.init(frame: .zero)

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor

        // 앞면 뷰
        frontView.backgroundColor = .white

        // 뒷면 뷰
        backView.backgroundColor = .systemBlue

        backView.isHidden = true

        addSubview(contentView)
        contentView.addSubview(frontView)
        contentView.addSubview(backView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flip))  // flip 메서드 만들기
        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = bounds
        frontView.frame = bounds
        backView.frame = bounds

    }

    @objc func flip() {
        isFlipped.toggle()

        let transitionOptions: UIView.AnimationOptions = isFlipped ? .transitionFlipFromLeft : .transitionFlipFromRight

        UIView.transition(with: contentView, duration: 0.4, options: transitionOptions, animations: {
            self.frontView.isHidden = self.isFlipped
            self.backView.isHidden = !self.isFlipped
        }, completion: nil)
    }
}

// MARK: - Layout Methods
extension SessionStartMidNoGroupView {

}
