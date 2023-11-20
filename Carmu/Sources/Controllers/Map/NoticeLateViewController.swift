//
//  NoticeLateViewController.swift
//  Carmu
//
//  Created by 허준혁 on 10/23/23.
//

import UIKit

import FirebaseDatabase
import FirebaseFunctions
import SnapKit

final class NoticeLateViewController: UIViewController {

    private let noticeLateView = NoticeLateView()
    private let firebaseManager = FirebaseManager()
    private let functions = Functions.functions()
    private var lateMin = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("customDetent")) { _ in
            return 301
        }

        if let sheet = sheetPresentationController {
            sheet.detents = [customDetent]
        }

        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(noticeLateView)
        noticeLateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        noticeLateView.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        noticeLateView.lateThreeMinutesButton.addTarget(self, action: #selector(lateThreeMinutesButtonDidTap), for: .touchUpInside)
        noticeLateView.lateFiveMinutesButton.addTarget(self, action: #selector(lateFiveMinutesButtonDidTap), for: .touchUpInside)
    }

    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }

    @objc private func lateThreeMinutesButtonDidTap() {
        lateMin = "3"
        sendLateNotification(lateMin)
        sendToastMessage()
    }

    @objc private func lateFiveMinutesButtonDidTap() {
        lateMin = "5"
        sendLateNotification(lateMin)
        sendToastMessage()
    }

    // Toast 메세지 보내기
    private func sendToastMessage() {
        guard let pvc = presentingViewController as? MapViewController else { return }
        dismiss(animated: true) {
            pvc.showToast("지각 알림을 보냈어요", withDuration: 1.0, delay: 2.0)
        }
    }
}

// MARK: - 서버 푸시 관련 메서드
extension NoticeLateViewController {

    // TODO: - 세션의 크루원들에게 보내는 것으로 변경하기
    // 유저의 친구 관계 리스트를 불러온다.
    private func sendLateNotification(_ lateMin: String) {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        // 유저의 친구 관계 리스트를 불러온다.
        firebaseManager.readUserFriendshipList(databasePath: databasePath) { friendshipList in
            guard let friendshipList = friendshipList else {
                return
            }
            // 친구 관계 id값으로 친구의 uid를 받아온다.
            for friendshipID in friendshipList {
                self.firebaseManager.getFriendUid(friendshipID: friendshipID) { friendID in
                    guard let friendID = friendID else {
                        return
                    }
                    // 친구의 uid값으로 친구의 User객체를 불러온다.
                    self.firebaseManager.getFriendUser(friendID: friendID) { friend in
                        guard let friend = friend else {
                            return
                        }
                        // TODO: - 리팩토링 할 때 분리하기
                        self.functions
                            .httpsCallable("lateNotification")
                            .call(["token": friend.deviceToken, "lateMin": self.lateMin]) { (result, error) in
                            if let error = error {
                                print("Error calling Firebase Functions: \(error.localizedDescription)")
                            } else {
                                if let data = (result?.data as? [String: Any]) {
                                    print("Response data -> ", data)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
