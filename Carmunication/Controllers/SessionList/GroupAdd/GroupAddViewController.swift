//
//  GroupAddViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

final class GroupAddViewController: UIViewController {

    var groupDataModel: Group = Group()
    var pointsDataModel: [Point] = []
    var friendsList: [User]?
    var userImage: [String: UIImage]?
    let groupAddView = GroupAddView()
    private let firebaseManager = FirebaseManager()
    private var shouldPopViewController = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        groupAddView.tableViewComponent.dataSource = self
        groupAddView.tableViewComponent.delegate = self
        groupAddView.textField.delegate = self
        groupAddView.stopoverPointAddButton.addTarget(
            self,
            action: #selector(addStopoverPointTapped),
            for: .touchUpInside
        )
        groupAddView.crewCreateButton.addTarget(
            self,
            action: #selector(createCrewButtonTapped),
            for: .touchUpInside
        )
        navigationBarSetting()

        view.addSubview(groupAddView)
        groupAddView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        for index in 0...2 {
            pointsDataModel.append(Point(pointSequence: index))
            if index == 2 {
                pointsDataModel[2].boardingCrew = [String]()
            }
        }

        fetchFriendsList()
    }
}

// MARK: - @objc Method
extension GroupAddViewController {

    @objc private func addStopoverPointTapped() {
        let insertIndex = pointsDataModel.count - 1
        self.pointsDataModel.insert(
            Point(pointSequence: insertIndex),
            at: insertIndex
        )
        if pointsDataModel.count >= 5 {
            groupAddView.stopoverPointAddButton.isEnabled = false
            groupAddView.stopoverPointAddButton.isHidden = true
        }
        groupAddView.tableViewComponent.reloadData()
    }

    @objc func stopoverRemoveButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? GroupAddTableViewCell,
              let indexPath = self.groupAddView.tableViewComponent.indexPath(for: cell) else {
            return
        }

