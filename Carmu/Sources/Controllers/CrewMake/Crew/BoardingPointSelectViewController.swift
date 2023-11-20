//
//  BoardingPointSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class BoardingPointSelectViewController: UIViewController {

    private let boardingPointSelectView = BoardingPointSelectView()
    private let firebaseManager = FirebaseManager()
    private var selectedButton: StopoverSelectButton?
    private var selectedPoint: Int?
    var crewData: Crew

    init(crewData: Crew) {
        self.crewData = crewData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        boardingPointSelectView.customTableVieWCell = {
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
                let isStart = index == timeAddressTuple.count - 1 ? false : true
                let button = StopoverSelectButton(address: tuple.0 ?? "", isStart, time: tuple.1)
                button.isEnabled = index == timeAddressTuple.count - 1 ? false : true

                button.tag = index
                buttons.append(button)
            }
            return buttons
        }()

        for element in boardingPointSelectView.customTableVieWCell {
            element.addTarget(self, action: #selector(stopoverPointTapped), for: .touchUpInside)
        }
        boardingPointSelectView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        boardingPointSelectView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
        boardingPointSelectView.nextButton.isEnabled = false

        view.addSubview(boardingPointSelectView)
        boardingPointSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}

// MARK: - @objc Method
extension BoardingPointSelectViewController {

    @objc private func stopoverPointTapped(_ sender: StopoverSelectButton) {
        if selectedButton == sender {
            selectedButton?.resetButtonAppearance()
            selectedPoint = nil
            selectedButton = nil
            boardingPointSelectView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
            boardingPointSelectView.nextButton.isEnabled = false
            return
        }
        // 이전에 선택한 버튼을 원래 상태로 복구
        selectedButton?.resetButtonAppearance()

        // 선택한 버튼 업데이트
        selectedButton = sender

        // 선택한 버튼의 색상 변경
        sender.setSelectedButtonAppearance()

        boardingPointSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
        boardingPointSelectView.nextButton.isEnabled = true
        selectedPoint = sender.tag
    }

    @objc private func nextButtonTapped() {
        firebaseManager.setCrewToUser(KeychainItem.currentUserIdentifier ?? "", crewData.id ?? "")
        firebaseManager.setUserToCrew(KeychainItem.currentUserIdentifier ?? "", crewData.id ?? "")
        firebaseManager.setUserToPoint(KeychainItem.currentUserIdentifier ?? "", crewData.id ?? "", setUserToPoint())

        if SceneDelegate.isFirst {
            SceneDelegate.updateIsFirstValue(false)
        } else {
            // 초기 화면이 아닐 경우(건너가기 후 그룹코드 입력)
            navigationController?.popToRootViewController(animated: false)
            navigationController?.viewControllers.first?.viewDidAppear(true)
        }
    }
}

// MARK: - custom Method
extension BoardingPointSelectViewController {

    /**
     경유지 선택 화면에서 선택된 버튼의 인덱스를 String으로 변환하는 메서드
     */
    private func setUserToPoint() -> String {
        switch selectedPoint {
        case 0:
            return "startingPoint"
        case 1:
            return "stopover1"
        case 2:
            return "stopover2"
        default:
            return "stopover3"
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct BPSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = BoardingPointSelectViewController
    func makeUIViewController(context: Context) -> BoardingPointSelectViewController {
        return BoardingPointSelectViewController(
            crewData: Crew(
                crews: [UserIdentifier](),
                memberStatus: [MemberStatus]()
            )
        )
    }
    func updateUIViewController(_ uiViewController: BoardingPointSelectViewController, context: Context) {}
}
