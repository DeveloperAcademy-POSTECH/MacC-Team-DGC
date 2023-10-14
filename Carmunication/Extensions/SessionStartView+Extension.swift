//
//  SessionStartView+Extension.swift
//  Carmunication
//
//  Created by 김태형 on 2023/10/09.
//

import UIKit

import SnapKit

extension SessionStartView {

    override func draw(_ rect: CGRect) {
        setCollectionView()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }

    func setupUI() {

        addSubview(groupCollectionView)
        addSubview(journeyTogetherButton)
    }

    func setCollectionView() {
        groupCollectionView.backgroundColor = .white

        let collectionViewHeight: CGFloat
        if UIScreen.main.bounds.height >= 800 {
            // iPhone 14와 같이 큰 화면
            collectionViewHeight = 104
        } else {
            // iPhone SE와 같이 작은 화면
            collectionViewHeight = 84
        }

        groupCollectionView.snp.makeConstraints { make in
            make.height.equalTo(collectionViewHeight)
            make.top.lessThanOrEqualTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview()
        }
    }

    func setupGroupData() {

        // 그룹이 하나 이상 있을 때 나타내는 정보들
        if groupData == nil {
            journeyTogetherButton.setTitleColor(UIColor.theme.blue3, for: .normal)
            journeyTogetherButton.backgroundColor = UIColor.semantic.backgroundSecond
            journeyTogetherButton.isEnabled = false
        }
    }
}
