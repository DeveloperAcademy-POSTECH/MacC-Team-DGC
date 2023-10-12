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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(sessionStartView)
        view.addSubview(sessionStartMidView)

        if UIScreen.main.bounds.height >= 800 {
            // iPhone 14와 같이 큰 화면
            collectionViewHeight = 104
            collectionViewWidth = 80
        } else {
            // iPhone SE와 같이 작은 화면
            collectionViewHeight = 84
            collectionViewWidth = 64
        }

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
            make.height.lessThanOrEqualTo(395).priority(.low)
        }

        let tabBarControllerHeight = self.tabBarController?.tabBar.frame.height ?? 0

        sessionStartView.journeyTogetherButton.snp.makeConstraints { make in
            make.top.equalTo(sessionStartMidView.snp.bottom).inset(-16)
            make.leading.trailing.equalTo(sessionStartView).inset(20)
            make.height.equalTo(60) // radius 때문에 고정값으로 지정
            make.bottom.equalToSuperview().inset(tabBarControllerHeight + 20)
        }

        sessionStartView.groupCollectionView.delegate = self
        sessionStartView.groupCollectionView.dataSource = self

        sessionStartView.journeyTogetherButton.addTarget(
            self,
            action: #selector(presentModalQueue),
            for: .touchUpInside
        )
    }

    override func viewDidLayoutSubviews() {

        sessionStartView.summaryView.layoutIfNeeded()

        // 점선 그리기
        sessionStartView.journeySummaryView.layer.addSublayer(sessionStartView.dottedLineLayer)
        sessionStartView.dottedLineLayer.position = CGPoint(
            x: 0,
            y: sessionStartView.journeySummaryView.frame.maxY - 100
        )

        sessionStartView.startGradient.frame = sessionStartView.startView.bounds
        sessionStartView.endGradient.frame = sessionStartView.endView.bounds
    }
}

extension SessionStartViewController {

    @objc private func presentModalQueue() {
        let modalQueueViewController = ModalQueueViewController()
        self.present(modalQueueViewController, animated: true)
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
