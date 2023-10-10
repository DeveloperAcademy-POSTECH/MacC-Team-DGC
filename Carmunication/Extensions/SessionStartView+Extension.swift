//
//  SessionStartView+Extension.swift
//  Carmunication
//
//  Created by 김태형 on 2023/10/09.
//

import UIKit

import SnapKit

extension SessionStartView {

    func setTodayDate() {

        // 현재 날짜를 가져와서 원하는 형식으로 변환
        let today = Date()
        let formattedDate = Date.formattedDate(from: today)

        // 변환된 날짜를 UILabel에 표시
        let dateLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = formattedDate
            lbl.textColor = ColorTheme().blue8
            lbl.font = CarmuFont().body2Long
            return lbl
        }()

        journeySummaryView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(journeySummaryView).inset(20)
        }

        // 여정 요약 (중앙 부분)
        if groupData == nil {
            let comment: UILabel = {
                let lbl = UILabel()
                lbl.text = "초대하거나 받은 여정이 없어요...\n친구와 함께 여정을 시작해 보세요!"
                lbl.font = CarmuFont().headline1
                lbl.textAlignment = .center
                lbl.textColor = SemanticColor().textBody
                lbl.numberOfLines = 0
                return lbl
            }()

            journeySummaryView.addSubview(comment)
            comment.snp.makeConstraints { make in
                make.centerX.equalTo(journeySummaryView)
                make.top.equalTo(journeySummaryView).inset(80)
            }
        } else {
            setRouteComponent()
        }
    }

    func setDayAndPerson() {
        setDayViewComponent()
        setPersonCountViewComponent()

        journeySummaryView.addSubview(dayView)
        dayView.snp.makeConstraints { make in
            make.leading.equalTo(journeySummaryView).inset(12)
            make.bottom.equalTo(journeySummaryView).inset(70)
            make.height.equalTo(40) // 높이를 설정할 수 있습니다.
        }

        journeySummaryView.addSubview(personCountView)
        personCountView.snp.makeConstraints { make in
            make.trailing.equalTo(journeySummaryView).inset(12)
            make.bottom.equalTo(journeySummaryView).inset(70)
            make.height.equalTo(40)
            make.width.equalTo(dayView.snp.width)
        }
        // 크기를 같게 설정한 뒤, 두 뷰 사이의 padding을 10 추가
        dayView.snp.makeConstraints { make in
            make.trailing.equalTo(personCountView.snp.leading).offset(-10)
        }
    }

    func setDayViewComponent() {
        let calendarImage: UIImageView = {
            let imageView = UIImageView()
            if let image = UIImage(systemName: "calendar") {
                imageView.image = image
                imageView.tintColor = SemanticColor().accPrimary
            }
            return imageView
        }()
        let dayLabel: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.textColor = SemanticColor().textPrimary
            lbl.font = CarmuFont().body2Long
            lbl.text = groupData == nil ? "---" : "주중 (월 ~ 금)"
            return lbl
        }()

        dayView.addSubview(calendarImage)
        calendarImage.snp.makeConstraints { make in
            make.leading.equalTo(dayView).offset(12)
            make.centerY.equalTo(dayView)
        }
        dayView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(dayView)
        }
    }

    func setPersonCountViewComponent() {
        let personImage: UIImageView = {
            let imageView = UIImageView()
            if let image = UIImage(systemName: "person.2") {
                imageView.image = image
                imageView.tintColor = SemanticColor().accPrimary
            }
            return imageView
        }()
        let personLabel: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.textColor = SemanticColor().textPrimary
            lbl.font = CarmuFont().body2Long
            lbl.text = groupData == nil ? "---" : "n 명"
            return lbl
        }()

        personCountView.addSubview(personImage)
        personImage.snp.makeConstraints { make in
            make.leading.equalTo(personCountView).offset(12)
            make.centerY.equalTo(personCountView)
        }
        personCountView.addSubview(personLabel)
        personLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(personCountView)
        }
    }

    private func setRouteComponent() {

        // 출발 부분 컴포넌트
        setStartRouteComponent()

        // 도착 부분 컴포넌트
        setEndRouteComponent()
    }

    private func setStartRouteComponent() {

        let startLocation: UILabel = {
            let lbl = UILabel()
            lbl.text = "양덕" // 출발지
            lbl.textColor = .black
            lbl.font = CarmuFont().display2
            lbl.textAlignment = .center
            return lbl
        }()

        let startTime: UILabel = {
            let lbl = UILabel()
            lbl.text = "00 : 00"
            lbl.textColor = ColorTheme().darkblue4
            lbl.font = CarmuFont().body3
            lbl.textAlignment = .center
            return lbl
        }()

        journeySummaryView.addSubview(startView)
        startView.snp.makeConstraints { make in
            make.leading.equalTo(journeySummaryView).inset(57)
            make.top.equalTo(journeySummaryView).inset(60)
            make.width.equalTo(48)
            make.height.equalTo(26)
        }
        startView.addSubview(startLabel)
        startLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(startView)
        }

        journeySummaryView.addSubview(startLocation)
        startLocation.snp.makeConstraints { make in
            make.centerX.equalTo(startView)
            make.top.equalTo(startView).inset(32)
        }

        journeySummaryView.addSubview(startTime)
        startTime.snp.makeConstraints { make in
            make.centerX.equalTo(startView)
            make.top.equalTo(startLocation.snp.bottom).inset(-16)
        }

        journeySummaryView.addSubview(arrowLabel)
        arrowLabel.snp.makeConstraints { make in
            make.centerX.equalTo(journeySummaryView)
            make.centerY.equalTo(startLocation)
        }
    }

    private func setEndRouteComponent() {

        let endLocation: UILabel = {
            let lbl = UILabel()
            lbl.text = "C5" // 출발지
            lbl.textColor = .black
            lbl.font = CarmuFont().display2
            lbl.textAlignment = .center
            return lbl
        }()

        let endTime: UILabel = {
            let lbl = UILabel()
            lbl.text = "00 : 00"
            lbl.textColor = ColorTheme().darkblue4
            lbl.font = CarmuFont().body3
            lbl.textAlignment = .center
            return lbl
        }()

        journeySummaryView.addSubview(endView)
        endView.snp.makeConstraints { make in
            make.trailing.equalTo(journeySummaryView).inset(57)
            make.top.equalTo(journeySummaryView).inset(60)
            make.width.equalTo(48)
            make.height.equalTo(25)
        }
        endView.addSubview(endLabel)
        endLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(endView)
        }

        journeySummaryView.addSubview(endLocation)
        endLocation.snp.makeConstraints { make in
            make.centerX.equalTo(endView)
            make.top.equalTo(endView).inset(32)
        }

        journeySummaryView.addSubview(endTime)
        endTime.snp.makeConstraints { make in
            make.centerX.equalTo(endView)
            make.top.equalTo(endLocation.snp.bottom).inset(-16)
        }
    }

    func setSentence() {
        // 점선을 그리기 위한 CALayer 생성
        dottedLineLayer.strokeColor = UIColor.gray.cgColor
        dottedLineLayer.lineWidth = 1
        dottedLineLayer.lineDashPattern = [10, 10]  // 점선의 패턴을 설정

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: bounds.width - 40, y: 0)])
        dottedLineLayer.path = path
        dottedLineLayer.anchorPoint = CGPoint(x: 0, y: 0)

        // 문구
        let bottomLabel: UILabel = {
            let lbl = UILabel()
            lbl.textColor = SemanticColor().textBody
            lbl.font = CarmuFont().body2
            lbl.textAlignment = .center
            lbl.text = groupData == nil ? "세션관리에서 여정을 만들어 보세요." : "오늘도 즐거운 여정을 시작해 보세요!"
            return lbl
        }()

        journeySummaryView.addSubview(bottomLabel)

        bottomLabel.snp.makeConstraints { make in
            make.centerX.equalTo(journeySummaryView)
            make.bottom.equalTo(journeySummaryView).inset(20)
        }
    }

    func setupDashLine() {
        sessionStartBorderLayer.strokeColor = UIColor.theme.blue3?.cgColor
        sessionStartBorderLayer.lineDashPattern = [6, 6] // 점선 설정
        sessionStartBorderLayer.frame = viewWithoutCrew.bounds
        sessionStartBorderLayer.fillColor = nil
        sessionStartBorderLayer.path = UIBezierPath(rect: viewWithoutCrew.bounds).cgPath
        viewWithoutCrew.layer.addSublayer(sessionStartBorderLayer)
    }
}
