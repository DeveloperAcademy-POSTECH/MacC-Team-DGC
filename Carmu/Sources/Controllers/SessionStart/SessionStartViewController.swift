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
    private let sessionStartDriverView = SessionStartDriverView()
    private let sessionStartPassengerView = SessionStartPassengerView()
    private let sessionStartNoGroupView = SessionStartNoGroupView()
    private let firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        setupUI()
        setupConstraints()

        sessionStartView.myPageButton.addTarget(self, action: #selector(myPageButtonDidTapped), for: .touchUpInside)
        sessionStartView.togetherButton.addTarget(self, action: #selector(togetherButtonDidTapped), for: .touchUpInside)
        sessionStartView.carpoolStartButton.addTarget(self,
                                                      action: #selector(carpoolStartButtonDidTapped),
                                                      for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        checkGroup()
    }
}

// MARK: Layout
extension SessionStartViewController {
    private func setupUI() {
        view.addSubview(sessionStartView)
        view.addSubview(sessionStartDriverView)
        view.addSubview(sessionStartPassengerView)
        view.addSubview(sessionStartNoGroupView)
    }
    private func setupConstraints() {
        sessionStartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // 그룹이 없을 때
    private func settingNoGroupView() {
        sessionStartView.topComment.text = "오늘도 카뮤와 함께\n즐거운 카풀 생활되세요!"
        let attributedText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "카뮤") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text!)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        if let range2 = sessionStartView.topComment.text?.range(of: "카풀 생활") {
            let nsRange2 = NSRange(range2, in: sessionStartView.topComment.text!)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange2)
        }
        sessionStartView.topComment.attributedText = attributedText

        sessionStartDriverView.isHidden = true
        sessionStartPassengerView.isHidden = true
        sessionStartNoGroupView.isHidden = false

        sessionStartNoGroupView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(sessionStartView.topComment.snp.bottom).offset(36)
            make.bottom.lessThanOrEqualToSuperview().inset(216).priority(.high)
            make.bottom.equalToSuperview().inset(216)
        }
    }
    // 그룹이 있을 때
    private func settingGroupView() {

        sessionStartNoGroupView.isHidden = true

        // TODO: - 데이터 형식에 맞춰서 수정
        if groupData?.captainID == "ted" {  // 운전자일 경우
            settingDriverView()
        } else {    // 크루원인 경우
            settingPassengerView()
        }
    }

    // 운전자일 때
    private func settingDriverView() {

        // 비활성화
        sessionStartDriverView.layer.opacity = 0.5
        // comment
        sessionStartView.topComment.text = "\(groupData?.name ?? "그룹명"),\n오늘 운행하시나요?"
        // 특정 부분 색상 넣기
        let topCommentText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "\(groupData?.name ?? "그룹명")") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text!)
            topCommentText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        sessionStartView.topComment.attributedText = topCommentText

        sessionStartView.notifyComment.text = "오늘의 카풀 운행 여부를\n출발시간 30분 전까지 알려주세요!"
        let notifyCommentText = NSMutableAttributedString(string: sessionStartView.notifyComment.text ?? "")
        if let range2 = sessionStartView.notifyComment.text?.range(of: "30분 전") {
            let nsRange2 = NSRange(range2, in: sessionStartView.notifyComment.text!)
            notifyCommentText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.textPrimary as Any,
                                        range: nsRange2)
        }
        sessionStartView.notifyComment.attributedText = notifyCommentText

        sessionStartView.individualButton.setTitle("운행하지 않아요", for: .normal)
        sessionStartView.togetherButton.setTitle("운행해요", for: .normal)

        // view layout
        sessionStartDriverView.isHidden = false
        sessionStartPassengerView.isHidden = true

        // button layout
        sessionStartView.individualButton.isHidden = false
        sessionStartView.togetherButton.isHidden = false
        sessionStartView.carpoolStartButton.isHidden = true

        settingDriverConstraints()
    }

    // 크루원일 때
    private func settingPassengerView() {
        sessionStartView.topComment.text = "(그룹명)과\n함께 가시나요?"
        // 특정 부분 색상 넣기
        let attributedText = NSMutableAttributedString(string: sessionStartView.topComment.text ?? "")
        if let range1 = sessionStartView.topComment.text?.range(of: "(그룹명)") {
            let nsRange1 = NSRange(range1, in: sessionStartView.topComment.text!)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        sessionStartView.topComment.attributedText = attributedText

        sessionStartDriverView.isHidden = true
        sessionStartPassengerView.isHidden = false

        sessionStartPassengerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(sessionStartView.topComment.snp.bottom).offset(36)
            make.bottom.lessThanOrEqualToSuperview().inset(216)
        }
    }

    // Driver Layout
    private func settingDriverConstraints() {
        sessionStartDriverView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(sessionStartView.topComment.snp.bottom).offset(36)
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

// MARK: Actions
extension SessionStartViewController {

    @objc private func myPageButtonDidTapped() {
        let myPageVC = MyPageViewController()
        navigationController?.pushViewController(myPageVC, animated: true)
    }

    // 그룹의 유무 확인
    private func checkGroup() {
        if groupData == nil {
            settingNoGroupView()
        } else {
            settingGroupView()
        }
    }

    @objc private func togetherButtonDidTapped() {
        sessionStartView.individualButton.isHidden = true
        sessionStartView.togetherButton.isHidden = true
        sessionStartView.carpoolStartButton.isHidden = false

        // 활성화
        sessionStartDriverView.layer.opacity = 1.0
    }

    @objc private func carpoolStartButtonDidTapped() {
        let mapView = SessionMapViewController()
        mapView.modalPresentationStyle = .fullScreen
        self.present(mapView, animated: true, completion: nil)
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
