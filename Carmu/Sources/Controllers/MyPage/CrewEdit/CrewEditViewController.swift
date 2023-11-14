//
//  CrewEditViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import UIKit

import SnapKit

// MARK: - 마이페이지(운전자) 크루 편집 뷰 컨트롤러
final class CrewEditViewController: UIViewController {

    private let crewEditView = CrewEditView()
    private let firebaseManager = FirebaseManager()
    var userCrewData: Crew? // 불러온 유저의 크루 데이터

    init(userCrewData: Crew) {
        // TODO: - 실제 DB 데이터 받아오도록 수정
        self.userCrewData = userCrewData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        // 백버튼 텍스트 제거
        navigationController?.navigationBar.topItem?.title = ""
        // 설정 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(completeCrewEdit)
        )

        setOriginalCrewData()
        addButtonTargets()

        view.addSubview(crewEditView)
        crewEditView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = userCrewData?.name // 내비게이션 제목 크루 이름으로 설정
    }

    // 버튼 타겟 추가
    private func addButtonTargets() {
        crewEditView.repeatDayEditButton.addTarget(
            self,
            action: #selector(showRepeatDaySelectModal),
            for: .touchUpInside
        )
        crewEditView.startPoint.timeEditButton.addTarget(
            self,
            action: #selector(showTimeSelectModal),
            for: .touchUpInside
        )
        crewEditView.stopover1.timeEditButton.addTarget(
            self,
            action: #selector(showTimeSelectModal),
            for: .touchUpInside
        )
        crewEditView.stopover2.timeEditButton.addTarget(
            self,
            action: #selector(showTimeSelectModal),
            for: .touchUpInside
        )
        crewEditView.stopover3.timeEditButton.addTarget(
            self,
            action: #selector(showTimeSelectModal),
            for: .touchUpInside
        )
        crewEditView.endPoint.timeEditButton.addTarget(
            self,
            action: #selector(showTimeSelectModal),
            for: .touchUpInside
        )
    }

    // MARK: - 기존 크루 데이터에 맞게 화면 정보 갱신
    private func setOriginalCrewData() {
        guard let crewData = userCrewData else {
            return
        }

        // 출발지 정보 세팅
        crewEditView.startPoint.addressEditButton.setTitle(crewData.startingPoint?.name, for: .normal) // 기존 정보로 주소 설정 버튼 세팅
        crewEditView.startPoint.timeEditButton.setTitle( // 기존 정보로 시간 설정 버튼 세팅
            Date.formattedDate(
                from: crewData.startingPoint?.arrivalTime ?? Date(),
                dateFormat: "aa hh:mm"
            ),
            for: .normal
        )
        // 도착지 정보 세팅
        crewEditView.endPoint.addressEditButton.setTitle(crewData.destination?.name, for: .normal)
        crewEditView.endPoint.timeEditButton.setTitle(
            Date.formattedDate(
                from: crewData.destination?.arrivalTime ?? Date(),
                dateFormat: "aa hh:mm"
            ),
            for: .normal
        )
        // 경유지 정보 세팅
        var crewStopoverArray = [Point]()
        if let stopover1 = crewData.stopover1 {
            crewStopoverArray.append(stopover1)
        }
        if let stopover2 = crewData.stopover2 {
            crewStopoverArray.append(stopover2)
        }
        if let stopover3 = crewData.stopover3 {
            crewStopoverArray.append(stopover3)
        }
        switch crewStopoverArray.count {
        case 1:
            setStopoverLayout(
                crewStopoverArray: crewStopoverArray,
                stopoverEditViewArray: [
                    crewEditView.stopover1
                ]
            )
        case 2:
            setStopoverLayout(
                crewStopoverArray: crewStopoverArray,
                stopoverEditViewArray: [
                    crewEditView.stopover1,
                    crewEditView.stopover2
                ]
            )
        case 3:
            setStopoverLayout(
                crewStopoverArray: crewStopoverArray,
                stopoverEditViewArray: [
                    crewEditView.stopover1,
                    crewEditView.stopover2,
                    crewEditView.stopover3
                ]
            )
        default:
            print("경유지 없음")
        }
    }

    // 경유지 개수에 따른 레이아웃 설정 메서드
    private func setStopoverLayout(crewStopoverArray: [Point], stopoverEditViewArray: [PointEditView]) {
        print("경유지 \(crewStopoverArray.count)개")

        crewEditView.stopoverStackView.spacing = 20
        for idx in 0..<stopoverEditViewArray.count {
            stopoverEditViewArray[idx].addressEditButton.setTitle(crewStopoverArray[idx].name, for: .normal)
            stopoverEditViewArray[idx].timeEditButton.setTitle(
                Date.formattedDate(
                    from: crewStopoverArray[idx].arrivalTime ?? Date(),
                    dateFormat: "aa hh:mm"),
                for: .normal
            )
            crewEditView.stopoverStackView.addArrangedSubview(stopoverEditViewArray[idx])
        }
        if stopoverEditViewArray.count < 3 {
            crewEditView.stopoverStackView.addArrangedSubview(crewEditView.stopoverAddButton)
        }
    }
}

