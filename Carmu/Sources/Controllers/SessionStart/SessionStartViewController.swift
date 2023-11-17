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
    private lazy var sessionStartBackView = SessionStartBackView()
    private lazy var sessionStartNoCrewView = SessionStartNoCrewView()
    private lazy var firebaseManager = FirebaseManager()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    var crewData: Crew?
    var isCaptain: Bool = false
    var firebaseStart: Point?
    var firebaseDestination: Point?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        Task {
            do {
                showActivityIndicator()
                crewData = try await firebaseManager.getCrewData()
                hideActivityIndicator()
                setupUI()
                setupConstraints()
                setTargetButton()
                print("Received crew data: \(String(describing: crewData))")
                isCaptain = try await firebaseManager.checkCaptain()
                checkCrew(crewData: crewData)
                firebaseManager.startObservingCrewData { crewData in
                    self.updateUI(crewData: crewData)
                }
                if let crewData = crewData {
//                    settingData(crewData: crewData)
//                    // DriverView
//                    sessionStartDriverView.driverFrontView.settingDriverFrontData(crewData: crewData)
//                    sessionStartDriverView.driverFrontView.crewData = crewData
//                    sessionStartDriverView.driverFrontView.crewCollectionView.reloadData()
//                    // PassengerView
//                    sessionStartPassengerView.passengerFrontView.settingPassengerFrontData(crewData: crewData)
//                    // BackView
//                    sessionStartBackView.crewData = crewData
                    updateUI(crewData: crewData)
                }
            } catch {
                // 어떤 에러가 발생했을 경우
                print("Error: \(error)")
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if SceneDelegate.isCrewCreated {
            showGuide()
            SceneDelegate.isCrewCreated = false // 변경을 처리한 후 다시 초기화
        }
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

// MARK: - UI update
extension SessionStartViewController {

    // UI를 업데이트 시켜줌
    private func updateUI(crewData: Crew?) {

        guard let crewData = crewData else { return }

        settingData(crewData: crewData)
        checkingCrewStatus(crewData: crewData)

        // Driver
        if isCaptain {
            sessionStartDriverView.driverFrontView.crewData = crewData
            sessionStartDriverView.driverFrontView.settingDriverFrontData(crewData: crewData)
            sessionStartDriverView.driverFrontView.crewCollectionView.reloadData()
        } else {    // Passenger
            sessionStartPassengerView.passengerFrontView.crewData = crewData
            sessionStartPassengerView.passengerFrontView.settingPassengerFrontData(crewData: crewData)

            if crewData.sessionStatus == .accept {  // 운전자가 운행할 때
                sessionStartPassengerView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
                sessionStartPassengerView.passengerFrontView.statusLabel.text = "오늘은 카풀이 운행될 예정이에요"
            }

            switch crewData.sessionStatus {
            case .waiting:
                sessionStartView.notifyComment.text = "따로가기를 선택하셨네요!\n운전자에게 알려드릴게요"
                sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.togetherButton.backgroundColor = UIColor.semantic.accPrimary
            case .accept:
                sessionStartView.topComment.text = ""
                sessionStartPassengerView.passengerFrontView.noDriveComment.text = "오늘은 카풀에 참여하지 않으시군요!\n내일 봐요!"
                sessionStartPassengerView.passengerFrontView.noDriveComment.textColor = UIColor.semantic.textPrimary
                sessionStartView.notifyComment.text = ""
                sessionStartPassengerView.passengerFrontView.noDriveViewForPassenger.isHidden = false
                sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.individualButton.isEnabled = false
                sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.togetherButton.isEnabled = false
            case .decline:
                sessionStartView.topComment.text = ""
                sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.individualButton.isEnabled = false
                sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
                sessionStartView.togetherButton.isEnabled = false
            case .sessionStart: break
                // sessionStart일 때는 해당 버튼이 나타나지 않음
            case .none: break
            }
        }
    }
}

// MARK: - 크루가 없을 때
extension SessionStartViewController {

    // 크루가 없을 때의 뷰 세팅
    private func settingNoCrewView() {
        sessionStartView.topComment.text = "오늘도 카뮤와 함께\n즐거운 카풀 생활되세요!"
        let attributedText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "카뮤") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange1)
        }
        if let range2 = sessionStartView.topComment.text?.range(of: "카풀 생활") {
            let nsRange2 = NSRange(range2, in: sessionStartView.topComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange2)
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

    // 크루가 있을 때의 세팅
    private func settingCrewView(crewData: Crew?) {
        sessionStartNoCrewView.isHidden = true
        if isCaptain {
            print("캡틴임")
            settingDriverView(crewData: crewData)
        } else {
            print("동승자임")
            settingPassengerView(crewData: crewData)
        }
    }

    // MARK: - 바뀌는 값
    private func settingData(crewData: Crew?) {

        if isCaptain {
            settingDriverData(crewData: crewData)
        } else {
            settingPassengerData(crewData: crewData)
        }
    }

    // 운전자일 때
    // MARK: - 바뀌는 값 (선언 안해줘도 실행됨)
    private func settingDriverData(crewData: Crew?) {
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
            settingDataSessionStart(crewData: crewData)
        case .none: break
        }
    }

    // 동승자일 때
    // MARK: - 바뀌는 값 (선언 안해줘도 실행됨)
    private func settingPassengerData(crewData: Crew?) {
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
            sessionStartPassengerView.passengerFrontView.statusImageView.image = UIImage(named: "DriverBlinker")
            sessionStartPassengerView.passengerFrontView.statusLabel.text = "오늘은 카풀이 운행될 예정이에요"

            settingDataSessionStart(crewData: crewData)
        case .none: break
        }
    }

    // 공통으로 사용되는 것
    // settingData - .decline
    // MARK: - 바뀌는 값 (선언 안해줘도 실행됨)
    private func settingDataDecline() {
        sessionStartView.topComment.text = ""
        sessionStartDriverView.layer.opacity = 1.0
        sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
        sessionStartView.individualButton.isEnabled = false
        sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
        sessionStartView.togetherButton.isEnabled = false
    }

    // settingData - .sessionStart
    // MARK: - 바뀌는 값 (선언 안해줘도 실행됨)
    private func settingDataSessionStart(crewData: Crew?) {
        guard let crewData = crewData else { return }
        sessionStartView.individualButton.isHidden = true
        sessionStartView.togetherButton.isHidden = true
        sessionStartView.carpoolStartButton.isHidden = false
        sessionStartDriverView.layer.opacity = 1.0
        sessionStartView.carpoolStartButton.setTitle("카풀 지도보기", for: .normal)

        // topComment 변경
        sessionStartView.topComment.text = "\(crewData.name ?? "그룹명")이\n시작되었습니다"
        // 특정 부분 색상 넣기
        let topCommentText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "\(crewData.name ?? "그룹명")") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text ?? "")
            topCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange1)
        }
        sessionStartView.topComment.attributedText = topCommentText

        // notifyComment 변경하기
        sessionStartView.notifyComment.text = "현재 운행중인 카풀이 있습니다.\n카풀 지도보기를 눌러주세요!"
        let attributedText = NSMutableAttributedString(string: sessionStartView.notifyComment.text ?? "")
        if let range1 = sessionStartView.notifyComment.text?.range(of: "현재 운행중인 카풀") {
            let nsRange1 = NSRange(range1, in: sessionStartView.notifyComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.textTertiary as Any, range: nsRange1)
        }
        if let range2 = sessionStartView.notifyComment.text?.range(of: "카풀 지도보기") {
            let nsRange2 = NSRange(range2, in: sessionStartView.notifyComment.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.textTertiary as Any, range: nsRange2)
        }
        sessionStartView.notifyComment.attributedText = attributedText
    }
}

