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
        // 언더라벨(구 노티코멘트) 설정
        backgroundView.setUnderLabel(crewData: crewData)
        // 버튼 설정
        backgroundView.setBottomButton(crewData: crewData)

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
        if firebaseManager.isDriver(crewData: crewData) {
            showDriverCardView(crewData: crewData)
        } else {
            showMemberCardView(crewData: crewData)
        }
    }

    private func showDriverCardView(crewData: Crew) {
        noCrewCardView.isHidden = true
        driverCardView.isHidden = false
        memberCardView.isHidden = true

        switch crewData.sessionStatus {
        case .waiting:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
            driverCardView.layer.opacity = 0.5
        case .accept:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
            driverCardView.layer.opacity = 1.0
        case .decline:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = false
            driverCardView.layer.opacity = 1.0
        case .sessionStart:
            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
            driverCardView.layer.opacity = 1.0
        case .none: break
        }

        driverCardView.driverFrontView.crewData = crewData
        driverCardView.driverFrontView.settingDriverFrontData(crewData: crewData)
        driverCardView.driverFrontView.crewCollectionView.reloadData()

        driverCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(backgroundView.myPageButton.snp.bottom).offset(88)
            make.bottom.lessThanOrEqualToSuperview().inset(216)
        }
    }

    private func showMemberCardView(crewData: Crew) {
        noCrewCardView.isHidden = true
        driverCardView.isHidden = true
        memberCardView.isHidden = false

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
            driverCardView.layer.opacity = 1.0
        case .sessionStart:
            memberCardView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
            memberCardView.passengerFrontView.statusLabel.text = "오늘은 카풀이 운행될 예정이에요"
            driverCardView.layer.opacity = 1.0
        case .none: break
        }

        memberCardView.passengerFrontView.settingPassengerFrontData(crewData: crewData)

        if crewData.sessionStatus == .accept {  // 운전자가 운행할 때
            memberCardView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
            memberCardView.passengerFrontView.statusLabel.text = "오늘은 카풀이 운행될 예정이에요"

            if firebaseManager.passengerStatus(crewData: crewData) == .decline {
                memberCardView.passengerFrontView.noDriveComment.text = "오늘은 카풀에 참여하지 않으시군요!\n내일 봐요!"
                memberCardView.passengerFrontView.noDriveComment.textColor = UIColor.semantic.textPrimary
                memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = false
            }
        }

        memberCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.lessThanOrEqualTo(backgroundView.myPageButton.snp.bottom).offset(88)
            make.bottom.lessThanOrEqualToSuperview().inset(216)
        }
    }

    private func showNoCrewCardView() {
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

// MARK: @objc Method
extension SessionStartViewController {

    @objc private func myPageButtonDidTapped() {
        let myPageVC = MyPageViewController()
        myPageVC.crewData = crewData
        navigationController?.pushViewController(myPageVC, animated: true)
    }

    @objc private func individualButtonDidTapped() {
        guard let crewData = crewData else { return }
        if firebaseManager.isDriver(crewData: crewData) {
            firebaseManager.driverIndividualButtonTapped(crewData: crewData)

            driverCardView.driverFrontView.noDriveViewForDriver.isHidden = false
            driverCardView.driverFrontView.crewCollectionView.isHidden = true   // 컬렉션뷰 가리고 오늘 가지 않는다는 뷰 보여주기
            driverCardView.layer.opacity = 1.0
        } else {
            firebaseManager.passengerIndividualButtonTapped(crewData: crewData)
        }
    }

    @objc private func togetherButtonDidTapped() {
        if firebaseManager.isDriver(crewData: crewData) {
            firebaseManager.driverTogetherButtonTapped(crewData: crewData)
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

    @objc private func createCrewButtonTapped() {
        navigationController?.pushViewController(CrewNameSettingViewController(), animated: true)
    }

    @objc private func inviteCodeButtonTapped() {
        navigationController?.pushViewController(InviteCodeInputViewController(), animated: true)
    }
}

// MARK: - Action
extension SessionStartViewController {

    func showShuttleFinishedModal() {
        present(SessionFinishViewController(), animated: true)
    }

    // 가이드 화면 보여주는 메서드
    private func showGuide() {
        let ruleDescriptionViewController = RuleDescriptionViewController()
        ruleDescriptionViewController.modalPresentationStyle = .overCurrentContext
        present(ruleDescriptionViewController, animated: true)
    }

    // 이전 세션이 종료되었는지 확인하는 메서드
    private func isFinishedLastSession() -> Bool {
        guard firebaseManager.isDriver(crewData: crewData),
              let crew = crewData, crew.sessionStatus == .sessionStart,
              let startTime = crew.startingPoint?.arrivalTime?.toString24HourClock.toMinutes,
              let arrivalTime = crew.destination?.arrivalTime?.toString24HourClock.toMinutes else {
            return false
        }
        let now = Date().toString24HourClock.toMinutes
        return now < startTime && now > arrivalTime + crew.lateTime + 10
    }

    // 디바이스 토큰값이 업데이트가 될 수도 있기 때문에 업데이트된 값을 저장하기 위한 메서드
    private func settingDeviceToken() {
        print("settingDeviceToken()")
        guard let databasePath = User.databasePathWithUID else { return }
        guard let fcmToken = KeychainItem.currentUserDeviceToken else { return }
        print("FCMToken -> ", fcmToken)
        databasePath.child("deviceToken").setValue(fcmToken as NSString)
    }
}
