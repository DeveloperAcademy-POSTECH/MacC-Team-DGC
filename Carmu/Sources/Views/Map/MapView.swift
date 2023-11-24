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

    let myPositionMarker = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "myPosition")
        marker.width = 24
        marker.height = 24
        return marker
    }()

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
        let toastLabel = UILabel(frame: CGRect(x: frame.size.width / 2 + 18, y: 48, width: 350, height: 60))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 16
        toastLabel.clipsToBounds = true
        return toastLabel
    }()

    let currentLocationButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "currentLocation"), for: .normal)
        return button
    }()

    private var crew: Crew

    init(crew: Crew) {
        self.crew = crew
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
        naverMap.logoAlign = .rightBottom

        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(55)
        }

        showPoints()
    }

    func showPoints() {
        if let coordinate = crew.startingPoint, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            startingPoint.position = NMGLatLng(lat: latitude, lng: longitude)
            startingPoint.anchor = CGPoint(x: 0.5, y: 0.5)
            startingPoint.mapView = naverMap
        }

        if let coordinate = crew.stopover1, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            pickupLocation1.hidden = false
            pickupLocation1.position = NMGLatLng(lat: latitude, lng: longitude)
            pickupLocation1.anchor = CGPoint(x: 0.5, y: 0.5)
            pickupLocation1.mapView = naverMap
        }

        if let coordinate = crew.stopover2, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            pickupLocation2.hidden = false
            pickupLocation2.position = NMGLatLng(lat: latitude, lng: longitude)
            pickupLocation2.anchor = CGPoint(x: 0.5, y: 0.5)
            pickupLocation2.mapView = naverMap
        }

        if let coordinate = crew.stopover3, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            pickupLocation3.hidden = false
            pickupLocation3.position = NMGLatLng(lat: latitude, lng: longitude)
            pickupLocation3.anchor = CGPoint(x: 0.5, y: 0.5)
            pickupLocation3.mapView = naverMap
        }

        if let coordinate = crew.destination, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            destination.position = NMGLatLng(lat: latitude, lng: longitude)
            destination.anchor = CGPoint(x: 0.5, y: 0.5)
            destination.mapView = naverMap
        }
    }

    func showCurrentLocationButton() {
        addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(23)
            make.width.height.equalTo(36)
        }
    }

    /// 위도, 경도를 입력받아 자동차의 현재 위치를 맵뷰에서 업데이트
    func updateCarMarker(latitide: Double, longitude: Double) {
        carMarker.position = NMGLatLng(lat: latitide, lng: longitude)
        carMarker.mapView = naverMap
    }

    func updateMyPositionMarker(latitude: Double, longitude: Double) {
        myPositionMarker.position = NMGLatLng(lat: latitude, lng: longitude)
        myPositionMarker.mapView = naverMap
    }
}
