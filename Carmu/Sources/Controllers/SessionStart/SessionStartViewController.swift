//
//  SessionStartViewController.swift
//  Carmu
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

import Firebase
import FirebaseDatabase
import FirebaseFunctions
import FirebaseMessaging
import SnapKit

final class SessionStartViewController: UIViewController {

    private let sessionStartView = SessionStartView()
    private lazy var sessionStartDriverView = SessionStartDriverView()
    private lazy var sessionStartPassengerView = SessionStartPassengerView()
    private lazy var sessionStartNoCrewView = SessionStartNoCrewView()
    private lazy var firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        setupUI()
        setupConstraints()
        setTargetButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        checkCrew()

        // TODO: - 비동기 처리로 변경해주기
        settingData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if SceneDelegate.isCrewCreated {
            showGuide()
            SceneDelegate.isCrewCreated = false // 변경을 처리한 후 다시 초기화
        }
    }

    private func showGuide() {
        let ruleDescriptionViewController = RuleDescriptionViewController()
        ruleDescriptionViewController.modalPresentationStyle = .overCurrentContext
        present(ruleDescriptionViewController, animated: true)
    }

}

// MARK: Layout
extension SessionStartViewController {
    private func setupUI() {
        view.addSubview(sessionStartView)
        view.addSubview(sessionStartDriverView)
        view.addSubview(sessionStartPassengerView)
        view.addSubview(sessionStartNoCrewView)
    }
    private func setupConstraints() {
        sessionStartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - 크루가 없을 때
extension SessionStartViewController {

    private func settingNoCrewView() {
        sessionStartView.topComment.text = "오늘도 카뮤와 함께\n즐거운 카풀 생활되세요!"
        let attributedText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "카뮤") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        if let range2 = sessionStartView.topComment.text?.range(of: "카풀 생활") {
            let nsRange2 = NSRange(range2, in: sessionStartView.topComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange2)
        }
        sessionStartView.topComment.attributedText = attributedText

        sessionStartDriverView.isHidden = true
        sessionStartPassengerView.isHidden = true
        sessionStartNoCrewView.isHidden = false

        sessionStartNoCrewView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(sessionStartView.topComment.snp.bottom).offset(36)
            make.bottom.lessThanOrEqualToSuperview().inset(165)
            make.bottom.equalToSuperview().inset(165)
        }
    }
}

// MARK: - 크루가 있을 때 - 공통
/**
 경우의 수가 매우 많아 헷갈리지 않기 위해 모든 메서드를 다음과 같이 분리하겠습니다.
    if 운전자인 경우
        - waiting
        - accept
        - decline
        - sessionStart
    else 동승자인 경우
        - waiting
        - accept
        - decline
        - sessionStart
 */
extension SessionStartViewController {

    private func settingCrewView() {
        sessionStartNoCrewView.isHidden = true
        if isCaptain() {
            settingDriverView()
        } else {
            settingPassengerView()
        }
    }

    private func settingData() {

        // 운전자일 때
        if isCaptain() {
            settingDriverData()
        } else {    // 동승자일 때
            settingPassengerData()
        }
    }

    // 운전자일 때
    private func settingDriverData() {
        guard let crewData = crewData else { return }

        switch crewData.sessionStatus {
        case .waiting:
            sessionStartDriverView.driverFrontView.noDriveViewForDriver.isHidden = true
        case .accept:
            sessionStartDriverView.driverFrontView.noDriveViewForDriver.isHidden = true
        case .decline:
            sessionStartDriverView.driverFrontView.noDriveViewForDriver.isHidden = false
            sessionStartView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"

            settingDataDecline()
        case .sessionStart:
            settingDataSessionStart()
        }
    }

