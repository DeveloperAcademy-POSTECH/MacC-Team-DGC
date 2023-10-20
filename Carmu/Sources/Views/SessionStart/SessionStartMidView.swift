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
        setupDataConstraints()
        setTodayDate()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
            make.bottom.lessThanOrEqualTo(lineView.snp.top).offset(-12)
            make.bottom.lessThanOrEqualTo(lineView).inset(viewLinePadding)
        }
        personCountView.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(lineView.snp.top).offset(-12)
            make.bottom.lessThanOrEqualTo(lineView).inset(viewLinePadding)
        }

        commentUnderLineView.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().inset(summaryView.frame.height / 10)
        }

    }
}

// MARK: - Layout Methods
extension SessionStartMidView {

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

    // GroupNameView를 제외한 데이터가 필요하지 않은 부분에 대한 Constraints
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
            make.top.lessThanOrEqualTo(groupNameLabel.snp.bottom).offset(12)
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
    }

    // 데이터가 들어있는 가운데 부분에 관한 Constraints
    private func setupDataConstraints() {
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
            make.bottom.lessThanOrEqualTo(dayView.snp.top).offset(-40)
        }
        endTime.snp.makeConstraints { make in
            make.leading.equalTo(endLocationLabel)
            make.bottom.lessThanOrEqualTo(personCountView.snp.top).offset(-40)
        }

        dayView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(40)
            make.width.lessThanOrEqualTo(137)
            make.leading.equalTo(startLocationLabel)
        }
        calendarImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        dayLabel.snp.makeConstraints { make in
            make.leading.lessThanOrEqualTo(calendarImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }

        personCountView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(40)
            make.width.lessThanOrEqualTo(137)
            make.trailing.equalTo(endLocationLabel)
        }
        personImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        personLabel.snp.makeConstraints { make in
            make.leading.lessThanOrEqualTo(personImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }

    private func setTodayDate() {

        let today = Date()
        let formattedDate = Date.formattedDate(from: today)
        dateLabel.text = formattedDate
    }
}

// MARK: - Data Methods
extension SessionStartMidView {

    // 그룹별 나타나는 데이터를 보여주는 메서드
    func setupGroupData(_ selectedGroup: Group?) {
        if let selectedGroup = selectedGroup {

            // TODO: - 데이터 변경
            // TODO: - 시간 형식 변경
            // TODO: - 그룹이 없을 때 경우 설정
            groupNameLabel.text = selectedGroup.groupName
            dayLabel.text = "주중 (월 ~ 금)"
            startLocationLabel.text = selectedGroup.crewAndPoint?.first?.1.pointName
            endLocationLabel.text = selectedGroup.crewAndPoint?.last?.1.pointName
            startTime.text = Date.formatTime(selectedGroup.crewAndPoint?.first?.1.pointArrivalTime)
            endTime.text = Date.formatTime(selectedGroup.crewAndPoint?.last?.1.pointArrivalTime)
            if let count = selectedGroup.crewAndPoint?.count {
                personLabel.text = "\(count) 명"
            }
            commentUnderLineView.text = "오늘도 즐거운 여정을 시작해 보세요!"
            groupNameLabel.text = selectedGroup.groupName

        } else {
            // 선택한 그룹 데이터가 없을 때에 대한 처리
            // 예를 들어, 빈 데이터로 초기화 또는 다른 처리 수행
            dayLabel.text = "---"
            commentUnderLineView.text = "세션관리에서 여정을 만들어 보세요."
        }
    }
}
