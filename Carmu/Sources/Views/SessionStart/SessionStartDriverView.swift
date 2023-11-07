//
//  SessionStartDriverView.swift
//  Carmu
//
//  Created by 김태형 on 2023/10/12.
//

import UIKit

import SnapKit

final class SessionStartDriverView: UIView {

    private lazy var isFlipped = false
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.semantic.backgroundDefault
        return view
    }()

    // 앞면 뷰
    lazy var driverFrontView = DriverFrontView()
    // 뒷면 뷰
    private lazy var driverBackView = DriverBackView()

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
        driverFrontView.frame = bounds
        driverBackView.frame = bounds

    }
}

// MARK: - Layout Methods
extension SessionStartDriverView {

    private func setupUI() {
        addSubview(contentView)
        contentView.addSubview(driverFrontView)
        contentView.addSubview(driverBackView)
        driverBackView.isHidden = true

        layer.cornerRadius = 20
        layer.shadowColor = UIColor.semantic.accPrimary?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
    }
}

// MARK: - Actions
extension SessionStartDriverView {

    @objc private func flip() {
        isFlipped.toggle()

        let transitionOptions: UIView.AnimationOptions = isFlipped ? .transitionFlipFromLeft : .transitionFlipFromRight

        UIView.transition(with: contentView, duration: 0.4, options: transitionOptions, animations: {
            self.driverFrontView.isHidden = self.isFlipped
            self.driverBackView.isHidden = !self.isFlipped
        }, completion: nil)
    }
}

// MARK: - 앞면 뷰
final class DriverFrontView: UIView {
    private lazy var comment: UILabel = {
        let label = UILabel()

        let firstLine = NSMutableAttributedString(string: "오늘 함께할 크루원들", attributes: [
            .font: UIFont.carmuFont.headline1,
            .foregroundColor: UIColor.semantic.textPrimary as Any
        ])
        let secondLine = NSMutableAttributedString(string: "\n\n실시간 탑승여부 응답 정보입니다", attributes: [
            .font: UIFont.carmuFont.body2Long,
            .foregroundColor: UIColor.semantic.textBody as Any
        ])

        firstLine.append(secondLine)

        label.attributedText = firstLine
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    // /(총인원)에 대한 라벨
    private lazy var totalCrewMemeberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.subhead2
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    // 실시간 탑승 여부 인원에 대한 라벨
    lazy var todayCrewMemeberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.accPrimary
        return label
    }()

    private lazy var crewView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.layer.cornerRadius = 16
        return view
    }()

    // 당일에 운행이 없을 때 나타나는 뷰
    lazy var noDriveViewForDriver: UIView = {
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
    private lazy var noDriveComment: UILabel = {
        let label = UILabel()
        label.text = "오늘은 카풀을 운행하지 않아요"
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.negative
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupFrontView()
        setupConstraints()
        settingData()

        // TODO: - 데이터 수정 후 변경 -> session 여부에 따라 true, false로 변경하기
        noDriveViewForDriver.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFrontView() {
        addSubview(comment)
        addSubview(totalCrewMemeberLabel)
        addSubview(todayCrewMemeberLabel)
        addSubview(crewView)

        addSubview(noDriveViewForDriver)
        noDriveViewForDriver.addSubview(noDriveImage)
        noDriveViewForDriver.addSubview(noDriveComment)
    }

    private func setupConstraints() {
        comment.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
        }
        totalCrewMemeberLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
        }
        todayCrewMemeberLabel.snp.makeConstraints { make in
            make.top.equalTo(totalCrewMemeberLabel)
            make.centerY.equalTo(totalCrewMemeberLabel)
            make.trailing.equalTo(totalCrewMemeberLabel.snp.leading).offset(-4)
        }

        noDriveViewForDriver.snp.makeConstraints { make in
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
        totalCrewMemeberLabel.text = "/ \(crewData?.crews.count ?? 0)"
        todayCrewMemeberLabel.text = "1"
    }
}

// MARK: - 뒷면 뷰

final class DriverBackView: UIView {

    private lazy var personImage: UIImageView = {
        let image = UIImage(systemName: "person.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.semantic.textPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var totalCrewMemeberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    private lazy var stickImage: UIImageView = {
        let image = UIImage(named: "LocationStick")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var startLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "출발지"
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.textPrimary
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textPrimary
        label.backgroundColor = UIColor.theme.acuaTrans20
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()

    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = "출발"
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.theme.acua9
        label.textAlignment = .center
        return label
    }()

    private lazy var endLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "도착지"
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.textPrimary
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textPrimary
        label.backgroundColor = UIColor.theme.acuaTrans20
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()

    private lazy var endLabel: UILabel = {
        let label = UILabel()
        label.text = "도착"
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.theme.acua9
        label.textAlignment = .center
        return label
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
        addSubview(stickImage)

        addSubview(startLocationLabel)
        addSubview(startTimeLabel)
        addSubview(startLabel)

        addSubview(endLocationLabel)
        addSubview(endTimeLabel)
        addSubview(endLabel)
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
        stickImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().inset(73)
            make.bottom.lessThanOrEqualToSuperview().inset(53).priority(.high)
            make.height.lessThanOrEqualTo(296).priority(.low)
            make.width.equalTo(24)
        }

        startLocationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.top.lessThanOrEqualTo(stickImage)
            make.trailing.equalTo(stickImage.snp.leading).offset(-32).priority(.high)
            make.width.lessThanOrEqualTo(92)
        }
        startTimeLabel.snp.makeConstraints { make in
            make.leading.lessThanOrEqualTo(stickImage.snp.trailing).offset(32)
            make.top.equalTo(startLocationLabel)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        startLabel.snp.makeConstraints { make in
            make.leading.equalTo(startTimeLabel.snp.trailing).offset(8)
            make.top.equalTo(startLocationLabel)
        }

        endLocationLabel.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(stickImage)
            make.leading.trailing.equalTo(startLocationLabel)
            make.width.equalTo(startLocationLabel)
        }
        endTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(startTimeLabel)
            make.bottom.equalTo(endLocationLabel)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        endLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(startLabel)
            make.bottom.equalTo(endLocationLabel)
        }
    }

    // TODO: - 실제 데이터로 변경
    private func settingData() {
        totalCrewMemeberLabel.text = "\(crewData?.crews.count ?? 0)명"
    }
}