    // 동승자일 때
    private func settingPassengerData() {
        guard let crewData = crewData else { return }

        switch crewData.sessionStatus {
        case .waiting:
            sessionStartPassengerView.passengerFrontView.noDriveViewForPassenger.isHidden = true
            sessionStartPassengerView.passengerFrontView.statusImageView.image = UIImage(named: "HourglassBlinker")
            sessionStartPassengerView.passengerFrontView.statusLabel.text = "운전자의 확인을 기다리고 있어요"
        case .accept:
            // 당일 운행이 없다는 뷰 숨기기
            sessionStartPassengerView.passengerFrontView.noDriveViewForPassenger.isHidden = true
            sessionStartPassengerView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
            sessionStartPassengerView.passengerFrontView.statusLabel.text = "오늘은 카풀이 운행될 예정이에요"
        case .decline:
            sessionStartPassengerView.passengerFrontView.noDriveViewForPassenger.isHidden = false
            sessionStartPassengerView.passengerFrontView.noDriveComment.text = "오늘은 카풀이 운행되지 않아요"
            sessionStartPassengerView.passengerFrontView.noDriveComment.textColor = UIColor.semantic.negative
            sessionStartView.notifyComment.text = "운전자의 사정으로\n오늘은 카풀이 운행되지 않아요"

            settingDataDecline()
        case .sessionStart:
            settingDataSessionStart()
        }
    }

    // 공통으로 사용되는 것
    // settingData - .decline
    private func settingDataDecline() {
        sessionStartView.topComment.text = ""
        sessionStartDriverView.layer.opacity = 1.0
        sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
        sessionStartView.individualButton.isEnabled = false
        sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
        sessionStartView.togetherButton.isEnabled = false
    }

    // settingData - .sessionStart
    private func settingDataSessionStart() {
        sessionStartView.individualButton.isHidden = true
        sessionStartView.togetherButton.isHidden = true
        sessionStartView.carpoolStartButton.isHidden = false
        sessionStartDriverView.layer.opacity = 1.0
        sessionStartView.carpoolStartButton.setTitle("카풀 지도보기", for: .normal)

        // notifyComment 변경하기
        sessionStartView.notifyComment.text = "현재 운행중인 카풀이 있습니다.\n카풀 지도보기를 눌러주세요!"
        let attributedText = NSMutableAttributedString(string: sessionStartView.notifyComment.text ?? "")
        if let range1 = sessionStartView.notifyComment.text?.range(of: "현재 운행중인 카풀") {
            let nsRange1 = NSRange(range1, in: sessionStartView.notifyComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.textTertiary as Any,
                                        range: nsRange1)
        }
        if let range2 = sessionStartView.notifyComment.text?.range(of: "카풀 지도보기") {
            let nsRange2 = NSRange(range2, in: sessionStartView.notifyComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.textTertiary as Any,
                                        range: nsRange2)
        }
        sessionStartView.notifyComment.attributedText = attributedText
    }
}

// MARK: - 크루가 있을 때 - 운전자일 때
extension SessionStartViewController {

