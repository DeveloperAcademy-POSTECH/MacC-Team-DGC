//
//  SessionMapViewController.swift
//  Carmunication
//
//  Created by 김태형 on 2023/09/27.
//

import CoreLocation
import UIKit

import NMapsMap
import SnapKit

final class SessionMapViewController: UIViewController {

    private let mapView = NMFMapView()
    // 자동차 위치를 표시하기 위한 마커
    private let carMarker = NMFMarker()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        startUpdatingLocation()
        showNaverMap()
        showBackButton()
    }

    private func showNaverMap() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func showBackButton() {
        let backButton = UIButton(type: .custom, primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        backButton.setImage(UIImage(named: "mapViewBackButton"), for: .normal)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(50)
            make.width.height.equalTo(60)
        }
    }

    private func startUpdatingLocation() {
        // 델리게이트 설정
        locationManager.delegate = self
        // 배터리 동작시 가장 높은 수준의 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 백그라운드에서도 위치 정보 업데이트 허용
        locationManager.allowsBackgroundLocationUpdates = true
        // 위치 허용 alert 표시
        locationManager.requestWhenInUseAuthorization()
        // 위도, 경도 정보 가져오기 시작
        locationManager.startUpdatingLocation()
    }
}

extension SessionMapViewController: CLLocationManagerDelegate {

    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        // 지도상의 자동차 위치 갱신
        carMarker.position = NMGLatLng(from: location.coordinate)
        carMarker.mapView = mapView
        // 카메라 시점도 자동차 위치로 변경
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(from: location.coordinate)))
    }

    // 에러시 호출되는 함수
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
