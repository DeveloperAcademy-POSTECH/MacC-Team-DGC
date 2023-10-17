//
//  SessionStartViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

import SnapKit

final class SessionStartViewController: UIViewController {

    private let sessionStartView = SessionStartView()
    private let sessionStartMidView = SessionStartMidView()

    // 기기 크기에 따른 collectionView 높이 설정
    private var collectionViewHeight: CGFloat = 0
    private var collectionViewWidth: CGFloat = 0

    private var buttonHeight: CGFloat = 60

    var selectedGroupData: Group?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupByFrameSize()
        setupConstraints()

        sessionStartView.groupCollectionView.delegate = self
        sessionStartView.groupCollectionView.dataSource = self

        sessionStartView.journeyTogetherButton.addTarget(
            self,
            action: #selector(presentModalQueue),
            for: .touchUpInside
        )

        // 첫 번째 인덱스의 데이터를 선택한 것처럼 처리
        if let firstGroup = groupData?.first {
            handleSelectedGroupData(firstGroup)
        }
    }
}

// MARK: Layout
extension SessionStartViewController {

    func setupUI() {

        view.backgroundColor = .systemBackground

        view.addSubview(sessionStartView)
        view.addSubview(sessionStartMidView)
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
            make.top.equalTo(sessionStartView.groupCollectionView.snp.bottom).inset(-16).priority(.high)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(467).priority(.low)
        }

        let tabBarControllerHeight = self.tabBarController?.tabBar.frame.height ?? 0

        sessionStartView.journeyTogetherButton.snp.makeConstraints { make in
            make.top.equalTo(sessionStartMidView.snp.bottom).inset(-16)
            make.leading.trailing.equalTo(sessionStartView).inset(20)
            make.height.equalTo(buttonHeight)
            make.bottom.greaterThanOrEqualToSuperview().inset(tabBarControllerHeight + 20)
        }

        sessionStartView.journeyTogetherButton.layer.cornerRadius = buttonHeight / 2

    }

}

// MARK: Actions
extension SessionStartViewController {

    @objc private func presentModalQueue() {
        let modalQueueViewController = ModalQueueViewController()
        self.present(modalQueueViewController, animated: true)
    }

    private func handleSelectedGroupData(_ selectedGroup: Group) {
        // 선택한 그룹 데이터를 처리하는 코드를 추가합니다.
        // 예를 들어, 선택한 그룹 데이터를 출력하거나 다른 동작을 수행할 수 있습니다.

        // 그룹 데이터를 선택한 데이터로 설정
        self.selectedGroupData = selectedGroup

        // 화면 업데이트
        sessionStartMidView.setupGroupData(selectedGroup)
        
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
                groupId: nil,
                groupName: nil,
                groupImage: nil,
                captainId: nil,
                crewList: nil,
                sessionDay: nil,
                points: nil,
                accumulateDistance: nil
            )
        }

        print("Group Data -> ", cell?.groupData as Any)
        return cell ?? UICollectionViewCell()
    }
}
