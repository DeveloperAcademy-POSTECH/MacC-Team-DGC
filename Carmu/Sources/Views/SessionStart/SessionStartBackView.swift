//
//  SessionStartBackView.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/08.
//

import UIKit

import SnapKit

// 뒷면 뷰
final class SessionStartBackView: UIView {

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

    // 경유지 관련
    private lazy var stopOver1LocationLabel: UILabel = {
        let label = UILabel()

        // 이미지 추가
        let imageAttachment = NSTextAttachment()
        if let image = UIImage(systemName: "circle.fill") {
            let tintedImage = image.withTintColor(UIColor.theme.blue3 ?? UIColor.systemBlue)
            imageAttachment.image = tintedImage
        }

        // 이미지 크기 변경
        let imageSize = CGSize(width: 8, height: 8)
        imageAttachment.bounds = CGRect(origin: .zero, size: imageSize)

        // 텍스트 추가
        let text = " 경유지1 대표 명칭"
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(NSAttributedString(attachment: imageAttachment))
        attributedText.append(NSAttributedString(string: text))

        // label에 attributedText 설정
        label.attributedText = attributedText

        // 나머지 속성 설정
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textPrimary
        label.textAlignment = .center

        return label
    }()
    private lazy var stopOver1TimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textTertiary
        return label
    }()
    private lazy var stopOver1Label: UILabel = {
        let label = UILabel()
        label.text = "도착"
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.semantic.textTertiary
        label.textAlignment = .center
        return label
    }()
    private lazy var stopOver2LocationLabel: UILabel = {
        let label = UILabel()

        // 이미지 추가
        let imageAttachment = NSTextAttachment()
        if let image = UIImage(systemName: "circle.fill") {
            let tintedImage = image.withTintColor(UIColor.theme.blue3 ?? UIColor.systemBlue)
            imageAttachment.image = tintedImage
        }

        // 이미지 크기 변경
        let imageSize = CGSize(width: 8, height: 8)
        imageAttachment.bounds = CGRect(origin: .zero, size: imageSize)

        // 텍스트 추가
        let text = " 경유지2 대표 명칭"
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(NSAttributedString(attachment: imageAttachment))
        attributedText.append(NSAttributedString(string: text))

        // label에 attributedText 설정
        label.attributedText = attributedText

        // 나머지 속성 설정
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textPrimary
        label.textAlignment = .center

        return label
    }()
    private lazy var stopOver2TimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textTertiary
        return label
    }()
    private lazy var stopOver2Label: UILabel = {
        let label = UILabel()
        label.text = "도착"
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.semantic.textTertiary
        label.textAlignment = .center
        return label
    }()
    private lazy var stopOver3LocationLabel: UILabel = {
        let label = UILabel()

        // 이미지 추가
        let imageAttachment = NSTextAttachment()
        if let image = UIImage(systemName: "circle.fill") {
            let tintedImage = image.withTintColor(UIColor.theme.blue3 ?? UIColor.systemBlue)
            imageAttachment.image = tintedImage
        }

        // 이미지 크기 변경
        let imageSize = CGSize(width: 8, height: 8)
        imageAttachment.bounds = CGRect(origin: .zero, size: imageSize)

        // 텍스트 추가
        let text = " 경유지3 대표 명칭"
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(NSAttributedString(attachment: imageAttachment))
        attributedText.append(NSAttributedString(string: text))

        // label에 attributedText 설정
        label.attributedText = attributedText

        // 나머지 속성 설정
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textPrimary
        label.textAlignment = .center

        return label
    }()
    private lazy var stopOver3TimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.carmuFont.subhead1
        label.textColor = UIColor.semantic.textTertiary
        return label
    }()
    private lazy var stopOver3Label: UILabel = {
        let label = UILabel()
        label.text = "도착"
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.semantic.textTertiary
        label.textAlignment = .center
        return label
    }()

    private lazy var dotImage1: UIImageView = {
        let image = UIImage(systemName: "circle.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.semantic.backgroundDefault
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var dotImage2: UIImageView = {
        let image = UIImage(systemName: "circle.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.semantic.backgroundDefault
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var dotImage3: UIImageView = {
        let image = UIImage(systemName: "circle.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.semantic.backgroundDefault
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupBackView()
        setupConstraints()
        checkStopOverPoint()
        settingData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: - 실제 데이터로 변경
    private func settingData() {
        totalCrewMemeberLabel.text = "\(crewData?.crews.count ?? 0)명"
    }

    // TODO: - 실제 데이터로 변경
    private func checkStopOverPoint() {
        if crewData?.stopover1 == nil {
            return
        } else {
            settingStopOverPoints()
        }
    }

    // 경유지 관련 설정
    private func settingStopOverPoints() {

        // TODO: - 실제 데이터로 변경
        if crewData?.stopover1 != nil, crewData?.stopover2 == nil, crewData?.stopover3 == nil {
            oneStopOverPoint()
        } else if crewData?.stopover1 != nil, crewData?.stopover2 != nil, crewData?.stopover3 == nil {
            twoStopOverPoints()
        } else if crewData?.stopover1 != nil, crewData?.stopover2 != nil, crewData?.stopover3 != nil {
            threeStopOverPoints()
        }
    }
}

// MARK: - BackView Layouts

extension SessionStartBackView {

    // 기본 컴포넌트들
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

    // 경유지1만 있을 때
    private func oneStopOverPoint() {

        setupOneStopOverUI()

        dotImage1.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(8)
        }

        setupOneStopOverConstraints()
    }
    // 경유지2까지 있을 때
    private func twoStopOverPoints() {

        setupTwoStopOverUI()

        dotImage1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stickImage).dividedBy(0.5)
            make.width.height.equalTo(8)
        }
        dotImage2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stickImage).dividedBy(1.4)
            make.width.height.equalTo(8)
        }

        setupTwoStopOverConstraints()
    }
    // 경유지3까지 있을 때
    private func threeStopOverPoints() {

        setupThreeStopOverUI()

        dotImage2.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(8)
        }
        dotImage1.snp.makeConstraints { make in
            make.centerX.equalTo(dotImage2)
            make.top.equalTo(dotImage2).dividedBy(1.4)
            make.width.height.equalTo(8)
        }
        dotImage3.snp.makeConstraints { make in
            make.centerX.equalTo(dotImage2)
            make.bottom.equalTo(dotImage2).dividedBy(0.8)
            make.width.height.equalTo(8)
        }

        setupThressStopOverConstraints()
    }

    // 경유지들 addSubview
    private func setupOneStopOverUI() {
        addSubview(dotImage1)
        addSubview(stopOver1LocationLabel)
        addSubview(stopOver1TimeLabel)
        addSubview(stopOver1Label)
    }
    private func setupTwoStopOverUI() {
        setupOneStopOverUI()
        addSubview(dotImage2)
        addSubview(stopOver2LocationLabel)
        addSubview(stopOver2TimeLabel)
        addSubview(stopOver2Label)
    }
    private func setupThreeStopOverUI() {
        setupTwoStopOverUI()
        addSubview(dotImage3)
        addSubview(stopOver3LocationLabel)
        addSubview(stopOver3TimeLabel)
        addSubview(stopOver3Label)
    }

    private func setupOneStopOverConstraints() {
        stopOver1LocationLabel.snp.makeConstraints { make in
            make.leading.equalTo(startLocationLabel)
            make.top.equalTo(dotImage1)
        }
        stopOver1TimeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(startTimeLabel)
            make.top.equalTo(dotImage1)
        }
        stopOver1Label.snp.makeConstraints { make in
            make.leading.equalTo(startLabel)
            make.top.equalTo(dotImage1)
        }
    }
    private func setupTwoStopOverConstraints() {
        setupOneStopOverConstraints()
        stopOver2LocationLabel.snp.makeConstraints { make in
            make.leading.equalTo(startLocationLabel)
            make.top.equalTo(dotImage2)
        }
        stopOver2TimeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(startTimeLabel)
            make.top.equalTo(dotImage2)
        }
        stopOver2Label.snp.makeConstraints { make in
            make.leading.equalTo(startLabel)
            make.top.equalTo(dotImage2)
        }
    }
    private func setupThressStopOverConstraints() {
        setupTwoStopOverConstraints()
        stopOver3LocationLabel.snp.makeConstraints { make in
            make.leading.equalTo(startLocationLabel)
            make.top.equalTo(dotImage3)
        }
        stopOver3TimeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(startTimeLabel)
            make.top.equalTo(dotImage3)
        }
        stopOver3Label.snp.makeConstraints { make in
            make.leading.equalTo(startLabel)
            make.top.equalTo(dotImage3)
        }
    }
}
