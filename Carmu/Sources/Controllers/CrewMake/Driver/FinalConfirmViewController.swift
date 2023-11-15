//
//  FinalConfirmViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class FinalConfirmViewController: UIViewController {

    private let finalConfirmView = FinalConfirmView()
    private let firebaseManager = FirebaseManager()
    private var inviteCode: String?
    var selectedDay: Set<DayOfWeek> = []
    var crewData: Crew

    init(crewData: Crew) {
        self.crewData = crewData
        super.init(nibName: nil, bundle: nil)
        selectedDay = Set(crewData.repeatDay?.compactMap { DayOfWeek(rawValue: $0) } ?? [])
        self.finalConfirmView.customStackCell = {
            var buttons: [StopoverSelectButton] = []
            var timeAddressTuple: [(String?, Date)] = []

            timeAddressTuple.append((crewData.startingPoint?.name, crewData.startingPoint?.arrivalTime ?? Date()))
            if let stopover1 = crewData.stopover1 {
                timeAddressTuple.append((stopover1.name, crewData.stopover1?.arrivalTime ?? Date()))
            }
            if let stopover2 = crewData.stopover2 {
                timeAddressTuple.append((stopover2.name, crewData.stopover2?.arrivalTime ?? Date()))
            }
            if let stopover3 = crewData.stopover3 {
                timeAddressTuple.append((stopover3.name, crewData.stopover3?.arrivalTime ?? Date()))
            }
            timeAddressTuple.append((crewData.destination?.name, crewData.destination?.arrivalTime ?? Date()))

            for (index, tuple) in timeAddressTuple.enumerated() {
                // TODO: 들어오는 데이터에 맞춰 변형될 수 있도록 변경해야 함.
                let isStart = index == 3 ? false : true
                let button = StopoverSelectButton(address: tuple.0 ?? "", isStart, time: tuple.1)
                button.layer.shadowOpacity = 0
                button.tag = index
                button.isEnabled = false
                buttons.append(button)
            }
            return buttons
        }()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        navigationItem.rightBarButtonItem = RightNavigationBarButton(buttonTitle: "수정하기")

        additionalSetting()
        view.addSubview(finalConfirmView)
        finalConfirmView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        inviteCode = generateRandomCode()
    }
}

// MARK: - custom Method
extension FinalConfirmViewController {

    private func additionalSetting() {
        finalConfirmView.daySelectButton.setTitle(
            setDayButtonTitle(selectedDay),
            for: .normal
        )
        finalConfirmView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }

    /**
     그룹이름 랜덤 생성 메서드
     */
    private func makeRandomCrewName() -> String {
        let randomNameList = [
            "멋있는", "선량한", "정열의", "무거운", "가벼운", "스피드", "슬로우",
            "새로운", "오래된", "행복한", "착한", "훌륭한", "희망찬", "강력한", "둥근", "뾰족한",
            "훈훈한", "황금빛", "순백의", "바쁜", "활발한", "선선한", "정직한", "강력한", "가난한",
            "훈남훈녀", "맑은", "부드러운", "흥미로운", "어두운", "행복한", "놀라운", "성실한", "창조적인", "운좋은",
            "훌륭한", "안정된", "명확한", "화려한", "바람직한", "조용한", "귀여운", "편안한", "어려운", "단단한",
            "우아한", "소중한", "예쁜", "인기있는", "우아한", "아름다운", "가까운", "훈훈한", "좋아요",
            "뒷목잡는", "막강한", "웃긴", "재미있는", "선남선녀", "우주최강", "날로먹는", "간편한"
        ]
        return "\(randomNameList.randomElement() ?? "좋아요") 카풀팟"
    }

    /**
     그룹 코드 랜덤 생성 메서드
     */
    private func generateRandomCode() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""

        for _ in 0..<8 {
            let randomIndex = Int.random(in: 0..<letters.count)
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }

    /**
     상단 요일버튼 String 생성 메서드
     */
    private func setDayButtonTitle(_ selectedDay: Set<DayOfWeek>) -> String {
        var returnString = [String]()
        let sortedDays = selectedDay.sorted { $0.rawValue < $1.rawValue }

        switch selectedDay {
        case DayOfWeek.weekday:
            returnString.append("주중")
        case DayOfWeek.weekend:
            returnString.append("주말")
        case DayOfWeek.everyday:
            returnString.append("매일")
        default:
            for day in sortedDays {
                returnString.append(day.dayString)
            }
        }

        if returnString.count == 1 {
            return returnString[0]
        } else {
            return returnString.joined(separator: ", ")
        }
    }
}

// MARK: - @objc Method
extension FinalConfirmViewController {

    @objc private func editButtonTapped() {
        // TODO: 수정 화면 present 구현
    }

    @objc private func nextButtonTapped() {
        let randomCode = generateRandomCode()

        crewData.name = makeRandomCrewName()
        crewData.inviteCode = inviteCode ?? randomCode

        // TODO: points, repeatDay 실 데이터 삽입 작업 추후 예정
        firebaseManager.addCrew(crewData: crewData)

        let viewController = CodeShareViewController(inviteCode: inviteCode ?? randomCode)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FCViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FinalConfirmViewController
    func makeUIViewController(context: Context) -> FinalConfirmViewController {
        return FinalConfirmViewController(
            crewData: Crew(
                crews: [UserIdentifier](),
                memberStatus: [MemeberStatus]()
            )
        )
    }
    func updateUIViewController(_ uiViewController: FinalConfirmViewController, context: Context) {}
}