    private func settingDriverView() {

        // 비활성화
        sessionStartDriverView.layer.opacity = 0.5
        // comment
        sessionStartView.topComment.text = "\(crewData?.name ?? "그룹명"),\n오늘 운행하시나요?"
        // 특정 부분 색상 넣기
        let topCommentText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "\(crewData?.name ?? "그룹명")") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text ?? "")
            topCommentText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        sessionStartView.topComment.attributedText = topCommentText

        sessionStartView.notifyComment.text = "오늘의 카풀 운행 여부를\n출발시간 30분 전까지 알려주세요!"
        let notifyCommentText = NSMutableAttributedString(string: sessionStartView.notifyComment.text ?? "")
        if let range2 = sessionStartView.notifyComment.text?.range(of: "30분 전") {
            let nsRange2 = NSRange(range2, in: sessionStartView.notifyComment.text ?? "")
            notifyCommentText.addAttribute(NSAttributedString.Key.foregroundColor,
                                           value: UIColor.semantic.textPrimary as Any,
                                           range: nsRange2)
        }
        sessionStartView.notifyComment.attributedText = notifyCommentText

        sessionStartView.individualButton.setTitle("운행하지 않아요", for: .normal)
        sessionStartView.togetherButton.setTitle("운행해요", for: .normal)

        settingDriverUI()
        settingDriverConstraints()
    }

    // Driver UI
    private func settingDriverUI() {

        // view layout
        sessionStartDriverView.isHidden = false
        sessionStartPassengerView.isHidden = true

        // button layout
        sessionStartView.individualButton.isHidden = false
        sessionStartView.togetherButton.isHidden = false
        sessionStartView.carpoolStartButton.isHidden = true
    }

    // Driver Layout
    private func settingDriverConstraints() {
        sessionStartDriverView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(sessionStartView.myPageButton.snp.bottom).offset(88)
            make.bottom.lessThanOrEqualToSuperview().inset(216)
        }
        sessionStartView.notifyComment.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(sessionStartDriverView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        sessionStartView.individualButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(sessionStartView.notifyComment.snp.bottom).offset(20)
            make.width.lessThanOrEqualTo(170)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
        sessionStartView.togetherButton.snp.makeConstraints { make in
            make.leading.equalTo(sessionStartView.individualButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(sessionStartView.notifyComment.snp.bottom).offset(20)
            make.width.equalTo(sessionStartView.individualButton.snp.width)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
        sessionStartView.carpoolStartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(sessionStartView.notifyComment.snp.bottom).offset(20)
            make.width.lessThanOrEqualTo(350)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

// MARK: - 크루가 있을 때 - 크루원일 때
extension SessionStartViewController {

    private func settingPassengerView() {
        sessionStartView.topComment.text = "\(crewData?.name ?? "그룹명")과\n함께 가시나요?"
        // 특정 부분 색상 넣기
        let topCommentText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "\(crewData?.name ?? "그룹명")") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text ?? "")
            topCommentText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        sessionStartView.topComment.attributedText = topCommentText

        sessionStartView.notifyComment.text = ""

        sessionStartView.individualButton.setTitle("따로가요", for: .normal)
        sessionStartView.togetherButton.setTitle("함께가요", for: .normal)

        settingPassengerUI()
        settingPassengerConstraints()
    }

    // Passenger UI
    private func settingPassengerUI() {

        // view layout
        sessionStartDriverView.isHidden = true
        sessionStartPassengerView.isHidden = false

        // button layout
        sessionStartView.individualButton.isHidden = false
        sessionStartView.togetherButton.isHidden = false
        sessionStartView.carpoolStartButton.isHidden = true
    }
    // Passenger Layout
    private func settingPassengerConstraints() {
        sessionStartPassengerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(sessionStartView.myPageButton.snp.bottom).offset(88)
            make.bottom.lessThanOrEqualToSuperview().inset(216)
        }
        sessionStartView.notifyComment.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(sessionStartPassengerView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        sessionStartView.individualButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(sessionStartView.notifyComment.snp.bottom).offset(20)
            make.width.lessThanOrEqualTo(170)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
        sessionStartView.togetherButton.snp.makeConstraints { make in
            make.leading.equalTo(sessionStartView.individualButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(sessionStartView.notifyComment.snp.bottom).offset(20)
            make.width.equalTo(sessionStartView.individualButton.snp.width)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
        sessionStartView.carpoolStartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(sessionStartView.notifyComment.snp.bottom).offset(20)
            make.width.lessThanOrEqualTo(350)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

// MARK: @objc Method
extension SessionStartViewController {

    @objc private func myPageButtonDidTapped() {
        let myPageVC = MyPageViewController()
        navigationController?.pushViewController(myPageVC, animated: true)
    }

    @objc private func togetherButtonDidTapped() {

        // 운전자일 때
        if isCaptain() {
            sessionStartView.individualButton.isHidden = true
            sessionStartView.togetherButton.isHidden = true
            sessionStartView.carpoolStartButton.isHidden = false

            // 활성화
            sessionStartDriverView.layer.opacity = 1.0

            // notifyComment 변경
            sessionStartView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"

            checkingCrewStatus()

            // TODO: - 실제 데이터로 변경
            crewData?.sessionStatus = .accept
            sessionStartDriverView.driverFrontView.crewCollectionView.reloadData()
        } else {    // 동승자일 때
            if crewData?.sessionStatus == .accept {  // 운전자가 운행할 때
                sessionStartPassengerView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
                sessionStartPassengerView.passengerFrontView.statusLabel.text = "오늘은 카풀이 운행될 예정이에요"
            }
            sessionStartView.notifyComment.text = "함께가기를 선택하셨네요!\n운전자에게 알려드릴게요"
            sessionStartView.individualButton.backgroundColor = UIColor.semantic.negative
            sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
        }
    }

    @objc private func carpoolStartButtonDidTapped() {
        // 세션 시작으로 상태 변경
        crewData?.sessionStatus = .sessionStart

        let mapView = MapViewController()
        mapView.modalPresentationStyle = .fullScreen
        present(mapView, animated: true, completion: nil)
    }

    // TODO: - 실제 데이터로 변경
    @objc private func individualButtonDidTapped() {

        // 운전자가 클릭했을 때
        if isCaptain() {
            sessionStartView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"
            sessionStartDriverView.driverFrontView.noDriveViewForDriver.isHidden = false
            sessionStartDriverView.driverFrontView.crewCollectionView.isHidden = true   // 컬렉션뷰 가리고 오늘 가지 않는다는 뷰 보여주기
            sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
            sessionStartView.individualButton.isEnabled = false
            sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
            sessionStartView.togetherButton.isEnabled = false
            sessionStartDriverView.layer.opacity = 1.0
        } else {    // 크루원이 클릭했을 때 -> 텍스트 변경
            if crewData?.sessionStatus == .waiting {    // 운전자가 미응답일 때
                sessionStartView.notifyComment.text = "따로가기를 선택하셨네요!\n운전자에게 알려드릴게요"
                sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.togetherButton.backgroundColor = UIColor.semantic.accPrimary
            } else if crewData?.sessionStatus == .accept {  // 운전자가 운행할 때
                sessionStartView.topComment.text = ""
                sessionStartPassengerView.passengerFrontView.noDriveComment.text = "오늘은 카풀에 참여하지 않으시군요!\n내일 봐요!"
                sessionStartPassengerView.passengerFrontView.noDriveComment.textColor = UIColor.semantic.textPrimary
                sessionStartView.notifyComment.text = ""
                sessionStartPassengerView.passengerFrontView.noDriveViewForPassenger.isHidden = false
                sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.individualButton.isEnabled = false
                sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.togetherButton.isEnabled = false
            } else if crewData?.sessionStatus == .decline {    // 운전자가 거절했을 때
                sessionStartView.topComment.text = ""
                sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.individualButton.isEnabled = false
                sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.togetherButton.isEnabled = false
            }

        }
    }
}

// MARK: - Action
extension SessionStartViewController {

    /// 크루의 유무 확인
    private func checkCrew() {
        if crewData == nil {
            settingNoCrewView()
        } else {
            settingCrewView()
        }
    }

    /// 버튼들 addTarget
    private func setTargetButton() {
        sessionStartView.myPageButton.addTarget(self, action: #selector(myPageButtonDidTapped), for: .touchUpInside)
        sessionStartView.individualButton.addTarget(self,
                                                    action: #selector(individualButtonDidTapped),
                                                    for: .touchUpInside)
        sessionStartView.togetherButton.addTarget(self,
                                                  action: #selector(togetherButtonDidTapped),
                                                  for: .touchUpInside)
        sessionStartView.carpoolStartButton.addTarget(self,
                                                      action: #selector(carpoolStartButtonDidTapped),
                                                      for: .touchUpInside)
    }

    // TODO: - Firebase 형식에 맞게 변경
    /// 운전자인지 여부 확인
    private func isCaptain() -> Bool {
        crewData?.captainID == "ted"
    }

    // TODO: - 실제 데이터로 변경 및 데이터 값 변경될 때 Observer로 확인
    // 함께하는 크루원이 한 명 이상일 때 버튼 Enable
    private func checkingCrewStatus() {
        guard let crewData = crewData else { return }

        // crewStatus를 순회하면서 .accept 상태의 크루원 확인
        let isAnyCrewAccepted = crewData.crewStatus.values.contains { status in
            return status == .accept
        }

        if isAnyCrewAccepted {  // 수락한 크루원이 한 명이라도 있을 경우
            sessionStartView.carpoolStartButton.isEnabled = true
            sessionStartView.notifyComment.text = "현재 탑승 응답한 크루원들과\n여정을 시작할까요?"
        } else {    // 수락한 크루원이 없을 때
            sessionStartView.carpoolStartButton.isEnabled = false
            sessionStartView.carpoolStartButton.backgroundColor = UIColor.semantic.backgroundThird
        }
    }
}

extension SessionStartViewController {

    // 디바이스 토큰값이 업데이트가 될 수도 있기 때문에 업데이트된 값을 저장하기 위한 메서드
    private func settingDeviceToken() {
        print("settingDeviceToken()")
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        guard let fcmToken = KeychainItem.currentUserDeviceToken else {
            return
        }
        print("FCMToken -> ", fcmToken)
        databasePath.child("deviceToken").setValue(fcmToken as NSString)
    }
}
