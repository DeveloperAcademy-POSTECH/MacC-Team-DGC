//
//  MapView.swift
//  Carmu
//
//  Created by 허준혁 on 11/5/23.
//

import UIKit

import NMapsMap

final class MapView: UIView {

    let naverMap = NMFMapView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(naverMap)
        naverMap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
