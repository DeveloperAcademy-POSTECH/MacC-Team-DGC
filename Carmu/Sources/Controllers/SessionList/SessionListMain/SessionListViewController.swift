//
//  SessionListViewController.swift
//  Carmu
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

import FirebaseDatabase
import SnapKit

final class SessionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let sessionListView = SessionListView()
    private let firebaseManager = FirebaseManager()
    private var groupList = [Group]()
    private var pointList = [[Point]]() // 각 그룹의 point를 담아놓는 배열
    private var userID: String?
    private var pointIDList: [[String]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        sessionListView.tableViewComponent.dataSource = self
        sessionListView.tableViewComponent.delegate = self

        sessionListView.addNewGroupButton.addTarget(self, action: #selector(moveToAddGroup), for: .touchUpInside)

        view.addSubview(sessionListView)
        sessionListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }


        fetchDataAndUpdateTableView()
        print("그룹리스트: \(groupList)")
        print("포인트리스트: \(pointList)")
    }

    override func viewWillAppear(_ animated: Bool) {
        sessionListView.tableViewComponent.reloadData()
    }
}

// MARK: - Firebase
extension SessionListViewController {

    private func fetchDataAndUpdateTableView() {
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        self.userID = databasePath.key

        // 유저의 groupList([groupID])를 불러온다.
        readUserGroupList(databasePath: databasePath) { groupList in
            guard let groupList else {
                return
            }
            print("유저의 그룹ID 리스트 \(groupList)")
            // 그룹 id 값으로 group의 Data를 받아온다.
            for groupID in groupList {
                self.getGroupData(groupID) { groupData in
                    guard let groupData else {
                        return
                    }
                    print("현재 그룹 ID: \(groupID)")
                    print("현재 그룹 데이터: \(groupData)")
                    guard let pointIDList = groupData.pointList else {
                        return
                    }
                    print("현재 그룹의 경유지ID 리스트: \(pointIDList)")

                    // 그룹의 id 내부의 pointIDList 값을 가지고 Point 객체 배열을 (한꺼번에 불러온다.xXXXx)

                    for (index, pointID) in pointIDList.enumerated() {
                        print("for문 내부 pointID", pointID)

                        self.getPointData(pointID) { pointData in
                            guard let pointData = pointData else {
                                return
                            }
                            if self.pointList.isEmpty {
                                self.pointList.append([pointData])
                                self.sessionListView.tableViewComponent.reloadData()

                            } else {
                                let lastIndex = self.pointList.count - 1
                                self.pointList[lastIndex].append(pointData)
                                self.sessionListView.tableViewComponent.reloadData()
                            }
                        }
                    }
                    self.groupList.append(groupData)
                    self.sessionListView.tableViewComponent.reloadData()
//                    self.getPointData(pointIDList) { pointDatum in
//                        guard let pointDatum else {
//                            return
//                        }
//                        // 2차원 배열에 Point 배열 추가
//                        if self.pointList == nil {
//                            self.pointList = [pointDatum]
//                        } else {
//                            self.pointList?.append(pointDatum)
//                            self.sessionListView.tableViewComponent.reloadData()
//                            print("포인트 목록: ", pointDatum)
//                        }
//                        print("현재 그룹의 경유지 리스트: \(pointIDList)")
//                    }
//                    // group 객체 추가
//                    if self.groupList == nil {
//                        self.groupList = [groupData]
//                    } else {
//                        self.groupList?.append(groupData)
//                        self.sessionListView.tableViewComponent.reloadData()
//                        print("그룹 목록: ", groupData)
//                    }
                }
//                print("그룹ID: \(groupID)")
            }
        }
    }

