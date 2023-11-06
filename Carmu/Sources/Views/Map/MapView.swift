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

    private let carMarker = NMFMarker()

    let startingPoint = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "startingPoint")
        return marker
    }()

    let pickupLocation1 = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "pickupLocation1")
        marker.hidden = true
        return marker
    }()

    let pickupLocation2 = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "pickupLocation2")
        marker.hidden = true
        return marker
    }()

    let pickupLocation3 = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "pickupLocation3")
        marker.hidden = true
        return marker
    }()

    let destination = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "destination")
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(naverMap)
        naverMap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(50)
            make.width.height.equalTo(60)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func changeMarkerColor(location: PickupLocation) {
        switch location {
        case .startingPoint:
            startingPoint.iconImage = NMFOverlayImage(name: "startingPointTapped")
            pickupLocation1.iconImage = NMFOverlayImage(name: "pickupLocation1")
            pickupLocation2.iconImage = NMFOverlayImage(name: "pickupLocation2")
            pickupLocation3.iconImage = NMFOverlayImage(name: "pickupLocation3")
            destination.iconImage = NMFOverlayImage(name: "destination")
        case .pickupLocation1:
            startingPoint.iconImage = NMFOverlayImage(name: "startingPoint")
            pickupLocation1.iconImage = NMFOverlayImage(name: "pickupLocation1Tapped")
            pickupLocation2.iconImage = NMFOverlayImage(name: "pickupLocation2")
            pickupLocation3.iconImage = NMFOverlayImage(name: "pickupLocation3")
            destination.iconImage = NMFOverlayImage(name: "destination")
        case .pickupLocation2:
            startingPoint.iconImage = NMFOverlayImage(name: "startingPoint")
            pickupLocation1.iconImage = NMFOverlayImage(name: "pickupLocation1")
            pickupLocation2.iconImage = NMFOverlayImage(name: "pickupLocation2Tapped")
            pickupLocation3.iconImage = NMFOverlayImage(name: "pickupLocation3")
            destination.iconImage = NMFOverlayImage(name: "destination")
        case .pickupLocation3:
            startingPoint.iconImage = NMFOverlayImage(name: "startingPoint")
            pickupLocation1.iconImage = NMFOverlayImage(name: "pickupLocation1")
            pickupLocation2.iconImage = NMFOverlayImage(name: "pickupLocation2")
            pickupLocation3.iconImage = NMFOverlayImage(name: "pickupLocation3Tapped")
            destination.iconImage = NMFOverlayImage(name: "destination")
        case .destination:
            startingPoint.iconImage = NMFOverlayImage(name: "startingPoint")
            pickupLocation1.iconImage = NMFOverlayImage(name: "pickupLocation1")
            pickupLocation2.iconImage = NMFOverlayImage(name: "pickupLocation2")
            pickupLocation3.iconImage = NMFOverlayImage(name: "pickupLocation3")
            destination.iconImage = NMFOverlayImage(name: "destinationTapped")
        }
    }

    /// 위도, 경도를 입력받아 자동차의 현재 위치를 맵뷰에서 업데이트
    func updateCarMarker(latitide: Double, longitude: Double) {
        carMarker.position = NMGLatLng(lat: latitide, lng: longitude)
        carMarker.mapView = naverMap
        naverMap.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitide, lng: longitude)))
    }
}
