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
    private lazy var noCrewFrontView = NoCrewFrontView()
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
    private lazy var createCrewButton: UIButton = {
        let button = UIButton()
        button.setTitle("크루 만들기", for: .normal)
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.headline1
        button.backgroundColor = UIColor.semantic.accPrimary
        button.layer.cornerRadius = 30
        return button
    }()
    private lazy var inviteCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("초대코드 입력하기", for: .normal)
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.semantic.accPrimary
        button.layer.cornerRadius = 30
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
            make.top.lessThanOrEqualTo(frontImage.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        createCrewButton.snp.makeConstraints { make in
            make.top.equalTo(comment.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(60)
        }
        inviteCodeButton.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(createCrewButton.snp.bottom).offset(12)
            make.bottom.greaterThanOrEqualToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(60).priority(.high)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(60)
        }
    }
}

// MARK: - 뒷면 뷰
final class NoCrewBackView: UIView {

    private lazy var comment: UILabel = {
        let label = UILabel()
        label.text = "카뮤와 함께 즐겁게 카풀하기 위한 규칙"
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.textPrimary
        label.textAlignment = .center
        return label
    }()

    // 운전자 규칙 뷰
    private lazy var driverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var driverLabel: UILabel = {
        let label = UILabel()
        label.text = "운전자"
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.headline1
        label.textAlignment = .center
        return label
    }()
    private lazy var driverImage: UIImageView = {
        let image = UIImage(named: "DriverBlinker")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var driverInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "적어도 출발시간 30분 전까지는\n카풀 운행 여부를 알려주세요"
        label.font = UIFont.carmuFont.body3
        label.textAlignment = .center
        label.numberOfLines = 0

        let attributedText = NSMutableAttributedString(string: label.text ?? "")
        if let range1 = label.text?.range(of: "출발시간 30분 전") {
            let nsRange1 = NSRange(range1, in: label.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        label.attributedText = attributedText
        return label
    }()

    // 동승자 규칙 뷰
    private lazy var passengerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var passengerLabel: UILabel = {
        let label = UILabel()
        label.text = "동승자"
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.headline1
        label.textAlignment = .center
        return label
    }()
    private lazy var passengerImage: UIImageView = {
        let image = UIImage(named: "PassengerBlinker")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var passengerInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "적어도 출발시간 20분 전까지는\n카풀 탑승 여부를 알려주세요"
        label.font = UIFont.carmuFont.body3
        label.textAlignment = .center
        label.numberOfLines = 0

        let attributedText = NSMutableAttributedString(string: label.text ?? "")
        if let range1 = label.text?.range(of: "출발시간 20분 전") {
            let nsRange1 = NSRange(range1, in: label.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        label.attributedText = attributedText
        return label
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
        addSubview(comment)
        addSubview(driverView)
        addSubview(passengerView)

        driverView.addSubview(driverLabel)
        driverView.addSubview(driverImage)
        driverView.addSubview(driverInfoLabel)

        passengerView.addSubview(passengerLabel)
        passengerView.addSubview(passengerImage)
        passengerView.addSubview(passengerInfoLabel)
    }

    private func setupConstraints() {
        comment.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(28)
            make.centerX.equalToSuperview()
        }
        driverView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(comment.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(310)
            make.height.greaterThanOrEqualTo(120)
        }
        passengerView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(driverView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(20)
            make.width.equalTo(driverView)
            make.height.equalTo(driverView)
        }
        driverLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        driverImage.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(driverLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(50)
        }
        driverInfoLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(driverImage.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }

        passengerLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        passengerImage.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(passengerLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(50)
        }
        passengerInfoLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(passengerImage.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }
    }
}