// MARK: - 크루가 있을 때 - 운전자일 때
extension SessionStartViewController {

    // MARK: - ViewWillAppear에서 하면 될 듯,,?
    private func settingDriverView(crewData: Crew?) {
        guard let crewData = crewData else { return }
        // 비활성화
        sessionStartDriverView.layer.opacity = 0.5
        // comment
        let crewName = crewData.name ?? ""

        sessionStartView.topComment.text = "\(String(describing: crewName)),\n오늘 운행하시나요?"
        // 특정 부분 색상 넣기
        let topCommentText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "\(String(describing: crewName))") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text ?? "")
            topCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange1)
        }
        sessionStartView.topComment.attributedText = topCommentText

        sessionStartView.notifyComment.text = "오늘의 카풀 운행 여부를\n출발시간 30분 전까지 알려주세요!"
        let notifyCommentText = NSMutableAttributedString(string: sessionStartView.notifyComment.text ?? "")
        if let range2 = sessionStartView.notifyComment.text?.range(of: "30분 전") {
            let nsRange2 = NSRange(range2, in: sessionStartView.notifyComment.text ?? "")
            notifyCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.textPrimary as Any, range: nsRange2)
        }
        sessionStartView.notifyComment.attributedText = notifyCommentText

        sessionStartView.individualButton.setTitle("운행하지 않아요", for: .normal)
        sessionStartView.togetherButton.setTitle("운행해요", for: .normal)

        settingDriverUI()
        settingDriverConstraints()
    }

    // Driver UI
    // MARK: - viewWillAppear
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
    // MARK: - viewWillAppear
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

    private func settingPassengerView(crewData: Crew?) {
        guard let crewData = crewData else { return }

        let crewName = crewData.name ?? ""

        sessionStartView.topComment.text = "\(String(describing: crewName))과\n함께 가시나요?"
        // 특정 부분 색상 넣기
        let topCommentText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "\(String(describing: crewName))") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text ?? "")
            topCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange1)
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
        myPageVC.crewData = crewData
        navigationController?.pushViewController(myPageVC, animated: true)
    }

    @objc private func togetherButtonDidTapped() {

        // 운전자일 때
        if isCaptain {

            // FirebaseManager methods
            firebaseManager.driverTogetherButtonTapped(crewData: crewData)

            sessionStartView.individualButton.isHidden = true
            sessionStartView.togetherButton.isHidden = true
            sessionStartView.carpoolStartButton.isHidden = false

            // 활성화
            sessionStartDriverView.layer.opacity = 1.0

            // notifyComment 변경
            sessionStartView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"

        } else {    // 동승자일 때
            // FirebaseManager methods
            firebaseManager.passengerTogetherButtonTapped(crewData: crewData)

            sessionStartView.notifyComment.text = "함께가기를 선택하셨네요!\n운전자에게 알려드릴게요"
            sessionStartView.individualButton.backgroundColor = UIColor.semantic.negative
            sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
        }
    }

    @objc private func carpoolStartButtonDidTapped() {
        // FirebaseManager methods
        firebaseManager.carpoolStartButtonTapped(crewData: crewData)

        let mapView = MapViewController()
        mapView.modalPresentationStyle = .fullScreen
        present(mapView, animated: true, completion: nil)
    }

    @objc private func individualButtonDidTapped() {

        // 운전자가 클릭했을 때
        if isCaptain {
            settingIndividualButtonForDriver(crewData: crewData)
            print("운전자 !")
        } else {    // 동승자가 클릭했을 때
            settingIndividualButtonForPassenger(crewData: crewData)
        }
    }
}

