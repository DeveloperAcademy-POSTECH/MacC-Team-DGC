//
//  SessionStartViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

// 이름은 데이터 구축되면 바꿀 예정입니다.
struct GroupData {
    var image: UIImage
    var groupName: String
    var start: String   // 출발지
    var end: String     // 도착지
    var startTime: String   // 출발 시간
    var endTime: String     // 도착 시간
    var date: String        // 타는 요일
    var total: Int          // 총 인원
}

final class SessionStartViewController: UIViewController {
    let groupData = [
        GroupData(image: UIImage(systemName: "heart")!, 
                  groupName: "group1",
                  start: "양덕",
                  end: "C5",
                  startTime: "08:30",
                  endTime: "9:00",
                  date: "주중(월 - 금)",
                  total: 4),
        GroupData(image: UIImage(systemName: "circle")!, 
                  groupName: "group2",
                  start: "포항",
                  end: "부산",
                  startTime: "08:30",
                  endTime: "9:00",
                  date: "주중(월 - 금)", 
                  total: 4),
        GroupData(image: UIImage(systemName: "heart.fill")!, 
                  groupName: "group3",
                  start: "인천",
                  end: "서울",
                  startTime: "08:30",
                  endTime: "9:00",
                  date: "주중(월 - 금)",
                  total: 4),
        GroupData(image: UIImage(systemName: "circle.fill")!, 
                  groupName: "group4",
                  start: "부평",
                  end: "일산",
                  startTime: "08:30",
                  endTime: "9:00",
                  date: "주중(월 - 금)",
                  total: 4),
        GroupData(image: UIImage(systemName: "square")!, 
                  groupName: "group5",
                  start: "서울",
                  end: "포항",
                  startTime: "08:30",
                  endTime: "9:00",
                  date: "주중(월 - 금)",
                  total: 4),
    ]
    let journeyTogetherButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("여정 함께하기", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = 8
        return btn
    }()

    fileprivate let groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal    // 좌우로 스크롤
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 여백 조정

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            groupCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            groupCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            groupCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            groupCollectionView.heightAnchor.constraint(equalTo: groupCollectionView.widthAnchor, multiplier: 0.5)
        ])
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
    }
    private func setJourneyTogetherButton() {
        view.addSubview(journeyTogetherButton)
        NSLayoutConstraint.activate([
            journeyTogetherButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            journeyTogetherButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            journeyTogetherButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            journeyTogetherButton.heightAnchor.constraint(equalToConstant: 120)  // 버튼의 높이 조절
        ])
        journeyTogetherButton.addTarget(self, action: #selector(presentModalQueue), for: .touchUpInside)
    }
    @objc private func presentModalQueue() {
        let modalQueueViewController = ModalQueueViewController()
        self.present(modalQueueViewController, animated: true)
    }
}

extension SessionStartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupData.count
    }
func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 106)    // 변경 필요
    }
}

extension SessionStartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupCollectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath)
                    as? GroupCollectionViewCell
        cell?.groupData = self.groupData[indexPath.row]
        return  cell!
    }
}
