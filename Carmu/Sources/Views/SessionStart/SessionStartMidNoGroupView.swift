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
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    // 앞면 뷰
    private lazy var frontView = FrontView()

    // 뒷면 뷰
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupUI()

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
}

// MARK: - Layout Methods
extension SessionStartMidNoGroupView {
    private func setupUI() {
        addSubview(contentView)
        contentView.addSubview(frontView)
        contentView.addSubview(backView)

        layer.cornerRadius = 20
        layer.shadowColor = UIColor.semantic.accPrimary?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10

    }
}

// MARK: - Actions
extension SessionStartMidNoGroupView {
    @objc private func flip() {
        isFlipped.toggle()

        let transitionOptions: UIView.AnimationOptions = isFlipped ? .transitionFlipFromLeft : .transitionFlipFromRight

        UIView.transition(with: contentView, duration: 0.4, options: transitionOptions, animations: {
            self.frontView.isHidden = self.isFlipped
            self.backView.isHidden = !self.isFlipped
        }, completion: nil)
    }
}

// MARK: - 앞면 뷰
final class FrontView: UIView {
    lazy var frontImage: UIImageView = {
        let img = UIImage(named: "NoGroupBlinker")
        let imageView = UIImageView(image: img)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var frontComment: UILabel = {
        let lbl = UILabel()

        let attributedText = NSMutableAttributedString(string: "아직 참여중인\n여정이 없어요", attributes: [
            .font: UIFont.carmuFont.headline1
        ])

        let body1LongText = NSMutableAttributedString(string: "\n\n여정을 만들어 보세요!", attributes: [
            .font: UIFont.carmuFont.body1Long,
            .foregroundColor: UIColor.semantic.textTertiary as Any
        ])

        attributedText.append(body1LongText)

        lbl.attributedText = attributedText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0

        return lbl
    }()
    lazy var createGroupButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("크루 만들기", for: .normal)
        btn.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        btn.backgroundColor = UIColor.semantic.accPrimary
        btn.layer.cornerRadius = 30
        return btn
    }()
    lazy var inviteCodeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("초대코드 입력하기", for: .normal)
        btn.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.backgroundColor = UIColor.semantic.accPrimary
        btn.layer.cornerRadius = 30
        return btn
    }()

    init() {
        super.init(frame: .zero)
        setupFrontView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFrontView() {
        addSubview(frontImage)
        addSubview(frontComment)
        addSubview(createGroupButton)
        addSubview(inviteCodeButton)
    }

    private func setupConstraints() {
        // Add your constraints for the FrontView's subviews here.
        frontImage.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(40)
            make.leading.trailing.equalToSuperview().inset(124)
            make.height.equalTo(70)
        }
        frontComment.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(frontImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        createGroupButton.snp.makeConstraints { make in
            make.top.equalTo(frontComment.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(60)
        }
        inviteCodeButton.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(createGroupButton.snp.bottom).offset(12)
            make.bottom.greaterThanOrEqualToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(60)
        }
    }
}
