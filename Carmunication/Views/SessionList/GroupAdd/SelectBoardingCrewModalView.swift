//
//  SelectBoardingCrewModalView.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

class SelectBoardingCrewModalView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "탑승 크루를 설정해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 18)

        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "해당 위치의 탑승 크루를 설정합니다"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 0

        return label
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        let backgroundImage = UIImage(named: "stopoverRemove")
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)

        return button
    }()

    let selectedCrewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal    // 좌우로 스크롤
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 여백 조정

        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: layout)
        collectionView.register(GroupAddModalCollectionViewCell.self, forCellWithReuseIdentifier: "selectedCrewCell")
        collectionView.showsHorizontalScrollIndicator = false   // 스크롤바 숨기기
        collectionView.backgroundColor = UIColor.semantic.backgroundSecond
        collectionView.layer.cornerRadius = 16
        collectionView.layer.masksToBounds = true
        return collectionView
    }()

    let friendsListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal    // 좌우로 스크롤
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 여백 조정

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GroupAddModalCollectionViewCell.self, forCellWithReuseIdentifier: "friendListCell")
        collectionView.showsHorizontalScrollIndicator = false   // 스크롤바 숨기기

        return collectionView
    }()

    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.accPrimary!), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.theme.white, for: .normal)

        return button
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(closeButton)
        addSubview(selectedCrewCollectionView)
        addSubview(friendsListCollectionView)
        addSubview(saveButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().inset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(28)
        }

        selectedCrewCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(90)
        }

        friendsListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedCrewCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(90)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(36)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.greaterThanOrEqualTo(200)
            make.height.equalTo(60)
        }
    }

}

// MARK: - Previewer
import SwiftUI

@available(iOS 13.0.0, *)
struct SelectBoardingCrewModalViewPreview: PreviewProvider {

    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }

}