// MARK: - @objc 메서드
extension CrewEditViewController {

    /**
     [완료] 버튼 클릭 시 호출
     */
    @objc private func completeCrewEdit() {
        // TODO: - 최종적으로 수정된 [크루 데이터]를 파이어베이스 DB에 전달
        print("크루 편집 완료")
    }

    /**
     반복 요일 설정 버튼 클릭 시 호출
     */
    @objc private func showRepeatDaySelectModal() {
        // 크루에 설정돼있는 반복 요일 데이터를 전달
        guard let originalRepeatDay = userCrewData?.repeatDay else {
            return
        }
        let repeatDaySelectModalVC = RepeatDaySelectModalViewController()
        repeatDaySelectModalVC.selectedRepeatDay = Set(originalRepeatDay)
        print("기존 선택 요일: \(Set(originalRepeatDay))")
        repeatDaySelectModalVC.delegate = self

        // 모달 설정
        if let sheet = repeatDaySelectModalVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [
                .custom { _ in
                    return 344
                }
            ]
        }
        present(repeatDaySelectModalVC, animated: true)
    }

    /**
     장소의 시간 설정 버튼 클릭 시 호출
     */
    @objc private func showTimeSelectModal(sender: TimeEditButton) {
        let timeSelectModalVC = TimeSelectModalViewController()
        // TODO: - Crew에 정보 입력하는 방식 이후, 타임 피커에 이전 경유지보다 늦은 시간부터 설정하는 로직 구현예정
        // 시간 설정 모달에 기존의 값을 반영
        timeSelectModalVC.timeSelectModalView.timePicker.date = Date.formattedDate(
            string: sender.titleLabel?.text ?? "오전 08:00",
            dateFormat: "aa hh:mm"
        ) ?? Date()

        // 시간 설정 모달에서 선택된 값이 반영된다.
        timeSelectModalVC.timeSelectionHandler = { [weak self] selectedTime in
            sender.setTitle(Date.formattedDate(from: selectedTime, dateFormat: "aa hh:mm"), for: .normal)
        }

        present(timeSelectModalVC, animated: true)
    }
}

// MARK: - RDSModalViewControllerDelegate 델리게이트 구현
extension CrewEditViewController: RDSModalViewControllerDelegate {

    /**
     RepeatDaySelectModalViewController에서 반복 요일 데이터가 수정되었을 때 호출
     */
    func sendNewRepeatDayValue(newRepeatDay: [Int]) {
        print("반복 요일 갱신")
        // TODO: - 앱 상에서 갖고 있는 데이터에 반영해주기 (파이어베이스 DB에는 X)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CrewEditViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CrewEditViewController
    func makeUIViewController(context: Context) -> CrewEditViewController {
        return CrewEditViewController(userCrewData: dummyCrewData!) // 프리뷰라서 강제 바인딩 했습니다.
    }
    func updateUIViewController(_ uiViewController: CrewEditViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct CrewEditViewPreview: PreviewProvider {
    static var previews: some View {
        CrewEditViewControllerRepresentable()
    }
}
