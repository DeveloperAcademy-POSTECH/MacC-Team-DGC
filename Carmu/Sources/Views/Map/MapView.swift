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
