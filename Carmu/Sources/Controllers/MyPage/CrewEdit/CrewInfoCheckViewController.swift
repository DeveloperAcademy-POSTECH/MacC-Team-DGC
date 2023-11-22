//
//  CrewInfoCheckViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/10.
//

import UIKit

import SnapKit

// MARK: - 크루 정보 확인 뷰 컨트롤러
final class CrewInfoCheckViewController: UIViewController {

    private let crewInfoCheckView = CrewInfoCheckView()
    private let firebaseManager = FirebaseManager()
    var selectedDay: Set<DayOfWeek> = []

    var crewData: Crew // 불러온 유저의 크루 데이터

    init(crewData: Crew) {
        self.crewData = crewData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        updateCrewDataUI(crewData: crewData)

        // 백버튼 텍스트 제거
        navigationController?.navigationBar.topItem?.title = ""
        // 설정 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(startCrewEdit))

        performButtonSettings()
        view.addSubview(crewInfoCheckView)
        crewInfoCheckView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "크루 정보"

        // 최신 크루 데이터를 받아서 화면에 반영
        Task {
            if let crewID = try await firebaseManager.readUserCrewID() {
                firebaseManager.observeCrewDataSingle(crewID: crewID) { crewData in
                    self.crewData = crewData
                    self.updateCrewDataUI(crewData: crewData)
                }
            }
        }
    }

