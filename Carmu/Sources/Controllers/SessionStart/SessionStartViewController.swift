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
    private let sessionStartMidView = SessionStartMidView()
    private let sessionStartMidNoGroupView = SessionStartMidNoGroupView()
    private let firebaseManager = FirebaseManager()
    var selectedGroupData: Group?

    var groupData: [Group]?

    // 기기 크기에 따른 collectionView 높이 설정
    private var collectionViewHeight: CGFloat = 0
    private var collectionViewWidth: CGFloat = 0
    private var buttonHeight: CGFloat = 60

    private var isInviteJourneyClicked = false
    private var friendDeviceToken: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - groupList 불러오기 확인
        setupUI()
        setupByFrameSize()
        setupConstraints()

        sessionStartView.groupCollectionView.delegate = self
        sessionStartView.groupCollectionView.dataSource = self

        sessionStartView.journeyTogetherButton.addTarget(
            self,
            action: #selector(inviteJourney),
            for: .touchUpInside
        )
        fetchGroupList()
    }
}

// MARK: Layout
extension SessionStartViewController {

    func fetchGroupList() {
        guard let databasePath = User.databasePathWithUID else {
            return
        }

        // 유저의 그룹 목록을 불러온다.
        firebaseManager.readGroupID(databasePath: databasePath) { groupIDList in
            guard let groupIDList = groupIDList else {
                return
            }
            print("Group List ", groupIDList)

            for groupID in groupIDList {
                self.firebaseManager.getUserGroup(groupID: groupID) { group in
                    guard let group else {
                        return
                    }
                    if self.groupData == nil {
                        self.groupData = [Group]()
                    }
                    self.groupData?.append(group)
                    self.sessionStartView.groupCollectionView.reloadData()
                    self.checkGroup()
                    self.setupBottomButton(self.selectedGroupData)
                }
            }
        }
        // 운전자인지 동승자인지 확인
        setupBottomButton(selectedGroupData)
    }

    func setupUI() {

        view.backgroundColor = .systemBackground

        view.addSubview(sessionStartView)
        view.addSubview(sessionStartMidView)
        view.addSubview(sessionStartMidNoGroupView)
    }

    func setupByFrameSize() {

        if UIScreen.main.bounds.height >= 800 {
            // iPhone 14와 같이 큰 화면
            collectionViewHeight = 104
            collectionViewWidth = 80
            buttonHeight = 60
        } else {
            // iPhone SE와 같이 작은 화면
            collectionViewHeight = 84
            collectionViewWidth = 64
            buttonHeight = 48
        }
    }

    func setupConstraints() {

        sessionStartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        sessionStartView.groupCollectionView.snp.makeConstraints { make in
            make.height.equalTo(collectionViewHeight).priority(.high)
        }

        // 여기서 두 view 간 레이아웃 잡기
        sessionStartMidView.snp.makeConstraints { make in
            make.top.equalTo(sessionStartView.groupCollectionView.snp.bottom).offset(16).priority(.high)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(467).priority(.low)
        }
        sessionStartMidNoGroupView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }

}

// MARK: Actions
extension SessionStartViewController {

    @objc private func inviteJourney() {
        if isInviteJourneyClicked {
            showAlertDialog()
        } else {
            // TODO: - 수락한 운전자 수 보여주는 로직 구현
            // TODO: - 세션 초대 로직 구현
            sessionStartView.journeyTogetherButton.backgroundColor = UIColor.semantic.negative
            sessionStartView.journeyTogetherButton.setTitle("바로 시작하기", for: .normal)
            isInviteJourneyClicked = true
            // MARK: - 친구 목록에 있는 사람들에게 서버 푸시 알림 보내기
//            sendPush()
        }
    }

