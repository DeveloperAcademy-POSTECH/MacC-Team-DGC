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

    // MARK: - 기존 크루 데이터에 맞게 화면 정보 갱신
    private func setOriginalCrewData() {
        guard let crewData = userCrewData else {
            return
        }
        // TODO: - 반복 요일 세팅하기
        guard let repeatDay = crewData.repeatDay else {
            return
        }

        // 출발지 정보 세팅
        crewEditView.startPoint.addressEditButton.setTitle(crewData.startingPoint?.name, for: .normal)
        crewEditView.startPoint.timeEditButton.setTitle(
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

    // [완료] 버튼 클릭 시 호출
    @objc private func completeCrewEdit() {
        // TODO: - 구현하기
        print("크루 편집 완료")
    }

    // 반복 요일 버튼 클릭 시 호출
    @objc private func showRepeatDaySelectModal() {
        guard let userCrewData = userCrewData else {
            return
        }
        let repeatDaySelectVC = RepeatDaySelectViewController(crewData: userCrewData)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CrewEditViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CrewEditViewController
    func makeUIViewController(context: Context) -> CrewEditViewController {
        return CrewEditViewController(userCrewData: crewData!) // 프리뷰라서 강제 바인딩 했습니다.
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