    // MARK: - DB에서 유저의 friendID 목록을 불러오는 메서드
    private func readUserGroupList(databasePath: DatabaseReference, completion: @escaping ([String]?) -> Void) {
        databasePath.child("groupList").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            let groups = snapshot?.value as? [String]
            completion(groups)
        }
    }

    private func getGroupData(_ groupID: String, completion: @escaping (Group?) -> Void) {
        Database.database().reference().child("group/\(groupID)").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshotValue = snapshot?.value as? [String: Any] else {
                return
            }
            let group = Group(
                groupID: snapshotValue["groupID"] as? String ?? "",
                groupName: snapshotValue["groupName"] as? String ?? "",
                groupImage: snapshotValue["groupImage"] as? String ?? "",
                captainID: snapshotValue["captainID"] as? String ?? "",
                sessionDay: snapshotValue["sessionDay"] as? [Int] ?? [Int](),
                pointList: snapshotValue["pointList"] as? [String] ?? [String](),
                stopoverCount: snapshotValue["stopoverCount"] as? Int ?? 0,
                crewAndPoint: snapshotValue["crewAndPoint"] as? [String: String] ?? [String: String](),
                sessionList: snapshotValue["sessionList"] as? [String] ?? [String](),
                accumulateDistance: snapshotValue["accumulateDistance"] as? Int ?? 0
            )
            print("그룹의 데이터: ", group)
            completion(group)
        }
    }

    private func getPointData(_ pointID: String, completion: @escaping (Point?) -> Void) {
        Database.database().reference().child("point/\(pointID)").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let snapshotValue = snapshot?.value as? [String: Any] else {
                return
            }
            let point = Point(
                pointID: snapshotValue["pointID"] as? String ?? "",
                pointSequence: snapshotValue["pointSequence"] as? Int ?? 0,
                pointName: snapshotValue["pointName"] as? String ?? "",
                pointDetailAddress: snapshotValue["pointDetailAddress"] as? String ?? "",
                pointArrivalTime: snapshotValue["pointDate"] as? Date ?? Date(),
                pointLat: snapshotValue["pointLat"] as? Double ?? 37.5,
                pointLng: snapshotValue["pointLng"] as? Double ?? 127.324,
                boardingCrew: snapshotValue["boardingCrew"] as? [String: String] ?? [String: String]()
            )
//            print("포인트 데이터 반환: ", point)
            completion(point)
        }
    }
}

// MARK: - TableView Method
extension SessionListViewController {
    // UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // 셀 개수 설정
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if groupList.count < 1 {
            return 1
        } else {
            return groupList.count
        }
//        return groupCount
//        return groupList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("groupList.isEmpty : ", groupList.count)
        print("pointList.isEmpty : ", pointList)
        print("pointList count: ", pointList.count)

        if groupList.count > 0 && pointList.count > 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as? CustomListTableViewCell else {
                return UITableViewCell()
            }

            let groupData = groupList[indexPath.section]
            let pointData = pointList[indexPath.section]

            cell.groupName.text = groupData.groupName
            cell.startPointLabel.text = pointData.first?.pointName
            cell.endPointLabel.text = pointData.last?.pointName
            cell.startTimeLabel.text = Date.formatTime(pointData.first?.pointArrivalTime)
            cell.isCaptainBadge.image = {
                if self.userID != groupData.captainID {
                    UIImage(named: "ImCrewButton")
                } else {
                    UIImage(named: "ImCaptainButton")
                }
            }()
            cell.crewCount = groupData.crewAndPoint?.count ?? 2
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "notFoundCell",
                for: indexPath
            ) as? NotFoundCrewTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 선택 시 화면 전환 로직 구현
        let selectedGroup = groupData?[indexPath.section]
        let detailViewController = GroupDetailViewController()

        detailViewController.selectedGroup = selectedGroup
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Component
extension SessionListViewController {

    @objc private func moveToAddGroup() {
        let groudAddViewController = GroupAddViewController()
        groudAddViewController.title = "크루 만들기"
        navigationController?.pushViewController(groudAddViewController, animated: true)
    }
}

// MARK: - Preview canvas 세팅
import SwiftUI

struct SessionListViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = SessionListViewController

    func makeUIViewController(context: Context) -> SessionListViewController {
        return SessionListViewController()
    }

    func updateUIViewController(_ uiViewController: SessionListViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct SecondViewPreview: PreviewProvider {

    static var previews: some View {
        SessionListViewControllerRepresentable()
    }
}
