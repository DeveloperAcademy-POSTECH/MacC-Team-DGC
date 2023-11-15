//
//  CrewEditViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import MapKit
import UIKit

import SnapKit

// MARK: - 마이페이지(운전자) 크루 편집 뷰 컨트롤러
final class CrewEditViewController: UIViewController {

    private let crewEditView = CrewEditView()
    private let firebaseManager = FirebaseManager()
    var originalUserCrewData: Crew? // 불러온 유저의 크루 데이터
    var newUserCrewData: Crew? // 기존 크루 데이터 값을 편집하고 저장하기 위한 객체
    var crewPoints = [Point?]() // 출발지,경유지1,경유지2,경유지3,도착지 객체를 담는 배열 (없으면 nil)

    init(userCrewData: Crew) {
        // TODO: - 실제 DB 데이터 받아오도록 수정
        originalUserCrewData = dummyCrewData
        newUserCrewData = dummyCrewData
        crewPoints = [
            dummyCrewData?.startingPoint,
            dummyCrewData?.stopover1,
            dummyCrewData?.stopover2,
            dummyCrewData?.stopover3,
            dummyCrewData?.destination
        ]
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeCrewEdit))

        addButtonTargets()

        crewEditView.pointEditTableView.register(PointEditTableViewCell.self, forCellReuseIdentifier: PointEditTableViewCell.cellIdentifier)
        crewEditView.pointEditTableView.dataSource = self
        crewEditView.pointEditTableView.delegate = self

        view.addSubview(crewEditView)
        crewEditView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = originalUserCrewData?.name // 내비게이션 제목 크루 이름으로 설정
    }

    // 버튼 타겟 추가
    private func addButtonTargets() {
        crewEditView.repeatDayEditButton.addTarget(self, action: #selector(showRepeatDaySelectModal), for: .touchUpInside)
//        crewEditView.startPoint.timeEditButton.addTarget(self, action: #selector(showTimeSelectModal), for: .touchUpInside)
//        crewEditView.stopover1.timeEditButton.addTarget(self, action: #selector(showTimeSelectModal), for: .touchUpInside)
//        crewEditView.stopover2.timeEditButton.addTarget(self, action: #selector(showTimeSelectModal), for: .touchUpInside)
//        crewEditView.stopover3.timeEditButton.addTarget(self, action: #selector(showTimeSelectModal), for: .touchUpInside)
//        crewEditView.endPoint.timeEditButton.addTarget(self, action: #selector(showTimeSelectModal), for: .touchUpInside)
//        crewEditView.startPoint.addressEditButton.addTarget(self, action: #selector(showDetailPointMapVC), for: .touchUpInside)
//        crewEditView.stopover1.addressEditButton.addTarget(self, action: #selector(showDetailPointMapVC), for: .touchUpInside)
//        crewEditView.stopover2.addressEditButton.addTarget(self, action: #selector(showDetailPointMapVC), for: .touchUpInside)
//        crewEditView.stopover3.addressEditButton.addTarget(self, action: #selector(showDetailPointMapVC), for: .touchUpInside)
//        crewEditView.endPoint.addressEditButton.addTarget(self, action: #selector(showDetailPointMapVC), for: .touchUpInside)
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
        guard let originalRepeatDay = newUserCrewData?.repeatDay else {
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
     주소 설정 버튼 클릭 시 호출
     */
//    @objc private func showDetailPointMapVC(sender: UIButton) {
//        let detailPointMapVC = SelectDetailPointMapViewController()
//        // 상세주소 설정 뷰컨트롤러에 넘겨줄 기존 주소값
//        let originalPointData = SelectAddressDTO(
//            pointName: sender.pointType?.rawValue,
//            buildingName: sender.pointData?.name,
//            detailAddress: sender.pointData?.detailAddress,
//            coordinate: CLLocationCoordinate2D(
//                latitude: sender.pointData?.latitude ?? 35.634,
//                longitude: sender.pointData?.longitude ?? 128.523
//            )
//        )
//        print("originalPointData: \(originalPointData)")
//        print("sender.pointData: \(sender.pointData)")
//        detailPointMapVC.selectAddressModel = originalPointData
//        detailPointMapVC.addressSelectionHandler = { [weak self] newPointData in
//            // TODO: - 새로운 주소값 처리
//            sender.setTitle(newPointData.pointName, for: .normal)
//        }
//        if sender.pointType == .end {
//            detailPointMapVC.selectDetailPointMapView.saveButton.setTitle("도착지로 설정", for: .normal)
//        } else {
//            detailPointMapVC.selectDetailPointMapView.saveButton.setTitle("출발지로 설정", for: .normal)
//        }
////        self.navigationController?.pushViewController(detailPointMapVC, animated: true)
//        present(detailPointMapVC, animated: true)
//    }
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

// MARK: - UITableViewDataSource 프로토콜 구현
extension CrewEditViewController: UITableViewDataSource {

    // 섹션 별 row 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nonNilPointsCount = crewPoints.compactMap { $0 }.count // nil 아닌 포인트의 개수 (유효한 포인트의 개수)
        if nonNilPointsCount == 5 {
            return 5
        } else {
            return nonNilPointsCount + 1
        }
    }

    // MARK: - 각 row에 대한 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 포인트 편집 셀
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointEditTableViewCell.cellIdentifier, for: indexPath) as? PointEditTableViewCell else {
            return UITableViewCell()
        }
        let nonNilPointsCount = crewPoints.compactMap { $0 }.count // nil 아닌 포인트의 개수 (유효한 포인트의 개수)
        // 경유지 추가 버튼이 들어갈 인덱스
        let addButtonIndex = nonNilPointsCount - 1

        if indexPath.row == 0 {
            /* 출발지 셀 구성 */
            cell.addressEditButton.setTitle(crewPoints[indexPath.row]?.name, for: .normal)
            cell.timeEditButton.setTitle(
                Date.formattedDate(from: crewPoints[indexPath.row]?.arrivalTime ?? Date(), dateFormat: "aa hh:mm"),
                for: .normal
            )
            cell.setupXButton(false) // X버튼 비활성화
            cell.remakeStartPointLayout() // 출발지 레이아웃 재구성
        } else {
            if indexPath.row == addButtonIndex {
                if addButtonIndex < 4 {
                    /* 추가버튼 셀 구성 */
                    cell.setupStopoverAddButton(true)
                } else {
                    /* 도착지 셀 구성 */
                    cell.addressEditButton.setTitle(crewPoints[indexPath.row]?.name, for: .normal)
                    cell.setupArrivalLabel() // [도착] 시간 라벨
                    cell.timeEditButton.setTitle(
                        Date.formattedDate(from: crewPoints[indexPath.row]?.arrivalTime ?? Date(), dateFormat: "aa hh:mm"),
                        for: .normal
                    )
                    cell.setupXButton(false) // x버튼 비활성화
                    cell.remakeEndPointLayout() // 도착지 레이아웃 구성
                }
            } else {
                if indexPath.row == nonNilPointsCount {
                    /* 도착지 셀 구성 */
                    cell.addressEditButton.setTitle(crewPoints[4]?.name, for: .normal)
                    cell.setupArrivalLabel() // [도착] 시간 라벨
                    cell.timeEditButton.setTitle(
                        Date.formattedDate(from: crewPoints[4]?.arrivalTime ?? Date(), dateFormat: "aa hh:mm"),
                        for: .normal
                    )
                    cell.setupXButton(false) // x버튼 비활성화
                    cell.remakeEndPointLayout() // 도착지 레이아웃 구성
                } else {
                    /* 일반 경유지 셀 구성 */
                    cell.addressEditButton.setTitle(crewPoints[indexPath.row]?.name, for: .normal)
                    cell.timeEditButton.setTitle(
                        Date.formattedDate(from: crewPoints[indexPath.row]?.arrivalTime ?? Date(), dateFormat: "aa hh:mm"),
                        for: .normal
                    )
                    cell.setupXButton(true) // x버튼 활성화
                }
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate 프로토콜 구현
extension CrewEditViewController: UITableViewDelegate {

    // 행 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let nonNilPointsCount = crewPoints.compactMap { $0 }.count // nil 아닌 포인트의 개수 (유효한 포인트의 개수)
        if nonNilPointsCount == 5 {
            return crewEditView.colorLine.frame.height / CGFloat(5)
        } else {
            return crewEditView.colorLine.frame.height / CGFloat(nonNilPointsCount + 1)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CrewEditViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CrewEditViewController
    func makeUIViewController(context: Context) -> CrewEditViewController {
        return CrewEditViewController(userCrewData: dummyCrewData!) // 프리뷰라서 강제 바인딩 했습니다.
    }
    func updateUIViewController(_ uiViewController: CrewEditViewController, context: Context) {}
}
@available(iOS 13.0.0, *)
struct CrewEditViewPreview: PreviewProvider {
    static var previews: some View {
        CrewEditViewControllerRepresentable()
    }
}
