//
//  CrewEditViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import MapKit
import UIKit

import NMapsMap
import SnapKit

// MARK: - 크루 편집 완료 시 이전 뷰 컨트롤러에 데이터를 넘겨주기 위한 델리게이트 프로토콜
protocol CrewEditViewDelegate: AnyObject {

    func crewEditDoneButtonTapped(newUserCrewData: Crew?)
}

// MARK: - 마이페이지(운전자) 크루 편집 뷰 컨트롤러
final class CrewEditViewController: UIViewController {

    weak var crewEditViewDelegte: CrewEditViewDelegate?

    private let crewEditView = CrewEditView()
    private let firebaseManager = FirebaseManager()
    var originalUserCrewData: Crew // 불러온 유저의 크루 데이터
    var newUserCrewData: Crew // 기존 크루 데이터 값을 편집하고 저장하기 위한 객체
    // 경유지를 담는 배열 (없으면 nil)
    var stopoverPoints = [Point?]()

    init(userCrewData: Crew) {
        originalUserCrewData = userCrewData
        newUserCrewData = userCrewData
        stopoverPoints = [
            userCrewData.stopover1,
            userCrewData.stopover2,
            userCrewData.stopover3
        ]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

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
        navigationItem.title = originalUserCrewData.name // 내비게이션 제목 크루 이름으로 설정
    }

    // 버튼 타겟 추가
    private func addButtonTargets() {
        crewEditView.repeatDayEditButton.addTarget(self, action: #selector(showRepeatDaySelectModal), for: .touchUpInside)
    }
}

// MARK: - @objc 메서드
extension CrewEditViewController {

    /**
     [완료] 버튼 클릭 시 호출
     */
    @objc private func completeCrewEdit() {
        print("💡newUserCrewData: \(newUserCrewData)")
        guard let crewID = newUserCrewData.id else { return }
        firebaseManager.updateCrew(crewID: crewID, newCrewData: newUserCrewData)
        showDoneAlert()
        print("크루 편집 완료")
    }

