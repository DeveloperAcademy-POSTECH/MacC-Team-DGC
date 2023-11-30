//
//  MapDetailView.swift
//  Carmu
//
//  Created by 허준혁 on 10/22/23.
//

import UIKit

import SnapKit

final class MapDetailView: UIView {

    let firebaseManager = FirebaseManager()

    let titleLabel: UILabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        label.backgroundColor = UIColor.semantic.backgroundSecond
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.subhead3
        label.textAlignment = .left
        return label
    }()

    let giveUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.semantic.negative
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.setBackgroundColor(UIColor.semantic.negativePressed ?? .systemRed, forState: .highlighted)
        button.titleLabel?.font = UIFont.carmuFont.headline1
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()

    let noticeLateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.semantic.accPrimary
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.setBackgroundColor(UIColor.semantic.accPrimaryPressed ?? .systemRed, forState: .highlighted)
        button.titleLabel?.font = UIFont.carmuFont.headline1
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
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

    let finishShuttleButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.semantic.accPrimary
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.setBackgroundColor(UIColor.semantic.accPrimaryPressed ?? .systemRed, forState: .highlighted)
        button.titleLabel?.font = UIFont.carmuFont.headline2
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()

    private var crew: Crew? {
        didSet {
            changeTimeLabel()
        }
    }

    init(crew: Crew) {
        self.crew = crew
        super.init(frame: .zero)
        backgroundColor = UIColor.semantic.backgroundDefault
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        showTitleLabel()
        initBottomButton()
        changeBottomButton()
        if firebaseManager.isDriver(crewData: crew) {
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

    private func initBottomButton() {
        let bottomPadding = 48
        let outsidePadding = 20
        let insidePadding = frame.size.width / 2 + 5
        let height = 60

        addSubview(giveUpButton)
        giveUpButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(outsidePadding)
            make.trailing.equalToSuperview().inset(insidePadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
            make.height.equalTo(height)
        }

        addSubview(noticeLateButton)
        noticeLateButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(insidePadding)
            make.trailing.equalToSuperview().inset(outsidePadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
            make.height.equalTo(height)
        }

        addSubview(finishShuttleButton)
        finishShuttleButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(outsidePadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
            make.height.equalTo(height)
        }
    }

    func changeBottomButton(isDriverArriaved: Bool = false) {
        if isDriverArriaved {
            giveUpButton.hideButton()
            noticeLateButton.hideButton()
            finishShuttleButton.showButton(title: "운행 종료하기", buttonColor: UIColor.semantic.accPrimary)
        } else {
            giveUpButton.showButton(title: "포기하기", buttonColor: UIColor.semantic.negative)
            noticeLateButton.showButton(title: "지각 알리기", buttonColor: UIColor.semantic.accPrimary)
            finishShuttleButton.hideButton()
        }
    }

    private func changeTimeLabel() {
        guard let crew = crew, let myPickUpLocation = FirebaseManager().myPickUpLocation(crew: crew) else { return }
        guard let splitted = myPickUpLocation.arrivalTime?.toString24HourClock.split(separator: ":") else { return }
        let minutes = (UInt(splitted[0]) ?? 0) * 60 + (UInt(splitted[1]) ?? 0) + crew.lateTime
        pickUpTimeLabel.text = "\(minutes / 60):\(minutes % 60)"
        pickUpTimeLabel.textColor = crew.lateTime > 0 ? UIColor.semantic.negative : UIColor.semantic.accPrimary
        lateTimeLabel.text = "(+\(crew.lateTime)분)"
    }

    func setLateTime(crew: Crew) {
        self.crew = crew
    }
}
