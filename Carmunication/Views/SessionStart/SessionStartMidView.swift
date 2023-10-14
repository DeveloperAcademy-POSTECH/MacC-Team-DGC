//
//  SessionStartMidView.swift
//  Carmunication
//
//  Created by 김태형 on 2023/10/12.
//

import UIKit

import SnapKit

final class SessionStartMidView: UIView {

    let groupNameView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.blue8
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    private var groupNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.carmuFont.headline1
        lbl.textAlignment = .center
        lbl.text = "---"
        return lbl
    }()
    let whiteCircleImageViewLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .white
        return imageView
    }()
    let whiteCircleImageViewRight: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .white
        return imageView
    }()

    // 기존의 journeySummaryView와 동일
    let summaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    // 오늘의 날짜
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.theme.darkblue4
        lbl.font = UIFont.carmuFont.body2Long
        return lbl
    }()

    // 출발, 도착 정보
    let startLocationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.headline2
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.numberOfLines = 0
        lbl.text = "그룹이 없음"    // TODO: - 그룹 유무에 따른 변경
        return lbl
    }()

    let startTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.headline1
        lbl.textColor = UIColor.theme.blue4
        lbl.text = "00 : 00"    // TODO: - 그룹 유무에 따른 변경
        return lbl
    }()

    let arrowLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "→"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.textColor = .black
        return lbl
    }()

    let endLocationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.headline2
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.numberOfLines = 0
        lbl.text = "그룹이 없음"    // TODO: - 그룹 유무에 따른 변경
        return lbl
    }()

    let endTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.headline1
        lbl.textColor = UIColor.theme.blue4
        lbl.text = "00 : 00"    // TODO: - 그룹 유무에 따른 변경
        return lbl
    }()

    // 요일 및 인원 수
    let dayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.semantic.textDisableBT?.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    let calendarImage: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(systemName: "calendar") {
            imageView.image = image
            imageView.tintColor = UIColor.semantic.accPrimary
        }
        return imageView
    }()
    let dayLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.font = UIFont.carmuFont.body2Long
        return lbl
    }()

    let personCountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.semantic.textDisableBT?.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    let personImage: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(systemName: "person.2") {
            imageView.image = image
            imageView.tintColor = UIColor.semantic.accPrimary
        }
        return imageView
    }()
    let personLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.font = UIFont.carmuFont.body2Long
        return lbl
    }()

    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.blue3
        return view
    }()

    let commentUnderLineView: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.body3Long
        lbl.textColor = UIColor.semantic.textBody
        lbl.textAlignment = .center
