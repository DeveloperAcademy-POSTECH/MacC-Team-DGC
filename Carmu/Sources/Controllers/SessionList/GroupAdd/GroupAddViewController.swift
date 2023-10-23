//
//  GroupAddViewController.swift
//  Carmu
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import FirebaseDatabase
import SnapKit

final class GroupAddViewController: UIViewController {

    var pointsDataModel: [Point] = []
    var friendsList: [User]?
    var selectedList: [String]?
    private var crewAndPointDict = [String: String]() // Group 생성을 용이하게 하기 위한 변수
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
            pointsDataModel.append(Point())
            if index == 2 {
                pointsDataModel[2].boardingCrew = [String: String]()
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
        guard let cell = sender.superview?.superview as? GroupAddTableViewCell else {
            return
        }
        guard let indexPath = self.groupAddView.tableViewComponent.indexPath(for: cell) else {
            return
        }
        let detailViewController = SelectBoardingCrewModalViewController()
        detailViewController.friendsList = removeSelectedFriend(friendsList, pointsDataModel)
        detailViewController.userImage = userImage
        detailViewController.selectedFriends = findSelectedFriend(pointsDataModel[indexPath.row])

        detailViewController.friendSelectionHandler = { [weak self] selectedFriend in

            var newBoardingCrew = [String: String]()
            if selectedFriend.isEmpty {
                self?.pointsDataModel[indexPath.row].boardingCrew = nil
            } else {
                for element in selectedFriend {
                    newBoardingCrew[element.id] = element.nickname
                }
                self?.pointsDataModel[indexPath.row].boardingCrew = newBoardingCrew
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
        var pointIDList = [String]()
        if checkDataEffectiveness() {
            // 주의 : popViewController를 먼저 실행하면, 두 번 값이 업로드 됨
            for element in pointsDataModel {
                // 0: [userID: pointID], 1: pointID(String)
                let returnAddPoint = firebaseManager.addPoint(element)
                crewAndPointDict.merge(
                    returnAddPoint.0,
                    uniquingKeysWith: { (current, _) in current }
                )
                print("그룹 추가시 pointIDList에 들어가는 값: ", returnAddPoint.1)
                print("포인트 추가 후 병합되는 Dictionary: ", crewAndPointDict)
                pointIDList.append(returnAddPoint.1)
            }
            print("create 메서드 내부 pointIDList 값: ", pointIDList)
            firebaseManager.addGroup(
                crewAndPoint: crewAndPointDict,
                pointIDList: pointIDList,
                groupName: groupAddView.textField.text ?? "크루 이름"
            )
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

    private func checkDataEffectiveness() -> Bool {
        if emptyDataCheck() && timeEffectivenessCheck() {
            return true
        }
        return false
    }

    // 빈 값을 체크해주는 메서드
    private func emptyDataCheck() -> Bool {

        if !groupAddView.textField.hasText {
            showAlert(title: "크루 이름을 설정하지 않았어요!", message: "크루의 이름을 입력해주세요!")
            shouldPopViewController = false
            return false
        }

        for (index, element) in pointsDataModel.enumerated() {
            let pointName = returnPointName(index)

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
            guard element.boardingCrew != nil else {
                if index == 0 {
                    return true
                }
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
    private func timeEffectivenessCheck() -> Bool {
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
                return false
            }
        }
        return true
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

    /**
     현재 한 번이라도 선택된 유저의 경우, 크루 선택 모달의 friendList에서 제외시키는 메서드
     */
    private func removeSelectedFriend(_ friendList: [User]?, _ pointData: [Point]) -> [User] {
        guard var friendList = friendList else { return [User]() }
        let selectedList = pointData

        for element in selectedList {
            guard let pointSelectedUser = element.boardingCrew else { continue }

            friendList = friendList.filter { friendElement in
                return !pointSelectedUser.values.contains(friendElement.nickname)
            }
        }
        return friendList
    }

    /**
     현재 포인트에서 선택되어 있는 유저의 배열을 리턴하는 메서드
     */
    private func findSelectedFriend(_ pointData: Point) -> [User] {
        guard let boardingCrew = pointData.boardingCrew else { return [User]() }
        guard let friendList = self.friendsList else { return [User]() }

        let selectedFriend = friendList.filter { element in
            return boardingCrew.values.contains(element.nickname)
        }

        return selectedFriend
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

// MARK: - UITableViewDataSource Method
extension GroupAddViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointsDataModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCellForRow(at: indexPath)
        configureCellActions(for: cell, at: indexPath)
        configureCellContent(for: cell, at: indexPath)
        return cell
    }

    private func configureCellForRow(at indexPath: IndexPath) -> GroupAddTableViewCell {
        let cell = GroupAddTableViewCell(
            index: CGFloat(indexPath.row),
            cellCount: CGFloat(pointsDataModel.count)
        )
        return cell
    }

    private func configureCellActions(for cell: GroupAddTableViewCell, at indexPath: IndexPath) {
        cell.addressSearchButton.addTarget(self, action: #selector(findAddressButtonTapped), for: .touchUpInside)
        cell.crewImageButton.addTarget(self, action: #selector(addBoardingCrewButtonTapped), for: .touchUpInside)
        cell.startTime.addTarget(self, action: #selector(setStartTimeButtonTapped), for: .touchUpInside)
        cell.stopoverPointRemoveButton.addTarget(
            self,
            action: #selector(stopoverRemoveButtonTapped),
            for: .touchUpInside)
    }

    private func configureCellContent(for cell: GroupAddTableViewCell, at indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == pointsDataModel.count - 1 {
            configureStartEndCellContent(for: cell, at: indexPath)
        } else {
            configureIntermediateCellContent(for: cell, at: indexPath)
        }

        if indexPath.row == pointsDataModel.count - 1 {
            configureLastCellContent(for: cell)
        }

        if let pointName = pointsDataModel[indexPath.row].pointName {
            cell.addressSearchButton.setTitle("    \(pointName)", for: .normal)
        }
        if let startTime = pointsDataModel[indexPath.row].pointArrivalTime {
            let formattedTime = Date.formattedDate(from: startTime, dateFormat: "a hh:mm")
            cell.startTime.setTitle(formattedTime, for: .normal)
        }
        if let boardingCrew = pointsDataModel[indexPath.row].boardingCrew {
            let boardingCrewValues = Array(boardingCrew.values)
            configureBoardingCrewContent(for: cell, with: boardingCrewValues)
        }
    }

    private func configureStartEndCellContent(for cell: GroupAddTableViewCell, at indexPath: IndexPath) {
        cell.stopoverPointRemoveButton.isEnabled = false
        cell.stopoverPointRemoveButton.isHidden = true
        cell.pointNameLabel.text = indexPath.row == 0 ? "출발지" : "도착지"
        cell.timeLabel.text = indexPath.row == 0 ? "출발시간" : "도착시간"
    }

    private func configureIntermediateCellContent(for cell: GroupAddTableViewCell, at indexPath: IndexPath) {
        cell.pointNameLabel.text = "경유지 \(indexPath.row)"
    }

    private func configureLastCellContent(for cell: GroupAddTableViewCell) {
        cell.crewImageButton.isHidden = true
        cell.crewImageButton.isEnabled = false
        cell.boardingCrewLabel.isHidden = true
    }

    private func configureBoardingCrewContent(for cell: GroupAddTableViewCell, with boardingCrew: [String]) {
        let maxCrewMembers = min(boardingCrew.count, 3)

        for index in 0..<maxCrewMembers {
            switch index {
            case 0:
                cell.crewImageButton.crewImage1.image = userImage?[boardingCrew[index]]
            case 1:
                cell.crewImageButton.crewImage2.image = userImage?[boardingCrew[index]]
            case 2:
                cell.crewImageButton.crewImage3.image = userImage?[boardingCrew[index]]
            default:
                break
            }
        }

        // If there are fewer than 3 crew members, hide the remaining image views.
        for index in maxCrewMembers..<3 {
            switch index {
            case 0:
                cell.crewImageButton.crewImage1.image = UIImage(named: "CrewPlusImage")
            case 1:
                cell.crewImageButton.crewImage2.image = UIImage(named: "CrewPlusImage")
            case 2:
                cell.crewImageButton.crewImage3.image = UIImage(named: "CrewPlusImage")
            default:
                break
            }
        }
    }
}

// MARK: - UITableViewDelegate Method
extension GroupAddViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - UITextFieldDelegate Method
extension GroupAddViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return true
    }

    // 텍스트 필드에서 리턴 키를 누를 때 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // 화면의 다른 곳을 탭할 때 호출되는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
