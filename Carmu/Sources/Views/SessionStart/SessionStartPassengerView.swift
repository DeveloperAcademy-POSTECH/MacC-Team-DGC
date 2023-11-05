//
//  SessionStartPassengerView.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/02.
//

import UIKit

import SnapKit

final class SessionStartPassengerView: UIView {

    private lazy var isFlipped = false
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.semantic.backgroundDefault
        return view
    }()

    // 앞면 뷰
    lazy var passengerFrontView = PassengerFrontView()
    // 뒷면 뷰
    private lazy var passengerBackView = PassengerBackView()

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
        passengerFrontView.frame = bounds
        passengerBackView.frame = bounds

    }
}

// MARK: - Layout Methods
extension SessionStartPassengerView {

    private func setupUI() {
        addSubview(contentView)
        contentView.addSubview(passengerFrontView)
        contentView.addSubview(passengerBackView)
        passengerBackView.isHidden = true

        layer.cornerRadius = 20
        layer.shadowColor = UIColor.semantic.accPrimary?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
    }
}

// MARK: - Actions
extension SessionStartPassengerView {

    @objc private func flip() {
        isFlipped.toggle()

        let transitionOptions: UIView.AnimationOptions = isFlipped ? .transitionFlipFromLeft : .transitionFlipFromRight

        UIView.transition(with: contentView, duration: 0.4, options: transitionOptions, animations: {
            self.passengerFrontView.isHidden = self.isFlipped
            self.passengerBackView.isHidden = !self.isFlipped
        }, completion: nil)
    }
}

// MARK: - 앞면 뷰
final class PassengerFrontView: UIView {

    // 어디에 몇 시까지 나가야 하는지 알려주는 뷰
    private lazy var locationAndTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        return view
    }()
    private lazy var locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.headline1
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    private lazy var timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.headline1
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()

    // 운행 여부를 알려주는 뷰
    private lazy var driveInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.layer.cornerRadius = 16
        return view
    }()
    private lazy var statusImageView: UIImageView = {
        let img = UIImage(named: "HourglassBlinker")
        let imageView = UIImageView(image: img)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.subhead3
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.textAlignment = .center
        return lbl
    }()

    // 당일에 운행이 없을 때 나타나는 뷰
    lazy var noDriveViewForPassenger: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.layer.cornerRadius = 16
        return view
    }()
    private lazy var noDriveImage: UIImageView = {
        let img = UIImage(named: "NoSessionBlinker")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    private lazy var noDriveComment: UILabel = {
        let lbl = UILabel()
        lbl.text = "오늘은 카풀을 운행하지 않아요"
        lbl.font = UIFont.carmuFont.subhead3
        lbl.textColor = UIColor.semantic.negative
        lbl.textAlignment = .center
        return lbl
    }()

    init() {
        super.init(frame: .zero)
        setupFrontView()
        setupConstraints()
        settingData()

        // TODO: - 데이터 수정 후 변경 -> session 여부에 따라 true, false로 변경하기
        noDriveViewForPassenger.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFrontView() {
        addSubview(locationAndTimeView)
        addSubview(driveInfoView)

        locationAndTimeView.addSubview(locationLabel)
        locationAndTimeView.addSubview(timeLabel)

        driveInfoView.addSubview(statusImageView)
        driveInfoView.addSubview(statusLabel)

        addSubview(noDriveViewForPassenger)
        noDriveViewForPassenger.addSubview(noDriveImage)
        noDriveViewForPassenger.addSubview(noDriveComment)
    }

    private func setupConstraints() {
        locationAndTimeView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(20).priority(.high)
            make.width.lessThanOrEqualTo(350)
            make.height.equalToSuperview().dividedBy(2)
        }
        driveInfoView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(20).priority(.high)
            make.width.equalTo(locationAndTimeView)
            make.height.equalToSuperview().dividedBy(2)
        }
        locationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.lessThanOrEqualToSuperview().inset(55)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(locationLabel.snp.bottom).offset(4)
        }

        statusImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.lessThanOrEqualToSuperview().inset(30)
            make.width.equalTo(62)
            make.height.equalTo(88)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(statusImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        noDriveViewForPassenger.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20).priority(.high)
        }
        noDriveImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(62)
            make.height.equalTo(64)
        }
        noDriveComment.snp.makeConstraints { make in
            make.top.equalTo(noDriveImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    // TODO: - 실제 데이터로 변경
    private func settingData() {
        locationLabel.text = "해당 위치에"
        let locationText = NSMutableAttributedString(string: locationLabel.text ?? "")
        if let range1 = locationLabel.text?.range(of: "해당 위치") {
            let nsRange1 = NSRange(range1, in: locationLabel.text ?? "")
            locationText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        locationLabel.attributedText = locationText

        timeLabel.text = "몇 시까지 나가야 해요"
        let timeText = NSMutableAttributedString(string: timeLabel.text ?? "")
        if let range2 = timeLabel.text?.range(of: "몇 시") {
            let nsRange2 = NSRange(range2, in: timeLabel.text ?? "")
            timeText.addAttribute(NSAttributedString.Key.foregroundColor,
                                  value: UIColor.semantic.accPrimary as Any,
                                  range: nsRange2)
        }
        timeLabel.attributedText = timeText

        statusLabel.text = "운전자의 확인을 기다리고 있어요"
    }
}

// MARK: - 뒷면 뷰

final class PassengerBackView: UIView {

    private lazy var personImage: UIImageView = {
        let img = UIImage(systemName: "person.fill")
        let imageView = UIImageView(image: img)
        imageView.tintColor = UIColor.semantic.textPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var totalCrewMemeberLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.subhead3
        lbl.textColor = UIColor.semantic.textPrimary
        return lbl
    }()

    init() {
        super.init(frame: .zero)
        setupBackView()
        setupConstraints()
        settingData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBackView() {
        addSubview(personImage)
        addSubview(totalCrewMemeberLabel)
    }

    private func setupConstraints() {
        personImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
            make.width.height.equalTo(22)
        }
        totalCrewMemeberLabel.snp.makeConstraints { make in
            make.leading.equalTo(personImage.snp.trailing).offset(4)
            make.centerY.equalTo(personImage)
        }
    }

    // TODO: - 실제 데이터로 변경
    private func settingData() {
        totalCrewMemeberLabel.text = "\(crewData?.crews.count ?? 0)명"
    }
}
