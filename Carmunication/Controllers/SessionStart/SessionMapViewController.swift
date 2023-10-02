//
//  SessionMapViewController.swift
//  Carmunication
//
//  Created by 김태형 on 2023/09/27.
//

import UIKit

import NMapsMap
import SnapKit

final class SessionMapViewController: UIViewController {

    private let mapView = NMFMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        showNaverMap()
    }

    private func showNaverMap() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
