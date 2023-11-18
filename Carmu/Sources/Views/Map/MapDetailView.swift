//
//  MapDetailView.swift
//  Carmu
//
//  Created by 허준혁 on 10/22/23.
//

import UIKit

import SnapKit

final class MapDetailView: UIView {

    let titleLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        label.backgroundColor = UIColor.semantic.backgroundSecond
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.subhead3
        label.textAlignment = .left
        return label
    }()

    let giveUpButton: UIButton = {
        var config = UIButton.Configuration.filled()

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.carmuFont.headline2
        titleContainer.foregroundColor = UIColor.semantic.textSecondary

        config.attributedTitle = AttributedString("포기하기", attributes: titleContainer)
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.semantic.negative

        let button = UIButton(configuration: config)
        return button
    }()

    let noticeLateButton: UIButton = {
        var config = UIButton.Configuration.filled()

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.carmuFont.headline2
        titleContainer.foregroundColor = UIColor.semantic.textSecondary

        config.attributedTitle = AttributedString("지각 알리기", attributes: titleContainer)
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.semantic.accPrimary

        let button = UIButton(configuration: config)
        return button
    }()

    lazy var myPickUpLocationTitleLabel = {
        let label = UILabel()
        label.text = "내 탑승위치"
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    lazy var pickUpLocationAddressLabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    lazy var myPickUpTimeTitleLabel = {
        let label = UILabel()
        label.text = "내 탑승시간 (지연시간)"
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    lazy var pickUpTimeLabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline2
        label.textColor = UIColor.semantic.accPrimary
        return label
    }()

    lazy var lateTimeLabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline2
        label.textColor = UIColor.semantic.textPrimary
        return label
    }()

    private let latenessTitleLabel = {
        let label = UILabel()
        label.text = "탑승자들 지각 현황"
        label.font = UIFont.carmuFont.subhead2
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    lazy var crewScrollView = {
        let view = CrewScrollView()
        return view
    }()

    let finishCarpoolButton = {
        var config = UIButton.Configuration.filled()

        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.carmuFont.headline2
        titleContainer.foregroundColor = UIColor.semantic.textSecondary

        config.attributedTitle = AttributedString("카풀 종료하기", attributes: titleContainer)
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.semantic.accPrimary

        let button = UIButton(configuration: config)
        return button
    }()

    private let isDriver = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.semantic.backgroundDefault
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        showTitleLabel()
        showBottomButtons()
        if isDriver {
            showDetailForDriver()
        } else {
            showDetailForCrew()
        }
    }

    private func showTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
    }

    private func showDetailForDriver() {
        let padding = 20

        addSubview(latenessTitleLabel)
        latenessTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.leading.equalToSuperview().inset(padding)
        }

        addSubview(crewScrollView)
        crewScrollView.snp.makeConstraints { make in
            make.top.equalTo(latenessTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.bottom.equalTo(giveUpButton.snp.top).offset(-padding)
        }
    }

    private func showDetailForCrew() {
        let outsidePadding = 20
        let insidePadding = frame.size.width / 2 + 5

        addSubview(myPickUpLocationTitleLabel)
        myPickUpLocationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(outsidePadding)
            make.trailing.equalToSuperview().inset(insidePadding)
        }

        addSubview(pickUpLocationAddressLabel)
        pickUpLocationAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(myPickUpLocationTitleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(outsidePadding)
            make.trailing.equalToSuperview().inset(insidePadding)
        }

        addSubview(myPickUpTimeTitleLabel)
        myPickUpTimeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(myPickUpLocationTitleLabel)
            make.leading.equalToSuperview().inset(insidePadding)
            make.trailing.equalToSuperview().inset(outsidePadding)
        }

        addSubview(pickUpTimeLabel)
        pickUpTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(myPickUpTimeTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(insidePadding)
        }

        addSubview(lateTimeLabel)
        lateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(pickUpTimeLabel)
            make.leading.equalTo(pickUpTimeLabel.snp.trailing).offset(3)
        }
    }

    private func showBottomButtons() {
        let bottomPadding = 48
        let outsidePadding = 20
        let insidePadding = frame.size.width / 2 + 5

        addSubview(giveUpButton)
        giveUpButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(outsidePadding)
            make.trailing.equalToSuperview().inset(insidePadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
        }

        addSubview(noticeLateButton)
        noticeLateButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(insidePadding)
            make.trailing.equalToSuperview().inset(outsidePadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
        }
    }

    func showFinishCarpoolButton() {
        // '카풀 종료하기' 버튼 표시 전에 기존 버튼들 제거
        giveUpButton.removeFromSuperview()
        noticeLateButton.removeFromSuperview()

        let padding = 20

        addSubview(finishCarpoolButton)
        finishCarpoolButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(padding)
            make.bottom.equalToSuperview().inset(48)
        }

        // 스크롤뷰 제약조건 '카풀 종료하기' 버튼에 맞춰 재정의
        crewScrollView.snp.remakeConstraints { make in
            make.top.equalTo(latenessTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.bottom.equalTo(finishCarpoolButton.snp.top).offset(-padding)
        }
    }
}
