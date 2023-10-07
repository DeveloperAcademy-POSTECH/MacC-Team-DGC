//
//  ModalQueueView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

final class ModalQueueView: UIView {

    let startButton: UIButton = {
        let startBtn = UIButton()
        startBtn.setTitle("바로 시작", for: .normal)
        startBtn.backgroundColor = .systemBlue
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        startBtn.layer.cornerRadius = 8
        return startBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
