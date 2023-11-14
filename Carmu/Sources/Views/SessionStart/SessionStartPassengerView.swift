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
    private lazy var sessionStartBackView = SessionStartBackView()

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
        sessionStartBackView.frame = bounds

    }
}

// MARK: - Layout Methods
extension SessionStartPassengerView {

    private func setupUI() {
        addSubview(contentView)
        contentView.addSubview(passengerFrontView)
        contentView.addSubview(sessionStartBackView)
        sessionStartBackView.isHidden = true

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
            self.sessionStartBackView.isHidden = !self.isFlipped
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
        let label = UILabel()
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var carpoolPlanLabel1: CarpoolPlanLabel = {
        let label = CarpoolPlanLabel()
        return label
    }()

    // 운행 여부를 알려주는 뷰
    private lazy var driveInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.layer.cornerRadius = 16
        return view
    }()
    lazy var statusImageView: UIImageView = {
        let image = UIImage(named: "HourglassBlinker")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.textPrimary
        label.textAlignment = .center
        return label
    }()

    // 당일에 운행이 없을 때 나타나는 뷰
    lazy var noDriveViewForPassenger: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.layer.cornerRadius = 16
        return view
    }()
    private lazy var noDriveImage: UIImageView = {
        let image = UIImage(named: "NoSessionBlinker")
        let imgView = UIImageView(image: image)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    lazy var noDriveComment: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.subhead3
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var carpoolPlanLabel2: CarpoolPlanLabel = {
        let label = CarpoolPlanLabel()
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupFrontView()
        setupConstraints()

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
        locationAndTimeView.addSubview(carpoolPlanLabel1)

        driveInfoView.addSubview(statusImageView)
        driveInfoView.addSubview(statusLabel)

        addSubview(noDriveViewForPassenger)
        noDriveViewForPassenger.addSubview(noDriveImage)
        noDriveViewForPassenger.addSubview(noDriveComment)
        noDriveViewForPassenger.addSubview(carpoolPlanLabel2)
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
        carpoolPlanLabel1.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
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
        carpoolPlanLabel2.snp.makeConstraints { make in
            make.top.equalTo(noDriveComment.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    func settingPassengerFrontData(crewData: Crew?) {
        guard let crewData = crewData else { return }

        locationLabel.text = getPassengerLocation(crewData: crewData)
        let locationText = NSMutableAttributedString(string: locationLabel.text ?? "")
        if let range1 = locationLabel.text?.range(of: "해당 위치") {
            let nsRange1 = NSRange(range1, in: locationLabel.text ?? "")
            locationText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        locationLabel.attributedText = locationText

        timeLabel.text = "\(getPassengerTime(crewData: crewData))까지 나가야 해요"
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

    // crewData를 기반으로 위치 불러오기
    private func getPassengerLocation(crewData: Crew?) -> String {
        guard let crewData = crewData else { return "" }
        guard let currentUserIdentifier = KeychainItem.currentUserIdentifier else { return "" }
        let locations = [crewData.startingPoint,
                         crewData.stopover1,
                         crewData.stopover2,
                         crewData.stopover3]

        for location in locations {
            if let location = location, location.crews?.description == currentUserIdentifier {
                // 현재 사용자가 타는 지점을 찾은 경우 해당 지점의 이름 반환
                return location.name ?? "목적지"
            }
        }
        // 만약 없다면
        return ""
    }

    // crewData를 기반으로 시간 불러오기
    private func getPassengerTime(crewData: Crew?) -> String {
        guard let crewData = crewData else { return "00:00" }
        guard let currentUserIdentifier = KeychainItem.currentUserIdentifier else { return "00:00" }
        let locations = [crewData.startingPoint,
                         crewData.stopover1,
                         crewData.stopover2,
                         crewData.stopover3]
        for location in locations {
            if let location = location, location.crews?.description == currentUserIdentifier {
                let arrivalTime = location.arrivalTime
                print("arrivalTime ", arrivalTime as Any)

                return arrivalTime?.description ?? "00:00"
            }
        }
        return "없음 00:00"
    }
}
