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
//    private let memberCardView = SessionStartPassengerView()

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

        backgroundView.myPageButton.addTarget(self, action: #selector(myPageButtonDidTapped), for: .touchUpInside)
        backgroundView.individualButton.addTarget(self, action: #selector(individualButtonDidTapped), for: .touchUpInside)
        backgroundView.togetherButton.addTarget(self, action: #selector(togetherButtonDidTapped), for: .touchUpInside)
        backgroundView.shuttleStartButton.addTarget(self, action: #selector(shuttleStartButtonDidTap), for: .touchUpInside)
        backgroundView.noCrewCardView.noCrewFrontView.createCrewButton.addTarget(self, action: #selector(createCrewButtonTapped), for: .touchUpInside)
        backgroundView.noCrewCardView.noCrewFrontView.inviteCodeButton.addTarget(self, action: #selector(inviteCodeButtonTapped), for: .touchUpInside)
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
        // Card View 설정
        setCardView(crewData: crewData)
        // 타이틀 설정
        backgroundView.setTitleLabel(crewData: crewData)
        // 언더라벨(구 노티코멘트) 설정
        backgroundView.setUnderLabel(crewData: crewData)
        // 버튼 설정
        backgroundView.setBottomButton(crewData: crewData)
    }
}

// MARK: - Card View 관련 처리 메서드
extension SessionStartViewController {

    private func setCardView(crewData: Crew?) {
        guard let crewData = crewData else {
            setCardNoCrew()
            return
        }
        if firebaseManager.isDriver(crewData: crewData) {
            setCardForDriver(crewData: crewData)
        } else {
            setCardForMember(crewData: crewData)
        }
    }

    private func setCardNoCrew() {
        backgroundView.cardView.subviews.forEach { $0.removeFromSuperview() }
        backgroundView.cardView.addSubview(backgroundView.noCrewCardView)
        backgroundView.noCrewCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setCardForDriver(crewData: Crew) {
        backgroundView.driverCardView.driverFrontView.crewData = crewData
        backgroundView.driverCardView.driverFrontView.settingDriverFrontData(crewData: crewData)
        backgroundView.driverCardView.driverFrontView.crewCollectionView.reloadData()

        backgroundView.cardView.subviews.forEach { $0.removeFromSuperview() }
        backgroundView.cardView.addSubview(backgroundView.driverCardView)
        backgroundView.driverCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 운행하지 않아요 카드를 보여주거나 숨기는 부분
        switch crewData.sessionStatus {
        case .waiting:
            backgroundView.driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
            backgroundView.driverCardView.layer.opacity = 0.5
        case .accept:
            backgroundView.driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
            backgroundView.driverCardView.layer.opacity = 1.0
        case .decline:
            backgroundView.driverCardView.driverFrontView.noDriveViewForDriver.isHidden = false
            backgroundView.driverCardView.layer.opacity = 1.0
        case .sessionStart:
            backgroundView.driverCardView.driverFrontView.noDriveViewForDriver.isHidden = true
            backgroundView.driverCardView.layer.opacity = 1.0
        case .none: break
        }
    }

    private func setCardForMember(crewData: Crew) {
        backgroundView.memberCardView.passengerFrontView.settingPassengerFrontData(crewData: crewData)

        backgroundView.cardView.subviews.forEach { $0.removeFromSuperview() }
        backgroundView.cardView.addSubview(backgroundView.memberCardView)
        backgroundView.memberCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 운행하지 않아요 카드를 보여주거나 숨기는 부분
        switch crewData.sessionStatus {
        case .waiting:
            backgroundView.memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = true
            backgroundView.memberCardView.passengerFrontView.statusImageView.image = UIImage(named: "HourglassBlinker")
            backgroundView.memberCardView.passengerFrontView.statusLabel.text = "셔틀 운행여부를 확인하고 있어요"
        case .accept:
            // 당일 운행이 없다는 뷰 숨기기
            backgroundView.memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = true
            backgroundView.memberCardView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
            backgroundView.memberCardView.passengerFrontView.statusLabel.text = "오늘은 셔틀이 운행될 예정이에요"

            if firebaseManager.passengerStatus(crewData: crewData) == .decline {
                backgroundView.memberCardView.passengerFrontView.noDriveComment.text = "오늘은 셔틀을 탑승하지 않으시는군요!\n내일 봐요!"
                backgroundView.memberCardView.passengerFrontView.noDriveComment.textColor = UIColor.semantic.textPrimary
                backgroundView.memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = false
            }
        case .decline:
            backgroundView.memberCardView.passengerFrontView.noDriveViewForPassenger.isHidden = false
            backgroundView.memberCardView.passengerFrontView.noDriveComment.text = "오늘은 셔틀이 운행되지 않아요"
            backgroundView.memberCardView.passengerFrontView.noDriveComment.textColor = UIColor.semantic.negative
            backgroundView.driverCardView.layer.opacity = 1.0
        case .sessionStart:
            backgroundView.memberCardView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
            backgroundView.memberCardView.passengerFrontView.statusLabel.text = "오늘은 셔틀이 운행될 예정이에요"
            backgroundView.driverCardView.layer.opacity = 1.0
        case .none: break
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

            backgroundView.driverCardView.driverFrontView.noDriveViewForDriver.isHidden = false
            backgroundView.driverCardView.driverFrontView.crewCollectionView.isHidden = true   // 컬렉션뷰 가리고 오늘 가지 않는다는 뷰 보여주기
            backgroundView.driverCardView.layer.opacity = 1.0
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
