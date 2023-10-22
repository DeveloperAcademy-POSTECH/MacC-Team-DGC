//
//  SessionMapViewController.swift
//  Carmu
//
//  Created by 김태형 on 2023/09/27.
//

import CoreLocation
import UIKit

import NMapsMap
import SnapKit

// Firebase 데이터 받아오기 전까지만 사용하는 더미데이터
struct Coordinate {
    let lat: Double
    let lng: Double
}

struct Points {
    let startingPoint = Coordinate(lat: 36.01759520, lng: 129.32206275)
    let pickupLocation1: Coordinate? = Coordinate(lat: 36.00609523, lng: 129.32232291)
    let pickupLocation2: Coordinate? = Coordinate(lat: 36.00739176, lng: 129.32907574)
    let pickupLocation3: Coordinate? = nil
    let destination = Coordinate(lat: 36.0108783, lng: 129.327818)
}
// Firebase 데이터 받아오기 전까지만 사용하는 더미데이터

final class SessionMapViewController: UIViewController {

    private let mapView = NMFMapView()
    // 자동차 위치를 표시하기 위한 마커
    private let carMarker = NMFMarker()
    private let locationManager = CLLocationManager()
    private let points = Points()

    private let startingPoint = {
        let marker = NMFMarker()
        return marker
    }()

    private let pickupLocation1 = {
        let marker = NMFMarker()
        marker.hidden = true
        return marker
    }()

    private let pickupLocation2 = {
        let marker = NMFMarker()
        marker.hidden = true
        return marker
    }()

    private let pickupLocation3 = {
        let marker = NMFMarker()
        marker.hidden = true
        return marker
    }()

    private let destination = {
        let marker = NMFMarker()
        return marker
    }()

    private let pathOverlay = {
        let pathOverlay = NMFPath()
        return pathOverlay
    }()

    private lazy var backButton = {
        let backButton = UIButton(type: .custom, primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        backButton.setImage(UIImage(named: "mapViewBackButton"), for: .normal)
        return backButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        startUpdatingLocation()
        showNaverMap()
        showBackButton()
        showQuitButton()
        showPickuplocations()
        fetchDirections()
    }

    private func showNaverMap() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func showBackButton() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(50)
            make.width.height.equalTo(60)
        }
    }

    private func showQuitButton() {
        let quitButton = UIButton(type: .custom, primaryAction: UIAction(handler: { _ in
            self.locationManager.stopUpdatingLocation()
            self.dismiss(animated: true)
        }))
        quitButton.setImage(UIImage(named: "quitCarpoolButton"), for: .normal)
        quitButton.imageView?.contentMode = .scaleAspectFit
        view.addSubview(quitButton)
        quitButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(7)
            make.centerY.equalTo(backButton)
            make.width.equalTo(120)
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

    // TODO: - 그룹의 실제 위경도 입력 받아서 넣어주기
    private func showPickuplocations() {
        startingPoint.position = NMGLatLng(lat: points.startingPoint.lat, lng: points.startingPoint.lng)
        startingPoint.iconImage = NMFOverlayImage(name: "startingPoint")
        startingPoint.mapView = mapView

        if let coordinate = points.pickupLocation1 {
            pickupLocation1.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
            pickupLocation1.iconImage = NMFOverlayImage(name: "pickupLocation1")
            pickupLocation1.hidden = false
            pickupLocation1.mapView = mapView
        }

        if let coordinate = points.pickupLocation2 {
            pickupLocation2.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
            pickupLocation2.iconImage = NMFOverlayImage(name: "pickupLocation2")
            pickupLocation2.hidden = false
            pickupLocation2.mapView = mapView
        }

        if let coordinate = points.pickupLocation3 {
            pickupLocation3.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
            pickupLocation3.iconImage = NMFOverlayImage(name: "pickupLocation3")
            pickupLocation3.hidden = false
            pickupLocation3.mapView = mapView
        }

        destination.position = NMGLatLng(lat: points.destination.lat, lng: points.destination.lng)
        destination.iconImage = NMFOverlayImage(name: "destination")
        destination.mapView = mapView
    }

    private func fetchDirections() {
        var urlString = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving"
        + "?start=\(points.startingPoint.lng),\(points.startingPoint.lat)"
        + "&goal=\(points.destination.lng),\(points.destination.lat)"
        if let stopover1 = points.pickupLocation1 {
            urlString += "&waypoints=\(stopover1.lng),\(stopover1.lat)"
        }
        if let stopover2 = points.pickupLocation2 {
            urlString += "|\(stopover2.lng),\(stopover2.lat)"
        }
        if let stopover3 = points.pickupLocation3 {
            urlString += "|\(stopover3.lng),\(stopover3.lat)"
        }
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("유효하지 않은 URL입니다.")
            return
        }
        var request = URLRequest(url: url)
        request.setValue(Bundle.main.naverMapClientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.setValue(Bundle.main.naverMapClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("에러 발생: \(error)")
                return
            }
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                return
            }
            if let jsonData = responseString.data(using: .utf8),
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let route = jsonObject["route"] as? [String: Any],
               let traoptimal = route["traoptimal"] as? [[String: Any]],
               let firstPath = traoptimal.first,
               let path = firstPath["path"] as? [[Double]] {
                var points = [NMGLatLng]()
                for point in path {
                    points.append(NMGLatLng(lat: point[1], lng: point[0]))
                }
                self.pathOverlay.path = NMGLineString(points: points)
                DispatchQueue.main.async {
                    self.pathOverlay.mapView = self.mapView
                }
            }
        }
        task.resume()
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