    private func showAlertDialog() {
        let alertController = UIAlertController(
            title: selectedGroupData?.groupName,
            message: "크루원들을 기다리지 않고\n여정을 바로 시작하시겠어요?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel, handler: nil)
        let startAction = UIAlertAction(title: "시작하기", style: .default, handler: { _ in
            let sessionMapViewController = SessionMapViewController()
            sessionMapViewController.modalPresentationStyle = .fullScreen
            self.present(sessionMapViewController, animated: true, completion: nil)
        })
        cancelAction.setValue(UIColor.semantic.accPrimary, forKey: "titleTextColor")
        startAction.setValue(UIColor.semantic.accPrimary, forKey: "titleTextColor")

        alertController.addAction(cancelAction)
        alertController.addAction(startAction)

        present(alertController, animated: true, completion: nil)
    }

    private func handleSelectedGroupData(_ selectedGroup: Group) {
        // 선택한 그룹 데이터를 처리하는 코드를 추가합니다.
        // 예를 들어, 선택한 그룹 데이터를 출력하거나 다른 동작을 수행할 수 있습니다.

        // 그룹 데이터를 선택한 데이터로 설정
        self.selectedGroupData = selectedGroup

        // 화면 업데이트
        sessionStartMidView.setupGroupData(selectedGroup)

    }

    // 운전자인지 동승자인지의 여부에 따른 버튼 변경
    private func setupBottomButton(_ selectedGroup: Group?) {

        self.selectedGroupData = selectedGroup

        let tabBarControllerHeight = self.tabBarController?.tabBar.frame.height ?? 0

        if let selectedGroup = selectedGroup {

            sessionStartMidView.isHidden = false
            sessionStartMidNoGroupView.isHidden = true

            if let currentUserID = KeychainItem.currentUserIdentifier, selectedGroup.captainID == currentUserID {
                sessionStartView.journeyTogetherButton.isHidden = false
                sessionStartView.noRideButton.isHidden = true
                sessionStartView.participateButton.isHidden = true

                sessionStartView.journeyTogetherButton.snp.makeConstraints { make in
                    make.top.equalTo(sessionStartMidView.snp.bottom).offset(16)
                    make.leading.trailing.equalTo(sessionStartView).inset(20)
                    make.height.equalTo(buttonHeight)
                    make.bottom.greaterThanOrEqualToSuperview().inset(tabBarControllerHeight + 20)
                }
                sessionStartView.journeyTogetherButton.layer.cornerRadius = buttonHeight / 2
            } else {
                // 동승자인 경우의 처리
                sessionStartView.journeyTogetherButton.isHidden = true
                sessionStartView.noRideButton.isHidden = false
                sessionStartView.participateButton.isHidden = false

                sessionStartView.noRideButton.snp.makeConstraints { make in
                    make.leading.equalTo(sessionStartView).inset(20)
                    make.top.equalTo(sessionStartMidView.snp.bottom).offset(16)
                    make.bottom.greaterThanOrEqualToSuperview().inset(tabBarControllerHeight + 20)
                    make.width.equalTo(sessionStartView.participateButton) // 너비를 같게 설정
                    make.height.equalTo(buttonHeight)
                }
                sessionStartView.participateButton.snp.makeConstraints { make in
                    make.leading.equalTo(sessionStartView.noRideButton.snp.trailing).offset(10) // leading 간격을 10으로 설정
                    make.trailing.equalTo(sessionStartView).inset(20)
                    make.top.equalTo(sessionStartView.noRideButton)
                    make.bottom.greaterThanOrEqualToSuperview().inset(tabBarControllerHeight + 20)
                    make.width.equalTo(sessionStartView.noRideButton) // 너비를 같게 설정
                    make.height.equalTo(sessionStartView.noRideButton)
                }
                sessionStartView.noRideButton.layer.cornerRadius = buttonHeight / 2
                sessionStartView.participateButton.layer.cornerRadius = buttonHeight / 2
            }
        } else {    // 그룹이 없다면
            sessionStartMidView.isHidden = true
            sessionStartMidNoGroupView.isHidden = false
            sessionStartView.journeyTogetherButton.isHidden = false

            sessionStartView.journeyTogetherButton.snp.makeConstraints { make in
                make.top.equalTo(sessionStartMidView.snp.bottom).offset(16)
                make.leading.trailing.equalTo(sessionStartView).inset(20)
                make.height.equalTo(buttonHeight)
                make.bottom.greaterThanOrEqualToSuperview().inset(tabBarControllerHeight + 20)
            }
            sessionStartView.journeyTogetherButton.layer.cornerRadius = buttonHeight / 2
        }
    }

    private func checkGroup() {
        if let groupData = groupData {  // groupData가 있을 때
            sessionStartMidView.isHidden = false
            sessionStartMidNoGroupView.isHidden = true

            // 첫 번째 인덱스의 데이터를 선택한 것처럼 처리
            if let firstGroup = groupData.first {
                handleSelectedGroupData(firstGroup)
            }

        } else {    // groupData가 없을 때
            sessionStartMidView.isHidden = true
            sessionStartMidNoGroupView.isHidden = false
            sessionStartView.journeyTogetherButton.isHidden = false
        }
    }

    private func sendPush() {
        let functions = Functions.functions()
        guard let databasePath = User.databasePathWithUID else {
            return
        }

        // 유저의 친구 관계 리스트를 불러온다.
        readUserFriendshipList(databasePath: databasePath) { friendshipList in
            guard let friendshipList = friendshipList else {
                return
            }
            // 친구 관계 id값으로 친구의 uid를 받아온다.
            for friendshipID in friendshipList {
                self.getFriendUid(friendshipID: friendshipID) { friendID in
                    guard let friendID = friendID else {
                        return
                    }
                    // 친구의 uid값으로 친구의 User객체를 불러온다.
                    self.getFriendUser(friendID: friendID) { friend in
                        guard let friend = friend else {
                            return
                        }
                        self.friendDeviceToken.append(friend.deviceToken)
                        print("친구들 Device Token : ", self.friendDeviceToken)

                        // Functions 호출
                        functions
                            .httpsCallable("open_session")
                            .call(["tokens": self.friendDeviceToken]) { (result, error) in
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

// MARK: - Firebase Realtime Database DB 관련 메서드
extension SessionStartViewController {

    // MARK: - DB에서 유저의 friendID 목록을 불러오는 메서드
    private func readUserFriendshipList(databasePath: DatabaseReference, completion: @escaping ([String]?) -> Void) {
        databasePath.child("friends").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            let friends = snapshot?.value as? [String]
            completion(friends)
        }
    }
    // MARK: - friendID 값으로 DB에서 Friendship의 친구 id를 불러오는 메서드
    private func getFriendUid(friendshipID: String, completion: @escaping (String?) -> Void) {
        Database.database().reference().child("friendship/\(friendshipID)").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshotValue = snapshot?.value as? [String: Any] else {
                return
            }
            guard let currentUserID = KeychainItem.currentUserIdentifier else {
                return
            }
            // sender와 receiver 중 현재 사용자에 해당하지 않는 uid를 뽑는다.
            var friendID: String = ""
            let senderValue = snapshotValue["senderID"] as? String ?? ""
            let receiverValue = snapshotValue["receiverID"] as? String ?? ""
            if currentUserID != senderValue {
                friendID = senderValue
            } else {
                friendID = receiverValue
            }
            completion(friendID)
        }
    }
    // MARK: - 친구의 uid로 DB에서 친구 데이터를 불러오기
    private func getFriendUser(friendID: String, completion: @escaping (User?) -> Void) {
        Database.database().reference().child("users/\(friendID)").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshotValue = snapshot?.value as? [String: Any] else {
                return
            }
            let friend = User(
                id: snapshotValue["id"] as? String ?? "",
                deviceToken: snapshotValue["deviceToken"] as? String ?? "",
                nickname: snapshotValue["nickname"] as? String ?? "",
                email: snapshotValue["email"] as? String,
                imageURL: snapshotValue["imageURL"] as? String,
                friends: snapshotValue["friends"] as? [String]
            )
            completion(friend)
        }
    }
}

extension SessionStartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 5
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let groupData = groupData, indexPath.row < groupData.count else {
            // 데이터가 없거나 인덱스가 범위를 벗어난 경우 처리
            return
        }

        let selectedGroup = groupData[indexPath.row]
        print("Selected ", selectedGroup)
        setupBottomButton(selectedGroup)
        handleSelectedGroupData(selectedGroup)
    }
}

extension SessionStartViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = sessionStartView.groupCollectionView.dequeueReusableCell(
            withReuseIdentifier: "groupCell",
            for: indexPath
        ) as? GroupCollectionViewCell

        if indexPath.row < groupData?.count ?? 0 {
            // 데이터가 존재하는 경우, 해당 데이터를 표시
            cell?.groupData = groupData?[indexPath.row]
        } else {
            // 데이터가 없는 경우, 기본 값을 설정
            cell?.groupData = Group(
                groupID: nil,
                groupName: nil,
                groupImage: nil,
                captainID: nil,
                sessionDay: nil,
                crewAndPoint: nil,
                sessionList: nil,
                accumulateDistance: nil
            )
        }
        print("Group Data -> ", cell?.groupData as Any)
        return cell ?? UICollectionViewCell()
    }
}