    // 뷰 컨트롤러의 버튼들 관련 세팅
    private func performButtonSettings() {
        crewInfoCheckView.exitCrewButton.addTarget(self, action: #selector(showCrewExitAlert), for: .touchUpInside)
        crewInfoCheckView.crewNameEditButton.addTarget(self, action: #selector(showCrewNameEditView), for: .touchUpInside)
    }

    /**
     상단 요일버튼 String 생성 메서드
     */
    func setDayButtonTitle(_ selectedDay: Set<DayOfWeek>) -> String {
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

    // 크루명 UI 업데이트
    private func updateCrewNameUI(newCrewName: String) {
        print("크루명 업데이트!!!")
        crewInfoCheckView.crewNameLabel.text = newCrewName
    }

    // MARK: - 크루 데이터에 맞게 화면 정보 갱신
    private func updateCrewDataUI(crewData: Crew?) {
        guard let crewData = crewData else {
            return
        }
        // 크루 이름
        crewInfoCheckView.crewNameLabel.text = crewData.name

        // 반복 요일 버튼 설정
        guard let repeatDay = crewData.repeatDay else {
            return
        }
        for dayInt in repeatDay {
            // 반복 요일 정수값을 DayOfWeek 값으로 변환한 값을 selectedDay에 넣어준다.
            let dayOfWeekValue = DayOfWeek(rawValue: dayInt)
            guard let dayOfWeekValue = dayOfWeekValue else {
                return
            }
            selectedDay.insert(dayOfWeekValue)
        }
        // 갱신된 selectedDay 값에 맞게 뷰에 반영
        let buttonFont = UIFont.carmuFont.subhead3
        var titleAttr = AttributedString(setDayButtonTitle(selectedDay))
        titleAttr.font = buttonFont
        titleAttr.foregroundColor = UIColor.semantic.textBody
        crewInfoCheckView.daySelectButton.configuration?.attributedTitle = titleAttr

        // 출발지, 경유지, 도착지 정보가 있는 셀 생성 후 CrewInfoCheckView의 locationCellStack에 추가
        lazy var locationCellArray: [StopoverSelectButton] = {
            var locationCellArray: [StopoverSelectButton] = []
            let crewPointsArray: [Point?] = [
                crewData.startingPoint,
                crewData.stopover1,
                crewData.stopover2,
                crewData.stopover3,
                crewData.destination
            ]
            // 경유지 포인트의 nil값 여부로 도착지의 인덱스를 계산
            // TODO: - 계산식 깔끔하게 수정하기
            var lastPointIdx = 1
            if crewData.stopover1 != nil {
                lastPointIdx = 2
            }
            if crewData.stopover2 != nil {
                lastPointIdx = 3
            }
            if crewData.stopover3 != nil {
                lastPointIdx = 4
            }
            for (index, point) in crewPointsArray.enumerated() {
                // 크루 데이터의 point들을 뷰에 반영 (경유지가 nil이 아닐 경우)
                if let point = point {
                    // 종료 지점 여부 체크
                    let isStart = (index==lastPointIdx) ? false : true
                    let stopoverButton = StopoverSelectButton(address: point.name ?? "", isStart, time: point.arrivalTime ?? Date())
                    stopoverButton.layer.shadowColor = UIColor.clear.cgColor
                    stopoverButton.tag = isStart ? index : lastPointIdx // 종료 지점은 lastPoingIdx로 태그 부여
                    stopoverButton.isEnabled = false
                    locationCellArray.append(stopoverButton)
                }
            }
            return locationCellArray
        }()
        crewInfoCheckView.locationCellStack.removeAllArrangedSubviews()
        for locationCell in locationCellArray {
            crewInfoCheckView.locationCellStack.addArrangedSubview(locationCell)
        }
    }
}

// MARK: - @objc 메서드
extension CrewInfoCheckViewController {

    // 크루명 편집 버튼 클릭 시 호출
    @objc private func showCrewNameEditView() {
        let crewNameEditVC = NameEditViewController(nowName: crewInfoCheckView.crewNameLabel.text ?? "", isCrewNameEditView: true)
        crewNameEditVC.delegate = self
        crewNameEditVC.modalPresentationStyle = .overCurrentContext
        // nameEditView의 화면 요소를 크루명에 맞게 수정
        crewNameEditVC.nameEditView.nameEditTextField.placeholder = "크루명을 입력하세요"
        crewNameEditVC.nameEditView.textFieldEditTitle.text = "크루명 편집하기"
        present(crewNameEditVC, animated: false)
    }

    // [편집] 버튼 클릭 시 호출
    @objc private func startCrewEdit() {
        print("셔틀 정보 편집 시작")
        // 내비게이션 타이틀 크루명으로 설정
        let crewEditVC = CrewEditViewController(userCrewData: crewData)
        crewEditVC.crewEditViewDelegte = self
        navigationController?.pushViewController(crewEditVC, animated: true)
    }

    // [셔틀 나가기] 버튼 클릭 시 호출 (운전자)
    @objc private func showCrewExitAlert() {
        print("셔틀 나가기 버튼 클릭됨!!")
        let alert = UIAlertController(title: "셔틀에서 나가시겠습니까?", message: "셔틀에 대한 모든 정보가 삭제됩니다.", preferredStyle: .alert)
        let back = UIAlertAction(title: "돌아가기", style: .default)
        let crewExit = UIAlertAction(title: "셔틀 나가기", style: .destructive) { _ in
            print("셔틀 나가기 처리 중...")
            Task {
                try await self.firebaseManager.deleteCrewByDriver()
                print("운전자 셔틀 나가기 처리 완료")
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(back)
        alert.addAction(crewExit)
        present(alert, animated: true)
    }
}

// MARK: - NameEditViewControllerDelegate 델리게이트 구현
extension CrewInfoCheckViewController: NameEditViewControllerDelegate {

    /**
     NameEditViewController에서 크루명 데이터가 수정되었을 때 호출
     */
    func sendNewNameValue(newName: String) {
        // 파이어베이스 DB에 변경된 크루명 반영
        guard let crewID = crewData.id else {
            return
        }
        firebaseManager.updateCrewName(crewID: crewID, newCrewName: newName)
        // 크루명 UI 업데이트
        updateCrewNameUI(newCrewName: newName)
    }
}

// MARK: - CrewEditViewDelegate 델리게이트 구현
extension CrewInfoCheckViewController: CrewEditViewDelegate {

    /**
     CrewEditViewController 에서 크루 데이터가 수정되었을 때 호출
     */
    func crewEditDoneButtonTapped(newUserCrewData: Crew?) {
        if let newUserCrewData = newUserCrewData {
            self.crewData = newUserCrewData
            // 수정된 크루 데이터에 맞게 UI 업데이트
            updateCrewDataUI(crewData: newUserCrewData)
        }
    }
}