        pointsDataModel.remove(at: indexPath.row)
        if pointsDataModel.count <= 5 {
            groupAddView.stopoverPointAddButton.isEnabled = true
            groupAddView.stopoverPointAddButton.isHidden = false
        }
        groupAddView.tableViewComponent.reloadData()
    }

    @objc func addBoardingCrewButtonTapped(_ sender: UIButton) {
        let detailViewController = SelectBoardingCrewModalViewController()
        detailViewController.friendsList = friendsList
        detailViewController.userImage = userImage

        detailViewController.friendSelectionHandler = { [weak self] selectedFriend in

            if let cell = sender.superview?.superview as? GroupAddTableViewCell,
               let indexPath = self?.groupAddView.tableViewComponent.indexPath(for: cell) {
                var newBoardingCrew = [String]()
                if selectedFriend.isEmpty {
                    self?.pointsDataModel[indexPath.row].boardingCrew = nil
                } else {
                    for element in selectedFriend {
                        newBoardingCrew.append(element.nickname)
                    }
                    self?.pointsDataModel[indexPath.row].boardingCrew = newBoardingCrew
                }
            }
            self?.groupAddView.tableViewComponent.reloadData()
        }

        present(detailViewController, animated: true)
    }

    @objc func setStartTimeButtonTapped(_ sender: UIButton) {
        let detailViewController = SelectStartTimeViewController()

        // 클로저를 통해 선택한 시간을 받음
        detailViewController.timeSelectionHandler = { [weak self] selectedTime in
            // 선택한 시간을 사용하여 원하는 작업 수행
            if let cell = sender.superview?.superview as? GroupAddTableViewCell,
               let indexPath = self?.groupAddView.tableViewComponent.indexPath(for: cell) {
                self?.pointsDataModel[indexPath.row].pointArrivalTime = selectedTime
                // 이제 선택한 시간이 `Point` 모델에 저장됩니다.
            }
            self?.groupAddView.tableViewComponent.reloadData()
        }
        present(detailViewController, animated: true)
    }

    @objc func findAddressButtonTapped(_ sender: UIButton) {
        let detailViewController = SelectAddressViewController()
        let navigation = UINavigationController(rootViewController: detailViewController)
        guard let cell = sender.superview?.superview as? GroupAddTableViewCell,
              let indexPath = groupAddView.tableViewComponent.indexPath(for: cell) else {
            return
        }
        let row = indexPath.row

        detailViewController.selectAddressView.headerTitleLabel.text = {
            switch row {
            case 0:
                return "출발지 주소 설정"
            case (self.groupAddView.tableViewComponent.numberOfRows(inSection: 0) ?? 2) - 1:
                return "도착지 주소 설정"
            default:
                return "경유지\(row) 주소 설정"
            }
        }()

        detailViewController.addressSelectionHandler = { [weak self] addressDTO in
            self?.pointsDataModel[row].pointName = addressDTO.pointName
            self?.pointsDataModel[row].pointDetailAddress = addressDTO.pointDetailAddress
            self?.pointsDataModel[row].pointLat = addressDTO.pointLat
            self?.pointsDataModel[row].pointLng = addressDTO.pointLng
            self?.groupAddView.tableViewComponent.reloadData()
        }

        present(navigation, animated: true)
    }

    @objc private func createCrewButtonTapped(_ sender: UIButton) {
        checkDataEffectiveness()
        if shouldPopViewController {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let okButton = UIAlertAction(
            title: "확인",
            style: .default
        )

        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

// MARK: - Custom Method
extension GroupAddViewController {

    private func fetchFriendsList() {
        guard let databasePath = User.databasePathWithUID else {
            return
        }

        firebaseManager.readUserFriendshipList(databasePath: databasePath) { friendshipList in
            guard let friendshipList else {
                return
            }

            for friendshipID in friendshipList {
                self.firebaseManager.getFriendUid(friendshipID: friendshipID) { friendID in
                    guard let friendID else {
                        return
                    }
                    // 친구의 uid값으로 친구의 User객체를 불러온다.
                    self.firebaseManager.getFriendUser(friendID: friendID) { friend in
                        guard let friend else {
                            return
                        }
                        if self.friendsList == nil {
                            self.friendsList = [User]()
                        }
                        self.friendsList?.append(friend)

                        // 친구 목록을 가져온 후 친구 이미지를 가져오도록 호출
                        self.fetchFriendsImage()
                    }
                }
            }
        }
    }

    private func fetchFriendsImage() {
        guard let friendsList = self.friendsList else { return }
        if userImage == nil { userImage = [String: UIImage]() }

        for element in friendsList {
            if let imageURL = element.imageURL {
                firebaseManager.loadProfileImage(urlString: imageURL) { returnImage in
                    if let inputImage = returnImage {
                        self.userImage?[element.nickname] = inputImage
                    }
                }
            } else {
                self.userImage?[element.nickname] = UIImage(named: "profile")
            }
        }
    }

    private func checkDataEffectiveness() {
        if emptyDataCheck() {
            timeEffectivenessCheck()
        }
        shouldPopViewController = true
    }

    // 빈 값을 체크해주는 메서드
    private func emptyDataCheck() -> Bool {
        // TODO: 빈 값 체크
        for element in pointsDataModel {
            let pointName = returnPointName(element.pointSequence ?? 0)

            if element.pointArrivalTime == nil {
                showAlert(title: "시간을 설정하지 않았어요!", message: "\(pointName)의 시간을 입력해주세요!")
                shouldPopViewController = false
                return false
            }

            if element.pointName == nil {
                showAlert(title: "주소를 설정하지 않았어요!", message: "\(pointName)의 주소를 설정해주세요!")
                shouldPopViewController = false
                return false
            }
            guard let boardingCrew = element.boardingCrew else {
                showAlert(
                    title: "탑승 크루를 선택하지 않았어요!",
                    message:
                    """
                    \(pointName)의 탑승자를 선택하지 않았어요.
                    없다면 포인트를 삭제해주세요!
                    """
                )
                shouldPopViewController = false
                return false
            }
        }
        return true
    }

    // 시간 유효성을 체크해주는 메서드
    private func timeEffectivenessCheck() {
        for (index, element) in pointsDataModel.enumerated() {
            if index == 0 { continue }

            let pointName = returnPointName(index)
            let beforeTime = pointsDataModel[index - 1].pointArrivalTime?.timeIntervalSince1970 ?? 0
            let currentTime = element.pointArrivalTime?.timeIntervalSince1970 ?? 0

            if beforeTime >= currentTime {
                showAlert(
                    title: "시간을 다시 설정해주세요!",
                    message:
                        """
                        \(pointName)의 도착시간이
                        이전 경유지의 도착시간보다
                        빠르게 설정되어 있습니다.
                        다시 설정해주세요!
                        """
                )
                shouldPopViewController = false
                return
            }
        }
    }

    private func returnPointName(_ index: Int) -> String {
        let pointName = {
            if index == 0 {
                return "출발지"
            } else if index == self.pointsDataModel.count - 1 {
                return "도착지"
            } else {
                return "경유지\(index)"
            }
        }()

        return pointName
    }
}

// MARK: - Component
extension GroupAddViewController {

    private func navigationBarSetting() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationController?.navigationBar.tintColor = UIColor.semantic.accPrimary
        navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: - Previewer
import SwiftUI

struct GroupAddViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = GroupAddViewController

    func makeUIViewController(context: Context) -> GroupAddViewController {
        return GroupAddViewController()
    }

    func updateUIViewController(_ uiViewController: GroupAddViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct GroupAddViewControllerPreview: PreviewProvider {

    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }
}