// MARK: - individualButton Methods
extension SessionStartViewController {

    // 운전자일 때
    private func settingIndividualButtonForDriver(crewData: Crew?) {

        // FirebaseManager methods
        firebaseManager.driverIndividualButtonTapped(crewData: crewData)

        // 모든 경우에 같은 화면임
        sessionStartView.notifyComment.text = "오늘의 카풀 운행 여부를\n전달했어요"
        sessionStartDriverView.driverFrontView.noDriveViewForDriver.isHidden = false
        sessionStartDriverView.driverFrontView.crewCollectionView.isHidden = true   // 컬렉션뷰 가리고 오늘 가지 않는다는 뷰 보여주기
        sessionStartView.individualButton.backgroundColor = UIColor.semantic.backgroundThird
        sessionStartView.individualButton.isEnabled = false
        sessionStartView.togetherButton.backgroundColor = UIColor.semantic.backgroundThird
        sessionStartView.togetherButton.isEnabled = false
        sessionStartDriverView.layer.opacity = 1.0
    }

    // 동승자일 때
    // MARK: - 바뀌는 값
    private func settingIndividualButtonForPassenger(crewData: Crew?) {
        guard let crewData = crewData else { return }

        // FirebaseManager methods
        firebaseManager.passengerIndividualButtonTapped(crewData: crewData)
    }
}