//        lbl.text = "세션관리에서 여정을 만들어 보세요."    // TODO: - 그룹 유무에 따른 변경
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setTodayDate()
        setDayViewComponent()
        setPersonCountViewComponent()
        setupGroupData()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        setTodayDate()
        setDayViewComponent()
        setPersonCountViewComponent()
        setupGroupData()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var dayLocationPadding = 82
        var viewLinePadding = -20
        let padding = summaryView.frame.height / 5

        // 사이즈가 작을 때 padding 변경
        if summaryView.frame.height > 0 && summaryView.frame.height <= 300 {
            dayLocationPadding = 42
            viewLinePadding = -12
        }

        startLocationLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(dayLocationPadding)
        }
        endLocationLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(dayLocationPadding)
        }

        lineView.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().inset(padding)
        }

        dayView.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(lineView.snp.top).inset(-12)
            make.bottom.lessThanOrEqualTo(lineView).inset(viewLinePadding)
        }
        personCountView.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(lineView.snp.top).inset(-12)
            make.bottom.lessThanOrEqualTo(lineView).inset(viewLinePadding)
        }

        commentUnderLineView.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().inset(summaryView.frame.height / 10)
        }

    }

    private func setupUI() {

        addSubview(groupNameView)

        groupNameView.addSubview(groupNameLabel)
        groupNameView.addSubview(whiteCircleImageViewLeft)
        groupNameView.addSubview(whiteCircleImageViewRight)

        addSubview(summaryView)

        summaryView.addSubview(dateLabel)
        summaryView.addSubview(startLocationLabel)
        summaryView.addSubview(startTime)
        summaryView.addSubview(arrowLabel)
        summaryView.addSubview(endLocationLabel)
        summaryView.addSubview(endTime)
        summaryView.addSubview(dayView)
        dayView.addSubview(calendarImage)
        dayView.addSubview(dayLabel)
        summaryView.addSubview(personCountView)
        personCountView.addSubview(personImage)
        personCountView.addSubview(personLabel)

        summaryView.addSubview(lineView)
        summaryView.addSubview(commentUnderLineView)
    }

    private func setupConstraints() {

        groupNameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        groupNameLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        whiteCircleImageViewLeft.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalTo(groupNameLabel)
            make.width.height.equalTo(10)
        }
        whiteCircleImageViewRight.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(groupNameLabel)
            make.width.height.equalTo(10)
        }

        summaryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.lessThanOrEqualTo(groupNameLabel.snp.bottom).inset(-12)
            make.bottom.lessThanOrEqualToSuperview().inset(20).priority(.high)
            make.bottom.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.top.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        lineView.snp.makeConstraints { make in
            make.leading.trailing.lessThanOrEqualToSuperview().inset(20)
            make.height.equalTo(1)
        }

        commentUnderLineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }

        startLocationLabel.snp.makeConstraints { make in
            make.leading.lessThanOrEqualToSuperview().inset(20)
            make.width.lessThanOrEqualTo(115)
        }
        arrowLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(startLocationLabel)
        }
        endLocationLabel.snp.makeConstraints { make in
            make.trailing.trailing.lessThanOrEqualToSuperview().inset(20)
            make.width.lessThanOrEqualTo(115)
        }

        startTime.snp.makeConstraints { make in
            make.leading.equalTo(startLocationLabel)
            make.bottom.lessThanOrEqualTo(dayView.snp.top).inset(-40)
        }
        endTime.snp.makeConstraints { make in
            make.leading.equalTo(endLocationLabel)
            make.bottom.lessThanOrEqualTo(personCountView.snp.top).inset(-40)
        }

        dayView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(40)
            make.width.lessThanOrEqualTo(137)
            make.leading.equalTo(startLocationLabel)
        }
        personCountView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(40)
            make.width.lessThanOrEqualTo(137)
            make.trailing.equalTo(endLocationLabel)
        }
    }

    private func setTodayDate() {

        let today = Date()
        let formattedDate = Date.formattedDate(from: today)
        dateLabel.text = formattedDate
    }

    private func setDayViewComponent() {

        dayLabel.text = groupData == nil ? "---" : "주중 (월 ~ 금)" // TODO: - Text 변경
        calendarImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        dayLabel.snp.makeConstraints { make in
            make.leading.lessThanOrEqualTo(calendarImage.snp.trailing).inset(-10)
            make.centerY.equalToSuperview()
        }
    }

    private func setPersonCountViewComponent() {

        personImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        personLabel.snp.makeConstraints { make in
            make.leading.lessThanOrEqualTo(personImage.snp.trailing).inset(-10)
            make.centerY.equalToSuperview()
        }
    }

    private func setupGroupData() {

        // 그룹이 하나 이상 있을 때 나타내는 정보들
        if groupData != nil {

            // TODO: - 데이터 변경
            // TODO: - 시간 형식 변경
            // TODO: - 그룹이 없을 때 경우 설정
            groupNameLabel.text = groupData?.first?.groupName
            startLocationLabel.text = groupData?.first?.points?.first?.pointName
            endLocationLabel.text = groupData?.first?.points?.last?.pointName
            startTime.text = "09 : 00"
            endTime.text = "09 : 30"
            if let count = groupData?.first?.crewList?.count {
                personLabel.text = "\(count) 명"
            }
            commentUnderLineView.text = "오늘도 즐거운 여정을 시작해 보세요!"
        } else {
            commentUnderLineView.text = "세션관리에서 여정을 만들어 보세요."
        }
    }
}
