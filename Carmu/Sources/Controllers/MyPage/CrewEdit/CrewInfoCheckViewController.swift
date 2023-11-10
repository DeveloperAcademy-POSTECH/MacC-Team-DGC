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

    var crewInfoData: Crew? // 크루 데이터

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        // TODO: - 크루 데이터 불러오기
        guard let crewData = crewData else {
            return
        }
        crewInfoData = crewData

        // 백버튼 텍스트 제거
        navigationController?.navigationBar.topItem?.title = ""
        // 설정 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: self,
            action: #selector(startCrewEdit)
        )

        performButtonSettings()
        view.addSubview(crewInfoCheckView)
        crewInfoCheckView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "크루 정보"
    }

    // 뷰 컨트롤러의 버튼들 관련 세팅
    private func performButtonSettings() {
        crewInfoCheckView.daySelectButton.setTitle(
            // TODO: 크루에 설정된 정보 받아서 세팅하도록 수정해야 함
            setDayButtonTitle(selectedDay),
            for: .normal
        )
        crewInfoCheckView.exitCrewButton.addTarget(
            self,
            action: #selector(exitCrewButtonTapped),
            for: .touchUpInside
        )
        crewInfoCheckView.crewNameEditButton.addTarget(
            self,
            action: #selector(showCrewNameEditView),
            for: .touchUpInside
        )
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

    // 크루 정보 화면에서 편집된 크루면으로 업데이트
    private func updateCrewName(newCrewName: String) {
        print("크루명 업데이트!!!")
        crewInfoCheckView.crewNameLabel.text = newCrewName
    }
}

// MARK: - @objc 메서드
extension CrewInfoCheckViewController {

    // 크루명 편집 버튼 클릭 시 호출
    @objc private func showCrewNameEditView() {
        let crewNameEditVC = NameEditViewController(
            nowName: crewInfoCheckView.crewNameLabel.text ?? "",
            isCrewNameEditView: true
        )
        crewNameEditVC.delegate = self
        crewNameEditVC.modalPresentationStyle = .overCurrentContext
        // nameEditView의 화면 요소를 크루명에 맞게 수정
        crewNameEditVC.nameEditView.nameEditTextField.placeholder = "크루명을 입력하세요"
        crewNameEditVC.nameEditView.textFieldEditTitle.text = "크루명 편집하기"
        present(crewNameEditVC, animated: false)
    }

    // [편집] 버튼 클릭 시 호출
    @objc private func startCrewEdit() {
        // TODO: - 구현하기
        print("크루 정보 편집 시작")
    }

    // [크루 나가기] 버튼 클릭 시 호출
    @objc private func exitCrewButtonTapped() {
        // TODO: - 구현 필요
        print("크루 나가기 버튼 클릭됨!!")
    }
}

// MARK: - NameEditViewControllerDelegate 델리게이트 구현
extension CrewInfoCheckViewController: NameEditViewControllerDelegate {

    /**
     NameEditViewController에서 닉네임 데이터가 수정되었을 때 호출
     */
    func sendNewNameValue(newName: String) {
        updateCrewName(newCrewName: newName)
    }
}