// MARK: - Action
extension SessionStartViewController {

    // 대기 화면을 보여주는 메서드
    private func showActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    // 대기 화면을 숨기는 메서드
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

    /// 크루의 유무 확인
    // MARK: - viewWillAppear ? (데이터가 있는 지 없는 지는 화면에 들어올 때(SessionStartViewController)만 확인하면 됨, 즉각적으로 바뀌진 않음)
    private func checkCrew(crewData: Crew?) {
        if let crewData = crewData {
            // 데이터가 로드되었다면, 데이터가 있는 것으로 간주
            settingCrewView(crewData: crewData)
        } else {
            // 데이터가 아직 로드되지 않았거나 로드 실패한 경우
            settingNoCrewView()
        }
    }

    /// 버튼들 addTarget
    private func setTargetButton() {
        sessionStartView.myPageButton.addTarget(self, action: #selector(myPageButtonDidTapped), for: .touchUpInside)
        sessionStartView.individualButton.addTarget(self, action: #selector(individualButtonDidTapped), for: .touchUpInside)
        sessionStartView.togetherButton.addTarget(self, action: #selector(togetherButtonDidTapped), for: .touchUpInside)
        sessionStartView.carpoolStartButton.addTarget(self, action: #selector(carpoolStartButtonDidTapped), for: .touchUpInside)
    }

    // 함께하는 크루원이 한 명 이상일 때 버튼 Enable
    // MARK: - 바뀌는 값
    private func checkingCrewStatus(crewData: Crew?) {
        guard let crewData = crewData else { return }
        guard let memberStatus = crewData.memberStatus else { return }

        // .accept 상태를 가진 크루원이 있는지 확인
        let isAnyMemberAccepted = memberStatus.contains { member in
            return member.status == .accept
        }

        if isAnyMemberAccepted {  // 수락한 크루원이 한 명이라도 있을 경우
            sessionStartView.carpoolStartButton.isEnabled = true
            sessionStartView.notifyComment.text = "현재 탑승 응답한 크루원들과\n여정을 시작할까요?"
            sessionStartView.carpoolStartButton.backgroundColor = UIColor.semantic.accPrimary
        } else {    // 수락한 크루원이 없을 때
            sessionStartView.carpoolStartButton.isEnabled = false
            sessionStartView.carpoolStartButton.backgroundColor = UIColor.semantic.backgroundThird
        }
    }

    // 가이드 화면 보여주는 메서드
    private func showGuide() {
        let ruleDescriptionViewController = RuleDescriptionViewController()
        ruleDescriptionViewController.modalPresentationStyle = .overCurrentContext
        present(ruleDescriptionViewController, animated: true)
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

extension SessionStartViewController {
    func showCarpoolFinishedModal() {
        present(SessionFinishViewController(), animated: true)
    }
}
