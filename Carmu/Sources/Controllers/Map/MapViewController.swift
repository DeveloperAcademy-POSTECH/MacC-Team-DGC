//
//  MapViewController.swift
//  Carmu
//
//  Created by 김태형 on 2023/09/27.
//

import CoreLocation
import UIKit

import FirebaseDatabase
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

final class MapViewController: UIViewController {

    private lazy var mapView = MapView(points: points)
    private let detailView = MapDetailView()

    private let locationManager = CLLocationManager()
    private let points = Points()

    private let firebaseManager = FirebaseManager()

    private let isDriver = true

    private let pathOverlay = {
        let pathOverlay = NMFPath()
        return pathOverlay
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if isDriver {
            startUpdatingLocation()
        } else {
            firebaseManager.startObservingDriveLocation { latitude, longitude in
                self.mapView.updateCarMarker(latitide: latitude, longitude: longitude)
            }
        }
        showNaverMap()
        showPickuplocations()
        touchMarker(location: .startingPoint, address: "기숙사 18동")
        fetchDirections()
        mapView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        detailView.noticeLateButton.addTarget(self, action: #selector(showNoticeLateModal), for: .touchUpInside)
    }

    @objc private func backButtonDidTap() {
        dismiss(animated: true)
    }

    @objc private func showNoticeLateModal() {
        present(NoticeLateViewController(), animated: true)
    }

    private func showNaverMap() {
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(234)
        }

        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(detailView.snp.top)
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

    private func showPickuplocations() {
        mapView.startingPoint.touchHandler = { (_: NMFOverlay) -> Bool in
            self.touchMarker(location: .startingPoint, address: "기숙사 18동")
            return true
        }

        if let coordinate = points.pickupLocation1 {
            mapView.pickupLocation1.touchHandler = { (_: NMFOverlay) -> Bool in
                self.touchMarker(location: .pickupLocation1, address: "테드집")
                return true
            }
        }

        if let coordinate = points.pickupLocation2 {
            mapView.pickupLocation2.touchHandler = { (_: NMFOverlay) -> Bool in
                self.touchMarker(location: .pickupLocation2, address: "롯데리아")
                return true
            }
        }

        if let coordinate = points.pickupLocation3 {
            mapView.pickupLocation3.touchHandler = { (_: NMFOverlay) -> Bool in
                self.touchMarker(location: .pickupLocation3, address: "미정")
                return true
            }
        }

        mapView.destination.touchHandler = { (_: NMFOverlay) -> Bool in
            self.touchMarker(location: .destination, address: "애플 디벨로퍼 아카데미")
            return true
        }
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
                    self.pathOverlay.mapView = self.mapView.naverMap
                }
            }
        }
        task.resume()
    }

    private func touchMarker(location: PickupLocation, address: String) {
        mapView.changeMarkerColor(location: location)
        detailView.setDetailView(location: location, address: address)
    }

    // Toast 알림 띄워주기
    func showToast(_ message: String, withDuration: Double, delay: Double) {
        mapView.toastLabel.text = message
        view.addSubview(mapView.toastLabel)
        UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
            self.mapView.toastLabel.alpha = 0.0
        }, completion: {(_) in
            self.mapView.toastLabel.removeFromSuperview()
        })
    }
}

extension MapViewController: CLLocationManagerDelegate {

    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        // 운전자화면에서 자동차 마커 위치 변경
        mapView.updateCarMarker(latitide: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // 운전자인 경우 DB에 위도, 경도 업데이트
        firebaseManager.updateDriverCoordinate(coordinate: location.coordinate)
    }

    // 에러시 호출되는 함수
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
