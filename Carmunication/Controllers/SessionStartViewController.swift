//
//  SessionStartViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

struct GroupData {
    var image: UIImage
    var groupName: String
}

final class SessionStartViewController: UIViewController {
    
    let groupData = [
        GroupData(image: UIImage(systemName: "heart")!, groupName: "group1"),
        GroupData(image: UIImage(systemName: "circle")!, groupName: "group2"),
        GroupData(image: UIImage(systemName: "heart.fill")!, groupName: "group3"),
        GroupData(image: UIImage(systemName: "circle.fill")!, groupName: "group4"),
        GroupData(image: UIImage(systemName: "square")!, groupName: "group5"),
        GroupData(image: UIImage(systemName: "heart")!, groupName: "group6")
    ]

    fileprivate let groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal    // 좌우로 스크롤
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 여백 조정

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: "groupCell")
        
        cv.showsHorizontalScrollIndicator = false   // 스크롤바 숨기기
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setCollectionView()
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
    
    
}

extension SessionStartViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 106)    // 변경 필요
    }
}

extension SessionStartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupCollectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as! GroupCollectionViewCell
        cell.groupData = self.groupData[indexPath.row]
        
        return  cell
    }
}
