//
//  SessionStartMidNoGroupView.swift
//  Carmu
//
//  Created by 김태형 on 2023/10/18.
//

import UIKit

import SnapKit

final class SessionStartMidNoGroupView: UIView {

    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var firstCommentLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.font = UIFont.carmuFont.headline1
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        let fullText = "초대하거나 받은 여정이 없어요\n친구와 함께 여정을 시작해보세요!"
        let attributedText = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "여정을 시작")
        attributedText.addAttributes([.foregroundColor: UIColor.semantic.accPrimary as Any], range: range)
        lbl.attributedText = attributedText
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Layout Methods
extension SessionStartMidNoGroupView {

    private func setupUI() {
        addSubview(logoImage)
        addSubview(firstCommentLabel)
    }

    private func setupConstraints() {
        logoImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        firstCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).inset(-32)
            make.centerX.equalToSuperview()
        }
    }
}
