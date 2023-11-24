//
//  SessionStartMidNoCrewView.swift
//  Carmu
//
//  Created by 김태형 on 2023/10/18.
//

import UIKit

import SnapKit

final class SessionStartNoCrewView: UIView {

    private lazy var isFlipped = false
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.semantic.backgroundDefault
        return view
    }()

    // 앞면 뷰
    lazy var noCrewFrontView = NoCrewFrontView()
    // 뒷면 뷰
    private lazy var noCrewBackView = NoCrewBackView()

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
        noCrewFrontView.frame = bounds
        noCrewBackView.frame = bounds

    }
}

// MARK: - Layout Methods
extension SessionStartNoCrewView {

    private func setupUI() {
        addSubview(contentView)
        contentView.addSubview(noCrewFrontView)
        contentView.addSubview(noCrewBackView)
        noCrewBackView.isHidden = true

        layer.cornerRadius = 20
        layer.shadowColor = UIColor.semantic.accPrimary?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
    }
}

// MARK: - Actions
extension SessionStartNoCrewView {

    @objc private func flip() {
        isFlipped.toggle()

        let transitionOptions: UIView.AnimationOptions = isFlipped ? .transitionFlipFromLeft : .transitionFlipFromRight

        UIView.transition(with: contentView, duration: 0.4, options: transitionOptions, animations: {
            self.noCrewFrontView.isHidden = self.isFlipped
            self.noCrewBackView.isHidden = !self.isFlipped
        }, completion: nil)
    }
}

// MARK: - 앞면 뷰
final class NoCrewFrontView: UIView {

    private let deviceHeight = UIScreen.main.bounds.height

    private lazy var frontImage: UIImageView = {
        let image = UIImage(named: "NoCrewBlinker")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var comment: UILabel = {
        let label = UILabel()

        let attributedText = NSMutableAttributedString(string: "아직 참여중인\n여정이 없어요", attributes: [
            .font: UIFont.carmuFont.headline1
        ])

        let body1LongText = NSMutableAttributedString(string: "\n\n여정을 만들어 보세요!", attributes: [
            .font: UIFont.carmuFont.body1Long,
            .foregroundColor: UIColor.semantic.textTertiary as Any
        ])

        attributedText.append(body1LongText)

        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    lazy var createCrewButton: UIButton = {
        let button = UIButton()
        button.setTitle("크루 만들기", for: .normal)
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.backgroundColor = UIColor.semantic.accPrimary
        button.layer.cornerRadius = deviceHeight == 667 ? 15 : 30
        return button
    }()

    lazy var inviteCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("초대코드 입력하기", for: .normal)
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.backgroundColor = UIColor.semantic.accPrimary
        button.layer.cornerRadius = deviceHeight == 667 ? 15 : 30
        return button
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
        addSubview(comment)
        addSubview(createCrewButton)
        addSubview(inviteCodeButton)
    }

    private func setupConstraints() {
        frontImage.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
        }

        comment.snp.makeConstraints { make in
            make.top.equalTo(frontImage.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        createCrewButton.snp.makeConstraints { make in
            make.top.equalTo(comment.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(deviceHeight == 667 ? 30 : 60)
        }

        inviteCodeButton.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(createCrewButton.snp.bottom).offset(12)
            make.bottom.greaterThanOrEqualToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(60).priority(.high)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(deviceHeight == 667 ? 30 : 60)
        }
    }
}

// MARK: - 뒷면 뷰
final class NoCrewBackView: UIView {

    private let ruleImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Rules"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupBackView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBackView() {
        addSubview(ruleImage)
    }

    private func setupConstraints() {
        ruleImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
