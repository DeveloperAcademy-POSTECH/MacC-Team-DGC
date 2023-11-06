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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        navigationItem.rightBarButtonItem = RightNavigationBarButton(buttonTitle: "수정하기")

        finalConfirmView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )

        view.addSubview(finalConfirmView)
        finalConfirmView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        inviteCode = generateRandomCode()
    }
}

// MARK: - custom Method
extension FinalConfirmViewController {

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
}

// MARK: - @objc Method
extension FinalConfirmViewController {

    @objc private func editButtonTapped() {

    }

    @objc private func nextButtonTapped() {
        let randomCode = generateRandomCode()

        // TODO: points, repeatDay 실 데이터 삽입 작업 추후 예정
        firebaseManager.addCrew(
            crewName: makeRandomCrewName(),
            startingPoint: Point(
                name: "포항터미널",
                detailAddress: "경상북도 포항시 남구 중흥로 85",
                latitude: 36.0133,
                longitude: 129.3496,
                arrivalTime: Date(),
                crews: []
            ),
            destination: Point(
                name: "C5",
                detailAddress: "경상북도 포항시 남구 지곡로 80",
                latitude: 36.0141,
                longitude: 129.3258,
                arrivalTime: Date(),
                crews: []
            ),
            inviteCode: inviteCode ?? randomCode,
            repeatDay: [1, 2, 3, 4, 5]
        )
        if inviteCode == nil {
            inviteCode = randomCode
        }

        let viewController = CodeShareViewController(inviteCode: inviteCode ?? randomCode)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FCViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FinalConfirmViewController
    func makeUIViewController(context: Context) -> FinalConfirmViewController {
        return FinalConfirmViewController()
    }
    func updateUIViewController(_ uiViewController: FinalConfirmViewController, context: Context) {}
}
