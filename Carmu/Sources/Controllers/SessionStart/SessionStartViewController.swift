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

    private let startView = SessionStartView()
    private let driverCardView = SessionStartDriverView()
    private let memberCardView = SessionStartPassengerView()
    private let noCrewCardView = SessionStartNoCrewView()

    private let firebaseManager = FirebaseManager()
    private let serverPushManager = ServerPushManager()

    var crewData: Crew? {
        didSet {
            if let crewData = crewData {
                updateUI(crewData: crewData)
                settingCrewView(crewData: crewData)
            } else {
                showNoCrewView()
            }
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

        view.addSubview(startView)
        startView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(driverCardView)
        view.addSubview(memberCardView)
        view.addSubview(noCrewCardView)

        startView.myPageButton.addTarget(self, action: #selector(myPageButtonDidTapped), for: .touchUpInside)
        startView.individualButton.addTarget(self, action: #selector(individualButtonDidTapped), for: .touchUpInside)
        startView.togetherButton.addTarget(self, action: #selector(togetherButtonDidTapped), for: .touchUpInside)
        startView.carpoolStartButton.addTarget(self, action: #selector(carpoolStartButtonDidTapped), for: .touchUpInside)
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
            if let crewID = try await firebaseManager.readUserCrewID(),
               let crewData = try await firebaseManager.getCrewData(crewID: crewID) {
                firebaseManager.startObservingCrewData(crewID: crewID) { crewData in
                    self.crewData = crewData
                }
                if isFinishedLastSession() {
                    firebaseManager.endSession(crew: crewData)
                    showShuttleFinishedModal()
                }
            } else {
                showNoCrewView()
            }
        }
    }
}

// MARK: - UI update
extension SessionStartViewController {

    // UI를 업데이트 시켜줌
    private func updateUI(crewData: Crew) {
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
                startView.notifyComment.text = "함께가기를 선택하셨네요!\n운전자에게 알려드릴게요"
                startView.individualButton.backgroundColor = UIColor.semantic.negative
                startView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
            } else if firebaseManager.passengerStatus(crewData: crewData) == .decline {
                switch crewData.sessionStatus {
                case .waiting:
                    startView.notifyComment.text = "따로가기를 선택하셨네요!\n운전자에게 알려드릴게요"
                    startView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
                    startView.togetherButton.backgroundColor = UIColor.semantic.accPrimary
                case .accept:
                    startView.topComment.text = ""
                    memberCardView.passengerFrontView.noDriveComment.text = "오늘은 카풀에 참여하지 않으시군요!\n내일 봐요!"
                    memberCardView.passengerFrontView.noDriveComment.textColor = UIColor.semantic.textPrimary
                    startView.notifyComment.text = ""
                    memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = false
                    startView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
                    startView.individualButton.isEnabled = false
                    startView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
                    startView.togetherButton.isEnabled = false
                case .decline:
                    startView.topComment.text = ""
                    startView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
                    startView.individualButton.isEnabled = false
                    startView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
                    startView.togetherButton.isEnabled = false
                case .sessionStart: break
                    // sessionStart일 때는 해당 버튼이 나타나지 않음
                case .none: break
                }
            }
        }
    }
}

// MARK: - 크루가 없을 때
extension SessionStartViewController {

    private func showNoCrewView() {
        startView.topComment.text = "오늘도 카뮤와 함께\n즐거운 카풀 생활되세요!"
        let attributedText = NSMutableAttributedString(string: startView.topComment.text ?? "")
        if let range1 = startView.topComment.text?.range(of: "카뮤") {
            let nsRange1 = NSRange(range1, in: startView.topComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange1)
        }
        if let range2 = startView.topComment.text?.range(of: "카풀 생활") {
            let nsRange2 = NSRange(range2, in: startView.topComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange2)
        }
        startView.topComment.attributedText = attributedText

        startView.notifyComment.isHidden = true
        startView.individualButton.isHidden = true
        startView.togetherButton.isHidden = true
        startView.carpoolStartButton.isHidden = true

        driverCardView.isHidden = true
        memberCardView.isHidden = true
        noCrewCardView.isHidden = false

        noCrewCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(startView.topComment.snp.bottom).offset(36)
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

    // 크루가 있을 때의 세팅
    private func settingCrewView(crewData: Crew) {
        noCrewCardView.isHidden = true
        if isCaptain {
            settingDriverView(crewData: crewData)
        } else {
            settingPassengerView(crewData: crewData)
        }
    }

    // 운전자일 때
    private func settingDriverData(crewData: Crew) {
        switch crewData.sessionStatus {
        case .waiting:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
        case .accept:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
        case .decline:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = false
            startView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"
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
            startView.notifyComment.text = "운전자의 사정으로\n오늘은 카풀이 운행되지 않아요"
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
        startView.topComment.text = ""
        driverCardView.layer.opacity = 1.0
        startView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
        startView.individualButton.isEnabled = false
        startView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
        startView.togetherButton.isEnabled = false
    }

    // settingData - .sessionStart
    private func settingDataSessionStart(crewData: Crew) {
        startView.individualButton.isHidden = true
        startView.togetherButton.isHidden = true
        startView.carpoolStartButton.isHidden = false
        driverCardView.layer.opacity = 1.0
        startView.carpoolStartButton.setTitle("카풀 지도보기", for: .normal)

        // topComment 변경
        startView.topComment.text = "\(crewData.name ?? "그룹명")이\n시작되었습니다"
        // 특정 부분 색상 넣기
        let topCommentText = NSMutableAttributedString(string: startView.topComment.text ?? "")
        if let range1 = startView.topComment.text?.range(of: "\(crewData.name ?? "그룹명")") {
            let nsRange1 = NSRange(range1, in: startView.topComment.text ?? "")
            topCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange1)
        }
        startView.topComment.attributedText = topCommentText

        // notifyComment 변경하기
        startView.notifyComment.text = "현재 운행중인 카풀이 있습니다.\n카풀 지도보기를 눌러주세요!"
        let attributedText = NSMutableAttributedString(string: startView.notifyComment.text ?? "")
        if let range1 = startView.notifyComment.text?.range(of: "현재 운행중인 카풀") {
            let nsRange1 = NSRange(range1, in: startView.notifyComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.textTertiary as Any, range: nsRange1)
        }
        if let range2 = startView.notifyComment.text?.range(of: "카풀 지도보기") {
            let nsRange2 = NSRange(range2, in: startView.notifyComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.textTertiary as Any, range: nsRange2)
        }
        startView.notifyComment.attributedText = attributedText
    }
}

// MARK: - 크루가 있을 때 - 운전자일 때
extension SessionStartViewController {

    // MARK: - ViewWillAppear에서 하면 될 듯,,?
    private func settingDriverView(crewData: Crew) {
        // 비활성화
        driverCardView.layer.opacity = 0.5
        // comment
        let crewName = crewData.name ?? ""

        startView.topComment.text = "\(String(describing: crewName)),\n오늘 운행하시나요?"
        // 특정 부분 색상 넣기
        let topCommentText = NSMutableAttributedString(string: startView.topComment.text ?? "")
        if let range1 = startView.topComment.text?.range(of: "\(String(describing: crewName))") {
            let nsRange1 = NSRange(range1, in: startView.topComment.text ?? "")
            topCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange1)
        }
        startView.topComment.attributedText = topCommentText

        startView.notifyComment.text = "오늘의 카풀 운행 여부를\n출발시간 30분 전까지 알려주세요!"
        let notifyCommentText = NSMutableAttributedString(string: startView.notifyComment.text ?? "")
        if let range2 = startView.notifyComment.text?.range(of: "30분 전") {
            let nsRange2 = NSRange(range2, in: startView.notifyComment.text ?? "")
            notifyCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.textPrimary as Any, range: nsRange2)
        }
        startView.notifyComment.attributedText = notifyCommentText

        startView.individualButton.setTitle("운행하지 않아요", for: .normal)
        startView.togetherButton.setTitle("운행해요", for: .normal)

        // view layout
        driverCardView.isHidden = false
        memberCardView.isHidden = true

        // button layout
        startView.individualButton.isHidden = false
        startView.togetherButton.isHidden = false
        startView.carpoolStartButton.isHidden = true

        driverCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(startView.myPageButton.snp.bottom).offset(88)
            make.bottom.lessThanOrEqualToSuperview().inset(216)
        }
        startView.notifyComment.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(driverCardView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        startView.individualButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(startView.notifyComment.snp.bottom).offset(20)
            make.width.lessThanOrEqualTo(170)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
        startView.togetherButton.snp.makeConstraints { make in
            make.leading.equalTo(startView.individualButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(startView.notifyComment.snp.bottom).offset(20)
            make.width.equalTo(startView.individualButton.snp.width)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
        startView.carpoolStartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(startView.notifyComment.snp.bottom).offset(20)
            make.width.lessThanOrEqualTo(350)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
    }

    func showShuttleFinishedModal() {
        present(SessionFinishViewController(), animated: true)
    }
}

// MARK: - 크루가 있을 때 - 크루원일 때
extension SessionStartViewController {

    private func settingPassengerView(crewData: Crew) {
        let crewName = crewData.name ?? ""

        startView.topComment.text = "\(String(describing: crewName))과\n함께 가시나요?"
        // 특정 부분 색상 넣기
        let topCommentText = NSMutableAttributedString(string: startView.topComment.text ?? "")
        if let range1 = startView.topComment.text?.range(of: "\(String(describing: crewName))") {
            let nsRange1 = NSRange(range1, in: startView.topComment.text ?? "")
            topCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange1)
        }
        startView.topComment.attributedText = topCommentText

        startView.notifyComment.text = ""

        startView.individualButton.setTitle("따로가요", for: .normal)
        startView.togetherButton.setTitle("함께가요", for: .normal)

        // view layout
        driverCardView.isHidden = true
        memberCardView.isHidden = false

        // button layout
        startView.individualButton.isHidden = false
        startView.togetherButton.isHidden = false
        startView.carpoolStartButton.isHidden = true

        memberCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(startView.myPageButton.snp.bottom).offset(88)
            make.bottom.lessThanOrEqualToSuperview().inset(216)
        }
        startView.notifyComment.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(memberCardView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        startView.individualButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(startView.notifyComment.snp.bottom).offset(20)
            make.width.lessThanOrEqualTo(170)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
        startView.togetherButton.snp.makeConstraints { make in
            make.leading.equalTo(startView.individualButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(startView.notifyComment.snp.bottom).offset(20)
            make.width.equalTo(startView.individualButton.snp.width)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(60)
        }
        startView.carpoolStartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(startView.notifyComment.snp.bottom).offset(20)
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
        myPageVC.crewData = crewData
        navigationController?.pushViewController(myPageVC, animated: true)
    }

    @objc private func togetherButtonDidTapped() {
        if isCaptain {
            firebaseManager.driverTogetherButtonTapped(crewData: crewData)

            startView.individualButton.isHidden = true
            startView.togetherButton.isHidden = true
            startView.carpoolStartButton.isHidden = false

            // 활성화
            driverCardView.layer.opacity = 1.0

            startView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"

        } else {
            firebaseManager.passengerTogetherButtonTapped(crewData: crewData)
        }
    }

    @objc private func carpoolStartButtonDidTapped() {
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
        startView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"
        driverCardView.driverFrontView.noDriveViewForDriver.isHidden = false
        driverCardView.driverFrontView.crewCollectionView.isHidden = true   // 컬렉션뷰 가리고 오늘 가지 않는다는 뷰 보여주기
        startView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
        startView.individualButton.isEnabled = false
        startView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
        startView.togetherButton.isEnabled = false
        driverCardView.layer.opacity = 1.0
    }
}

// MARK: - Action
extension SessionStartViewController {

    // 함께하는 크루원이 한 명 이상일 때 버튼 Enable
    private func checkingCrewStatus(crewData: Crew) {
        guard let memberStatus = crewData.memberStatus else { return }

        // .accept 상태를 가진 크루원이 있는지 확인
        let isAnyMemberAccepted = memberStatus.contains { member in
            return member.status == .accept
        }

        if isAnyMemberAccepted {
            startView.carpoolStartButton.isEnabled = true
            startView.notifyComment.text = "현재 탑승 응답한 크루원들과\n여정을 시작할까요?"
            startView.carpoolStartButton.backgroundColor = UIColor.semantic.accPrimary
        } else {
            startView.carpoolStartButton.isEnabled = false
            startView.carpoolStartButton.backgroundColor = UIColor.semantic.backgroundThird
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
