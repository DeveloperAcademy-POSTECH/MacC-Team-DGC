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

    private let backgroundView = SessionStartView()
    private let driverCardView = SessionStartDriverView()
    private let memberCardView = SessionStartPassengerView()
    private let noCrewCardView = SessionStartNoCrewView()

    private let firebaseManager = FirebaseManager()
    private let serverPushManager = ServerPushManager()

    var crewData: Crew? {
        didSet {
            updateView(crewData: crewData)
        }
    }
    var isCaptain: Bool {
        KeychainItem.currentUserIdentifier == crewData?.captainID
    }
    var firebaseStart: Point?
    var firebaseDestination: Point?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(driverCardView)
        view.addSubview(memberCardView)
        view.addSubview(noCrewCardView)

        backgroundView.myPageButton.addTarget(self, action: #selector(myPageButtonDidTapped), for: .touchUpInside)
        backgroundView.individualButton.addTarget(self, action: #selector(individualButtonDidTapped), for: .touchUpInside)
        backgroundView.togetherButton.addTarget(self, action: #selector(togetherButtonDidTapped), for: .touchUpInside)
        backgroundView.shuttleStartButton.addTarget(self, action: #selector(shuttleStartButtonDidTap), for: .touchUpInside)
        noCrewCardView.noCrewFrontView.createCrewButton.addTarget(self, action: #selector(createCrewButtonTapped), for: .touchUpInside)
        noCrewCardView.noCrewFrontView.inviteCodeButton.addTarget(self, action: #selector(inviteCodeButtonTapped), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if SceneDelegate.showSessionStartGuide {
            showGuide()
            SceneDelegate.showSessionStartGuide = false // 변경을 처리한 후 다시 초기화
        }
        Task {
            guard let crewID = try await firebaseManager.readUserCrewID(),
                  let crewData = try await firebaseManager.getCrewData(crewID: crewID) else {
                updateView(crewData: nil)
                return
            }
            firebaseManager.startObservingCrewData(crewID: crewID) { crewData in
                self.crewData = crewData
            }
            if isFinishedLastSession() {
                firebaseManager.endSession(crew: crewData)
                showShuttleFinishedModal()
            }
        }
    }

    /// crewData에 변경이 있으면 전체 레이아웃을 다시 그림
    private func updateView(crewData: Crew?) {
        // 타이틀 설정
        backgroundView.setTitleLabel(crewData: crewData)
        // 버튼 설정
        backgroundView.setButton(crewData: crewData)

        if let crewData = crewData {
            showCrewCardView(crewData: crewData)
        } else {
            showNoCrewCardView()
        }
    }
}

// MARK: - UI update
extension SessionStartViewController {

    // UI를 업데이트 시켜줌
    private func showCrewCardView(crewData: Crew) {
        if isCaptain {
            settingDriverData(crewData: crewData)
        } else {
            settingPassengerData(crewData: crewData)
        }

        checkingCrewStatus(crewData: crewData)

        if isCaptain {
            driverCardView.driverFrontView.crewData = crewData
            driverCardView.driverFrontView.settingDriverFrontData(crewData: crewData)
            driverCardView.driverFrontView.crewCollectionView.reloadData()
        } else {
            memberCardView.passengerFrontView.settingPassengerFrontData(crewData: crewData)

            if crewData.sessionStatus == .accept {  // 운전자가 운행할 때
                memberCardView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
                memberCardView.passengerFrontView.statusLabel.text = "오늘은 카풀이 운행될 예정이에요"
            }

            // 탑승자의 참석 여부에 따른 분기문
            if firebaseManager.passengerStatus(crewData: crewData) == .accept {
                backgroundView.notifyComment.text = "함께가기를 선택하셨네요!\n운전자에게 알려드릴게요"
            } else if firebaseManager.passengerStatus(crewData: crewData) == .decline {
                switch crewData.sessionStatus {
                case .waiting:
                    backgroundView.notifyComment.text = "따로가기를 선택하셨네요!\n운전자에게 알려드릴게요"
                case .accept:
                    memberCardView.passengerFrontView.noDriveComment.text = "오늘은 카풀에 참여하지 않으시군요!\n내일 봐요!"
                    memberCardView.passengerFrontView.noDriveComment.textColor = UIColor.semantic.textPrimary
                    backgroundView.notifyComment.text = ""
                    memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = false
                case .decline: break
                case .sessionStart: break
                    // sessionStart일 때는 해당 버튼이 나타나지 않음
                case .none: break
                }
            }
        }

        noCrewCardView.isHidden = true
        if isCaptain {
            settingDriverView(crewData: crewData)
        } else {
            settingPassengerView(crewData: crewData)
        }
    }
}

// MARK: - 크루가 없을 때
extension SessionStartViewController {

    private func showNoCrewCardView() {
        backgroundView.notifyComment.isHidden = true

        driverCardView.isHidden = true
        memberCardView.isHidden = true
        noCrewCardView.isHidden = false

        noCrewCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(backgroundView.titleLabel.snp.bottom).offset(36)
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

    // 운전자일 때
    private func settingDriverData(crewData: Crew) {
        switch crewData.sessionStatus {
        case .waiting:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
        case .accept:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
        case .decline:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = false
            backgroundView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"
            settingDataDecline()
        case .sessionStart:
            settingDataSessionStart(crewData: crewData)
        case .none: break
        }
    }

    // 동승자일 때
    private func settingPassengerData(crewData: Crew) {
        switch crewData.sessionStatus {
        case .waiting:
            memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = true
            memberCardView.passengerFrontView.statusImageView.image = UIImage(named: "HourglassBlinker")
            memberCardView.passengerFrontView.statusLabel.text = "운전자의 확인을 기다리고 있어요"
        case .accept:
            // 당일 운행이 없다는 뷰 숨기기
            memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = true
            memberCardView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
            memberCardView.passengerFrontView.statusLabel.text = "오늘은 카풀이 운행될 예정이에요"
        case .decline:
            memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = false
            memberCardView.passengerFrontView.noDriveComment.text = "오늘은 카풀이 운행되지 않아요"
            memberCardView.passengerFrontView.noDriveComment.textColor = UIColor.semantic.negative
            backgroundView.notifyComment.text = "운전자의 사정으로\n오늘은 카풀이 운행되지 않아요"
            settingDataDecline()
        case .sessionStart:
            memberCardView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
            memberCardView.passengerFrontView.statusLabel.text = "오늘은 카풀이 운행될 예정이에요"
            settingDataSessionStart(crewData: crewData)
        case .none: break
        }
    }

    // 공통(운전자, 탑승자)으로 사용되는 메서드
    // settingData - .decline
    private func settingDataDecline() {
        driverCardView.layer.opacity = 1.0
    }

    // settingData - .sessionStart
    private func settingDataSessionStart(crewData: Crew) {
        backgroundView.shuttleStartButton.isHidden = false
        driverCardView.layer.opacity = 1.0
        backgroundView.shuttleStartButton.setTitle("셔틀 지도보기", for: .normal)

        // notifyComment 변경하기
        backgroundView.notifyComment.text = "현재 운행중인 카풀이 있습니다.\n카풀 지도보기를 눌러주세요!"
        let attributedText = NSMutableAttributedString(string: backgroundView.notifyComment.text ?? "")
        if let range1 = backgroundView.notifyComment.text?.range(of: "현재 운행중인 카풀") {
            let nsRange1 = NSRange(range1, in: backgroundView.notifyComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.textTertiary as Any, range: nsRange1)
        }
        if let range2 = backgroundView.notifyComment.text?.range(of: "카풀 지도보기") {
            let nsRange2 = NSRange(range2, in: backgroundView.notifyComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.textTertiary as Any, range: nsRange2)
        }
        backgroundView.notifyComment.attributedText = attributedText
    }
}

// MARK: - 크루가 있을 때 - 운전자일 때
extension SessionStartViewController {

    // MARK: - ViewWillAppear에서 하면 될 듯,,?
    private func settingDriverView(crewData: Crew) {
        // 비활성화
        driverCardView.layer.opacity = 0.5

        backgroundView.notifyComment.text = "오늘의 카풀 운행 여부를\n출발시간 30분 전까지 알려주세요!"
        let notifyCommentText = NSMutableAttributedString(string: backgroundView.notifyComment.text ?? "")
        if let range2 = backgroundView.notifyComment.text?.range(of: "30분 전") {
            let nsRange2 = NSRange(range2, in: backgroundView.notifyComment.text ?? "")
            notifyCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.textPrimary as Any, range: nsRange2)
        }
        backgroundView.notifyComment.attributedText = notifyCommentText

        // view layout
        driverCardView.isHidden = false
        memberCardView.isHidden = true

        driverCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(backgroundView.myPageButton.snp.bottom).offset(88)
            make.bottom.lessThanOrEqualToSuperview().inset(216)
        }

        backgroundView.notifyComment.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(driverCardView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    func showShuttleFinishedModal() {
        present(SessionFinishViewController(), animated: true)
    }
}

// MARK: - 크루가 있을 때 - 크루원일 때
extension SessionStartViewController {

    private func settingPassengerView(crewData: Crew) {
        backgroundView.notifyComment.text = ""

        // view layout
        driverCardView.isHidden = true
        memberCardView.isHidden = false

        memberCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(backgroundView.myPageButton.snp.bottom).offset(88)
            make.bottom.lessThanOrEqualToSuperview().inset(216)
        }

        backgroundView.notifyComment.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(memberCardView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: @objc Method
extension SessionStartViewController {

    @objc private func myPageButtonDidTapped() {
        let myPageVC = MyPageViewController()
        myPageVC.crewData = crewData
        navigationController?.pushViewController(myPageVC, animated: true)
    }

    @objc private func togetherButtonDidTapped() {
        if isCaptain {
            firebaseManager.driverTogetherButtonTapped(crewData: crewData)

            // 활성화
            driverCardView.layer.opacity = 1.0

            backgroundView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"

        } else {
            firebaseManager.passengerTogetherButtonTapped(crewData: crewData)
        }
    }

    @objc private func shuttleStartButtonDidTap() {
        guard let crew = crewData, let sessionStatus = crew.sessionStatus else { return }

        // accept에서 클릭했을 때 서버 푸시 보내기
        if sessionStatus == .accept {
            serverPushManager.pushToAllPassenger(crewData: crew)
        }

        // sessionStatus -> sessionStart는 MapViewController 내부에서 변경

        let mapView = MapViewController(crew: crew)
        mapView.modalPresentationStyle = .fullScreen
        present(mapView, animated: true, completion: nil)
    }

    @objc private func individualButtonDidTapped() {
        guard let crewData = crewData else { return }
        if isCaptain {
            settingIndividualButtonForDriver(crewData: crewData)
        } else {
            firebaseManager.passengerIndividualButtonTapped(crewData: crewData)
        }
    }

    @objc private func createCrewButtonTapped() {
        navigationController?.pushViewController(CrewNameSettingViewController(), animated: true)
    }

    @objc private func inviteCodeButtonTapped() {
        navigationController?.pushViewController(InviteCodeInputViewController(), animated: true)
    }
}

// MARK: - individualButton Methods
extension SessionStartViewController {

    // 운전자일 때
    private func settingIndividualButtonForDriver(crewData: Crew) {
        firebaseManager.driverIndividualButtonTapped(crewData: crewData)

        // 모든 경우에 같은 화면임
        backgroundView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"
        driverCardView.driverFrontView.noDriveViewForDriver.isHidden = false
        driverCardView.driverFrontView.crewCollectionView.isHidden = true   // 컬렉션뷰 가리고 오늘 가지 않는다는 뷰 보여주기
        driverCardView.layer.opacity = 1.0
    }
}

// MARK: - Action
extension SessionStartViewController {

    // 함께하는 크루원이 한 명 이상일 때 버튼 Enable
    private func checkingCrewStatus(crewData: Crew) {
        if firebaseManager.isAnyMemberAccepted(crewData: crewData) {
            backgroundView.shuttleStartButton.isEnabled = true
            backgroundView.notifyComment.text = "현재 탑승 응답한 크루원들과\n여정을 시작할까요?"
            backgroundView.shuttleStartButton.backgroundColor = UIColor.semantic.accPrimary
        } else {
            backgroundView.shuttleStartButton.isEnabled = false
            backgroundView.shuttleStartButton.backgroundColor = UIColor.semantic.backgroundThird
        }
    }

    // 가이드 화면 보여주는 메서드
    private func showGuide() {
        let ruleDescriptionViewController = RuleDescriptionViewController()
        ruleDescriptionViewController.modalPresentationStyle = .overCurrentContext
        present(ruleDescriptionViewController, animated: true)
    }

    // 이전 세션이 종료되었는지 확인하는 메서드
    private func isFinishedLastSession() -> Bool {
        guard isCaptain,
              let crew = crewData, crew.sessionStatus == .sessionStart,
              let startTime = crew.startingPoint?.arrivalTime?.toString24HourClock.toMinutes,
              let arrivalTime = crew.destination?.arrivalTime?.toString24HourClock.toMinutes else {
            return false
        }
        let now = Date().toString24HourClock.toMinutes
        return now < startTime && now > arrivalTime + crew.lateTime + 10
    }
}

extension SessionStartViewController {

    // 디바이스 토큰값이 업데이트가 될 수도 있기 때문에 업데이트된 값을 저장하기 위한 메서드
    private func settingDeviceToken() {
        print("settingDeviceToken()")
        guard let databasePath = User.databasePathWithUID else { return }
        guard let fcmToken = KeychainItem.currentUserDeviceToken else { return }
        print("FCMToken -> ", fcmToken)
        databasePath.child("deviceToken").setValue(fcmToken as NSString)
    }
}
