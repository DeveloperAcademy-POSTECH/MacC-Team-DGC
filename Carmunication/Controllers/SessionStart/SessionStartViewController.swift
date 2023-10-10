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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(sessionStartView)
        sessionStartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        sessionStartView.gradient.frame = sessionStartView.groupNameView.bounds
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
        return sessionStartView.groupData?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 80, height: 102)
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
        if let groupData = self.sessionStartView.groupData?[indexPath.row] {
            cell?.groupData = groupData
        }
        return cell ?? UICollectionViewCell()
    }
}
