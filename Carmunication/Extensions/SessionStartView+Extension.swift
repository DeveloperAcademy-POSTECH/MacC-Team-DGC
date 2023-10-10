//
//  SessionStartView+Extension.swift
//  Carmunication
//
//  Created by 김태형 on 2023/10/09.
//

import UIKit

import SnapKit

extension SessionStartView {

    func setCollectionView() {
        groupCollectionView.backgroundColor = .white
        groupCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(102)    // TODO: - 크기 조정
        }
    }

    func countGroupData() {

        if groupData == nil {
            setViewWithoutGroup()
        }
    }

    func setViewWithoutGroup() {

        viewWithoutCrew.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(110)
        }

        noGroupCommentlabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(viewWithoutCrew)
        }
        // 점선 설정
        setupDashLine()
    }

    func setSummaryView() {

        let bottomInset: CGFloat
        if UIScreen.main.bounds.height >= 800 {
            // iPhone 14와 같이 큰 화면
            bottomInset = -36
        } else {
            // iPhone SE와 같이 작은 화면
            bottomInset = -4
        }

        summaryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(journeyTogetherButton.snp.top).inset(bottomInset)   // 수정
            make.top.equalTo(groupData == nil ? viewWithoutCrew.snp.bottom : groupCollectionView.snp.bottom).inset(-16)
        }
        setGroupNameView()
    }

    func setGroupNameView() {

        groupNameView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(summaryView)
            make.height.equalTo(48)
        }

        groupNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(groupNameView)
            make.centerY.equalTo(groupNameView)
        }

        whiteCircleImageViewLeft.snp.makeConstraints { make in
            make.leading.equalTo(groupNameView).inset(20)
            make.centerY.equalTo(groupNameView)
            make.width.height.equalTo(10)
        }
        whiteCircleImageViewRight.snp.makeConstraints { make in
            make.trailing.equalTo(groupNameView).inset(20)
            make.centerY.equalTo(groupNameView)
            make.width.height.equalTo(10)
        }
    }

    func setJourneySummaryView() {

        journeySummaryView.snp.makeConstraints { make in
            make.top.equalTo(groupNameView.snp.bottom).inset(-3)
            make.leading.trailing.bottom.equalTo(summaryView)
        }

        // MARK: - SessionStartView+Extension에 정의
        // 오늘의 날짜를 보여주는 메서드
        setTodayDate()

        // 요일과 인원을 알려주는 뷰
        setDayAndPerson()

        // 문구를 관리하는 메서드
        setSentence()
    }

    func setTodayDate() {

        // 현재 날짜를 가져와서 원하는 형식으로 변환
        let today = Date()
        let formattedDate = Date.formattedDate(from: today)
        dateLabel.text = formattedDate

        dateLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(journeySummaryView).inset(20)
        }

        // 여정 요약 (중앙 부분)
        if groupData == nil {

            bottomLabel.text = groupData == nil ? "세션관리에서 여정을 만들어 보세요." : "오늘도 즐거운 여정을 시작해 보세요!"
            noGroupComment.snp.makeConstraints { make in
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

        dayView.snp.makeConstraints { make in
            make.leading.equalTo(journeySummaryView).inset(12)
            make.bottom.equalTo(journeySummaryView).inset(70)
            make.height.equalTo(40) // 높이를 설정할 수 있습니다.
        }

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

        dayLabel.text = groupData == nil ? "---" : "주중 (월 ~ 금)" // TODO: - Text 변경
        calendarImage.snp.makeConstraints { make in
            make.leading.equalTo(dayView).offset(12)
            make.centerY.equalTo(dayView)
        }
        dayLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(dayView)
        }
    }

    func setPersonCountViewComponent() {

        personLabel.text = groupData == nil ? "---" : "n 명"
        personImage.snp.makeConstraints { make in
            make.leading.equalTo(personCountView).offset(12)
            make.centerY.equalTo(personCountView)
        }
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

        startView.snp.makeConstraints { make in
            make.leading.equalTo(journeySummaryView).inset(57)
            make.top.equalTo(journeySummaryView).inset(60)
            make.width.equalTo(48)
            make.height.equalTo(26)
        }

        startLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(startView)
        }

        startLocation.snp.makeConstraints { make in
            make.centerX.equalTo(startView)
            make.top.equalTo(startView).inset(32)
        }

        startTime.snp.makeConstraints { make in
            make.centerX.equalTo(startView)
            make.top.equalTo(startLocation.snp.bottom).inset(-16)
        }

        arrowLabel.snp.makeConstraints { make in
            make.centerX.equalTo(journeySummaryView)
            make.centerY.equalTo(startLocation)
        }
    }

    private func setEndRouteComponent() {

        endView.snp.makeConstraints { make in
            make.trailing.equalTo(journeySummaryView).inset(57)
            make.top.equalTo(journeySummaryView).inset(60)
            make.width.equalTo(48)
            make.height.equalTo(25)
        }
        endLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(endView)
        }

        endLocation.snp.makeConstraints { make in
            make.centerX.equalTo(endView)
            make.top.equalTo(endView).inset(32)
        }

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

    func setJourneyTogetherButton() {
        journeyTogetherButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().multipliedBy(1.0 - insetRatio) // inset 비율을 적용합니다.
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
}
