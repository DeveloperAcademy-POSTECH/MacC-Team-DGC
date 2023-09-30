//
//  SessionStartViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

import SnapKit

final class SessionStartViewController: UIViewController {
    // 더미 데이터
    private let groupData = [
        GroupData(
            image: UIImage(systemName: "heart")!,
            groupName: "group1",
            start: "양덕",
            end: "C5",
            startTime: "08:30",
            endTime: "9:00",
            date: "주중(월 - 금)",
            total: 4),
        GroupData(
            image: UIImage(systemName: "circle")!,
            groupName: "group2",
            start: "포항",
            end: "부산",
            startTime: "08:30",
            endTime: "9:00",
            date: "주중(월 - 금)",
            total: 4),
        GroupData(
            image: UIImage(systemName: "heart.fill")!,
            groupName: "group3",
            start: "인천",
            end: "서울",
            startTime: "08:30",
            endTime: "9:00",
            date: "주중(월 - 금)",
            total: 4),
        GroupData(
            image: UIImage(systemName: "circle.fill")!,
            groupName: "group4",
            start: "부평",
            end: "일산",
            startTime: "08:30",
            endTime: "9:00",
            date: "주중(월 - 금)",
            total: 4),
        GroupData(
            image: UIImage(systemName: "square")!,
            groupName: "group5",
            start: "서울",
            end: "포항",
            startTime: "08:30",
            endTime: "9:00",
            date: "주중(월 - 금)",
            total: 4)
    ]
    private let journeyTogetherButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("여정 함께하기", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = 8
        return btn
    }()
    // 상단 그룹에 대한 컬렉션뷰입니다.
    private let groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal    // 좌우로 스크롤
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 여백 조정

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: "groupCell")
        collectionView.showsHorizontalScrollIndicator = false   // 스크롤바 숨기기
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setCollectionView()
        setJourneyTogetherButton()
    }
}

extension SessionStartViewController {
    private func setCollectionView() {
        view.addSubview(groupCollectionView)
        groupCollectionView.backgroundColor = .white
        groupCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(groupCollectionView.snp.width).dividedBy(2)
        }
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
    }
    private func setJourneyTogetherButton() {
        view.addSubview(journeyTogetherButton)
        journeyTogetherButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(120)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        journeyTogetherButton.addTarget(self, action: #selector(presentModalQueue), for: .touchUpInside)
    }
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
        return groupData.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 80, height: 106)
    }
}

extension SessionStartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupCollectionView.dequeueReusableCell(
            withReuseIdentifier: "groupCell",
            for: indexPath
        ) as? GroupCollectionViewCell
        cell?.groupData = self.groupData[indexPath.row]
        return cell!
    }
}
