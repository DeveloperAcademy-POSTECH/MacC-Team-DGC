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

    let carMarker = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "car")
        marker.width = 46
        marker.height = 59
        return marker
    }()

    private let points: Points

    let startingPoint = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "startingPoint")
        marker.width = 52
        marker.height = 24
        return marker
    }()

    let pickupLocation1 = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "stopover1")
        marker.width = 24
        marker.height = 24
        marker.hidden = true
        return marker
    }()

    let pickupLocation2 = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "stopover2")
        marker.width = 24
        marker.height = 24
        marker.hidden = true
        return marker
    }()

    let pickupLocation3 = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "stopover3")
        marker.width = 24
        marker.height = 24
        marker.hidden = true
        return marker
    }()

    let destination = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "destination")
        marker.width = 52
        marker.height = 24
        return marker
    }()

    let backButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "mapViewBackButton"), for: .normal)
        return backButton
    }()

    lazy var toastLabel = {
        let toastLabel = UILabel(frame: CGRect(x: (frame.size.width - 350) / 2, y: 60, width: 350, height: 60))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 16
        toastLabel.clipsToBounds = true
        return toastLabel
    }()

    init(points: Points) {
        self.points = points
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        addSubview(naverMap)
        naverMap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(55)
        }

        showPoints()
    }

    // TODO: - 크루의 실제 위경도 입력 받아서 넣어주기
    func showPoints() {
        startingPoint.position = NMGLatLng(lat: points.startingPoint.lat, lng: points.startingPoint.lng)
        startingPoint.anchor = CGPoint(x: 0.5, y: 0.5)
        startingPoint.mapView = naverMap

        if let coordinate = points.pickupLocation1 {
            pickupLocation1.hidden = false
            pickupLocation1.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
            pickupLocation1.anchor = CGPoint(x: 0.5, y: 0.5)
            pickupLocation1.mapView = naverMap
        }

        if let coordinate = points.pickupLocation2 {
            pickupLocation2.hidden = false
            pickupLocation2.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
            pickupLocation2.anchor = CGPoint(x: 0.5, y: 0.5)
            pickupLocation2.mapView = naverMap
        }

        if let coordinate = points.pickupLocation3 {
            pickupLocation3.hidden = false
            pickupLocation3.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
            pickupLocation3.anchor = CGPoint(x: 0.5, y: 0.5)
            pickupLocation3.mapView = naverMap
        }

        destination.position = NMGLatLng(lat: points.destination.lat, lng: points.destination.lng)
        destination.anchor = CGPoint(x: 0.5, y: 0.5)
        destination.mapView = naverMap
    }

    /// 위도, 경도를 입력받아 자동차의 현재 위치를 맵뷰에서 업데이트
    func updateCarMarker(latitide: Double, longitude: Double) {
        carMarker.position = NMGLatLng(lat: latitide, lng: longitude)
        carMarker.mapView = naverMap
        naverMap.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitide, lng: longitude)))
    }
}