    // 완료 알럿
    private func showDoneAlert() {
        let alert = UIAlertController(title: "크루 수정이 완료되었습니다.", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.crewEditViewDelegte?.crewEditDoneButtonTapped(newUserCrewData: self?.newUserCrewData)
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    /**
     반복 요일 설정 버튼 클릭 시 호출
     */
    @objc private func showRepeatDaySelectModal() {
        // 크루에 설정돼있는 반복 요일 데이터를 전달
        guard let originalRepeatDay = newUserCrewData.repeatDay else {
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
}

// MARK: - RDSModalViewControllerDelegate 델리게이트 구현
extension CrewEditViewController: RDSModalViewControllerDelegate {

    /**
     RepeatDaySelectModalViewController에서 반복 요일 데이터가 수정되었을 때 호출
     */
    func sendNewRepeatDayValue(newRepeatDay: [Int]) {
        print("기존 반복 요일 👉 \(String(describing: newUserCrewData.repeatDay))")
        newUserCrewData.repeatDay = newRepeatDay
        print("갱신된 반복 요일 👉 \(String(describing: newUserCrewData.repeatDay))")
    }
}

// MARK: - UITableViewDataSource 프로토콜 구현
extension CrewEditViewController: UITableViewDataSource {

    // 섹션 별 row 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nonNilStopoverCount = stopoverPoints.compactMap { $0 }.count // nil 아닌 경유지 개수 (유효한 경유지의 개수)
        if (nonNilStopoverCount+3) > 5 {
            return 5
        } else {
            return nonNilStopoverCount + 3
        }
    }

    private func subhead2AttributedString(title: String?) -> AttributedString {
        var titleAttr = AttributedString(title ?? "")
        titleAttr.font = UIFont.carmuFont.subhead2
        return titleAttr
    }
    // MARK: - 각 row에 대한 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 포인트 편집 셀
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointEditTableViewCell.cellIdentifier, for: indexPath) as? PointEditTableViewCell else {
            return UITableViewCell()
        }
        let nonNilStopoverCount = stopoverPoints.compactMap { $0 }.count // nil 아닌 경유지 개수 (유효한 경유지의 개수)
        // 경유지 추가 버튼이 들어갈 인덱스
        let addButtonIndex = nonNilStopoverCount + 1

        if indexPath.row == 0 {
            /* 출발지 셀 구성 */
            cell.addressEditButton.configuration?.attributedTitle = subhead2AttributedString(title: newUserCrewData.startingPoint?.name)
            cell.setupDepartureLabel() // [출발] 시간 라벨
            cell.timeEditButton.setTitle(
                Date.formattedDate(from: newUserCrewData.startingPoint?.arrivalTime ?? Date(), dateFormat: "aa hh:mm"),
                for: .normal
            )
            cell.setupStopoverRemoveButton(false) // X버튼 비활성화
            cell.remakeStartPointLayout() // 출발지 레이아웃 재구성
            cell.pointType = .start
            cell.addressEditButton.pointType = .start
            cell.timeEditButton.pointType = .start
            cell.stopoverRemoveButton.pointType = .start
        } else {
            if indexPath.row == addButtonIndex {
                if addButtonIndex < 4 {
                    /* 추가버튼 셀 구성 */
                    cell.setupStopoverAddButton(true)
                    cell.setupStopoverRemoveButton(false) // X버튼 비활성화
                    switch addButtonIndex {
                    case 1:
                        cell.stopoverAddButton.pointType = .stopover1
                    case 2:
                        cell.stopoverAddButton.pointType = .stopover2
                    case 3:
                        cell.stopoverAddButton.pointType = .stopover3
                    default:
                        break
                    }
                } else {
                    /* 도착지 셀 구성 */
                    cell.addressEditButton.configuration?.attributedTitle = subhead2AttributedString(title: newUserCrewData.destination?.name)
                    cell.setupArrivalLabel() // [도착] 시간 라벨
                    cell.timeEditButton.setTitle(
                        Date.formattedDate(from: newUserCrewData.destination?.arrivalTime ?? Date(), dateFormat: "aa hh:mm"),
                        for: .normal
                    )
                    cell.setupStopoverRemoveButton(false) // x버튼 비활성화
                    cell.remakeEndPointLayout() // 도착지 레이아웃 구성
                    cell.pointType = .destination
                    cell.addressEditButton.pointType = .destination
                    cell.timeEditButton.pointType = .destination
                    cell.stopoverRemoveButton.pointType = .destination
                }
            } else {
                if indexPath.row == nonNilStopoverCount + 2 {
                    /* 도착지 셀 구성 */
                    cell.addressEditButton.configuration?.attributedTitle = subhead2AttributedString(title: newUserCrewData.destination?.name)
                    cell.setupArrivalLabel() // [도착] 시간 라벨
                    cell.timeEditButton.setTitle(
                        Date.formattedDate(from: newUserCrewData.destination?.arrivalTime ?? Date(), dateFormat: "aa hh:mm"),
                        for: .normal
                    )
                    cell.setupStopoverRemoveButton(false) // x버튼 비활성화
                    cell.remakeEndPointLayout() // 도착지 레이아웃 구성
                    cell.pointType = .destination
                    cell.addressEditButton.pointType = .destination
                    cell.timeEditButton.pointType = .destination
                    cell.stopoverRemoveButton.pointType = .destination
                } else {
                    /* 일반 경유지 셀 구성 */
                    cell.setupStopoverAddButton(false)
                    cell.addressEditButton.configuration?.attributedTitle = subhead2AttributedString(title: stopoverPoints[indexPath.row-1]?.name)
                    cell.setupDepartureLabel() // [출발] 시간 라벨
                    cell.timeEditButton.setTitle(
                        Date.formattedDate(from: stopoverPoints[indexPath.row-1]?.arrivalTime ?? Date(), dateFormat: "aa hh:mm"),
                        for: .normal
                    )
                    cell.setupStopoverRemoveButton(true) // x버튼 활성화
                    cell.remakeStopoverLayout() // 기존 경유지 레이아웃으로 재구성
                    switch indexPath.row-1 {
                    case 0:
                        cell.pointType = .stopover1
                        cell.addressEditButton.pointType = .stopover1
                        cell.timeEditButton.pointType = .stopover1
                        cell.stopoverRemoveButton.pointType = .stopover1
                    case 1:
                        cell.pointType = .stopover2
                        cell.addressEditButton.pointType = .stopover2
                        cell.timeEditButton.pointType = .stopover2
                        cell.stopoverRemoveButton.pointType = .stopover2
                    case 2:
                        cell.pointType = .stopover3
                        cell.addressEditButton.pointType = .stopover3
                        cell.timeEditButton.pointType = .stopover3
                        cell.stopoverRemoveButton.pointType = .stopover3
                    default:
                        break
                    }
                }
            }
        }
        cell.pointEditTableViewCellDelegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate 프로토콜 구현
extension CrewEditViewController: UITableViewDelegate {

    // 행 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let nonNilStopoverCount = stopoverPoints.compactMap { $0 }.count // nil 아닌 경유지의 개수 (유효한 경유지의 개수)
        if (nonNilStopoverCount+3) > 5 {
            return crewEditView.colorLine.frame.height / CGFloat(5)
        } else {
            return crewEditView.colorLine.frame.height / CGFloat(nonNilStopoverCount + 3)
        }
    }
}

// MARK: - 테이블 뷰 셀의 설정 버튼 이벤트를 처리하기 위한 델리게이트 구현
extension CrewEditViewController: PointEditTableViewCellDelegate {

    // MARK: - 시간 설정 버튼 클릭 시 호출되는 델리게이트 메서드
    func timeEditButtonTapped(sender: TimeEditButton) {
        let timeSelectModalVC = TimeSelectModalViewController()
        // 시간 설정 모달에 넘겨줄 기존 시간값
        let originalTimeValue = Date.formattedDate(string: sender.titleLabel?.text ?? "오전 08:00", dateFormat: "aa hh:mm") ?? Date()
        // TODO: - Crew에 정보 입력하는 방식 이후, 타임 피커에 이전 경유지보다 늦은 시간부터 설정하는 로직 구현예정
        // 시간 설정 모달에 기존의 값을 반영
        timeSelectModalVC.timeSelectModalView.timePicker.date = originalTimeValue

        // 시간 설정 모달에서 선택된 값이 반영된다.
        timeSelectModalVC.timeSelectionHandler = { newTimeValue in
            sender.setTitle(Date.formattedDate(from: newTimeValue, dateFormat: "aa hh:mm"), for: .normal)
            switch sender.pointType {
            case .start:
                self.newUserCrewData.startingPoint?.arrivalTime = newTimeValue
            case .destination:
                self.newUserCrewData.destination?.arrivalTime = newTimeValue
            default:
                self.stopoverPoints[sender.pointType?.stopoverIdx ?? -1]?.arrivalTime = newTimeValue
                self.updatePointChangeToNewCrewData(stopoverPoints: self.stopoverPoints)
            }
        }

        present(timeSelectModalVC, animated: true)
    }

    // MARK: - 주소 편집 버튼 클릭 시 호출되는 델리게이트 메서드
    func addressEditButtonTapped(sender: AddressEditButton) {
        let detailPointMapVC = SelectDetailStopoverPointViewController(crewData: newUserCrewData)
        detailPointMapVC.isCrewEdit = true
        detailPointMapVC.pointType = sender.pointType ?? .stopover1
        switch sender.pointType {
        case .start:
            detailPointMapVC.stopoverPointMapView.saveButton.setTitle("출발지로 설정", for: .normal)
        case .destination:
            detailPointMapVC.stopoverPointMapView.saveButton.setTitle("도착지로 설정", for: .normal)
        default:
            break
        }

        // 주소 설정 시 테이블뷰 UI 및 newUserCrewData에 반영
        detailPointMapVC.addressSelectionHandler = { newPointData in
            print("변경 전")
            print("👉startingPoint: \(String(describing: self.newUserCrewData.startingPoint))")
            print("👉stopover1: \(String(describing: self.newUserCrewData.stopover1))")
            print("👉stopover2: \(String(describing: self.newUserCrewData.stopover2))")
            print("👉stopover3: \(String(describing: self.newUserCrewData.stopover3))")
            print("👉destination: \(String(describing: self.newUserCrewData.destination))")
            sender.setTitle(newPointData.pointName, for: .normal)
            switch sender.pointType {
            case .start:
                self.newUserCrewData.startingPoint?.name = newPointData.pointName
                self.newUserCrewData.startingPoint?.detailAddress = newPointData.pointDetailAddress
                self.newUserCrewData.startingPoint?.latitude = newPointData.pointLat
                self.newUserCrewData.startingPoint?.longitude = newPointData.pointLng
            case .destination:
                self.newUserCrewData.destination?.name = newPointData.pointName
                self.newUserCrewData.destination?.detailAddress = newPointData.pointDetailAddress
                self.newUserCrewData.destination?.latitude = newPointData.pointLat
                self.newUserCrewData.destination?.longitude = newPointData.pointLng
            default:
                self.stopoverPoints[sender.pointType?.stopoverIdx ?? -1]?.name = newPointData.pointName
                self.stopoverPoints[sender.pointType?.stopoverIdx ?? -1]?.detailAddress = newPointData.pointDetailAddress
                self.stopoverPoints[sender.pointType?.stopoverIdx ?? -1]?.latitude = newPointData.pointLat
                self.stopoverPoints[sender.pointType?.stopoverIdx ?? -1]?.longitude = newPointData.pointLng
                self.updatePointChangeToNewCrewData(stopoverPoints: self.stopoverPoints)
            }
            print("변경 후")
            print("✅startingPoint: \(String(describing: self.newUserCrewData.startingPoint))")
            print("✅stopover1: \(String(describing: self.newUserCrewData.stopover1))")
            print("✅stopover2: \(String(describing: self.newUserCrewData.stopover2))")
            print("✅stopover3: \(String(describing: self.newUserCrewData.stopover3))")
            print("✅destination: \(String(describing: self.newUserCrewData.destination))")
        }
        present(detailPointMapVC, animated: true)
    }

    // MARK: - X 경유지 제거 버튼에 대한 액션 연결
    func stopoverRemoveButtonTapped(sender: StopoverRemoveButton) {
        switch sender.pointType {
        case .stopover1:
            if hasPassengers(for: .stopover1) {
                cantRemoveStopoverAlert()
                return
            } else {
                break
            }
        case .stopover2:
            if hasPassengers(for: .stopover2) {
                cantRemoveStopoverAlert()
                return
            } else {
                break
            }
        case .stopover3:
            if hasPassengers(for: .stopover3) {
                cantRemoveStopoverAlert()
                return
            } else {
                break
            }
        default:
            return
        }

        if sender.pointType == .stopover3 {
            stopoverPoints[2] = nil
        } else if sender.pointType == .stopover2 {
            stopoverPoints[1] = stopoverPoints[2] // stopover3의 데이터를 stopover2로
            stopoverPoints[2] = nil // stopover3의 데이터는 nil
        } else if sender.pointType == .stopover1 {
            stopoverPoints[0] = stopoverPoints[1] // stopover2의 데이터를 stopover1로
            stopoverPoints[1] = stopoverPoints[2] // stopover3의 데이터를 stopover2로
            stopoverPoints[2] = nil // stopover3의 데이터는 nil
        }
        updatePointChangeToNewCrewData(stopoverPoints: stopoverPoints) // 변경된 경유지 정보를 newUserCrewData에 업데이트
        crewEditView.pointEditTableView.reloadData()
    }

    // MARK: - 경유지 삭제 불가 Alert 생성
    private func cantRemoveStopoverAlert() {
        let alert = UIAlertController(title: "경고", message: nil, preferredStyle: .alert)
        alert.message = "탑승자가 한 명이라도 있을 경우 경유지를 삭제할 수 없어요!"
        let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    // MARK: - 해당 경유지에 크루 있는지 확인
    /**
     크루가 있으면 true를 반환
     없으면 false를 반환
     */
    private func hasPassengers(for pointType: PointType) -> Bool {
        switch pointType {
        case .stopover1:
            return stopoverPoints[0]?.crews != nil
        case .stopover2:
            return stopoverPoints[1]?.crews != nil
        case .stopover3:
            return stopoverPoints[2]?.crews != nil
        default:
            return false
        }
    }

    // MARK: - 경유지 추가 버튼에 대한 액션 연결
    func stopoverAddButtonTapped(sender: StopoverAddButton) {
        print("업데이트 전")
        for (idx, point) in stopoverPoints.enumerated() {
            print("👉 stopoverPoint\(idx+1): \(String(describing: point))")
        }
        print("경유지 추가 버튼 클릭")
        switch sender.pointType {
        case .stopover1:
            stopoverPoints[0] = Point(name: "주소를 검색해주세요", detailAddress: "상세주소", latitude: 35.634, longitude: 128.523, arrivalTime: Date())
        case .stopover2:
            stopoverPoints[1] = Point(name: "주소를 검색해주세요", detailAddress: "상세주소", latitude: 35.634, longitude: 128.523, arrivalTime: Date())
        case .stopover3:
            stopoverPoints[2] = Point(name: "주소를 검색해주세요", detailAddress: "상세주소", latitude: 35.634, longitude: 128.523, arrivalTime: Date())
        default:
            break
        }
        updatePointChangeToNewCrewData(stopoverPoints: stopoverPoints) // 변경된 경유지 정보를 newUserCrewData에 업데이트
        crewEditView.pointEditTableView.reloadData()
        print("업데이트 후")
        for (idx, point) in stopoverPoints.enumerated() {
            print("✅ stopoverPoint\(idx+1): \(String(describing: point))")
        }
    }

    // stopoverPoints 배열의 내용에 맞게 stopover1, stopover2, stopover3의 데이터를 변경해주는 메서드
    private func updatePointChangeToNewCrewData(stopoverPoints: [Point?]) {
        newUserCrewData.stopover1 = stopoverPoints[0]
        newUserCrewData.stopover2 = stopoverPoints[1]
        newUserCrewData.stopover3 = stopoverPoints[2]
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
