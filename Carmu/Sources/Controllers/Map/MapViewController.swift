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

    private let mapView = MapView()
    private let detailView = MapDetailView()
    // 자동차 위치를 표시하기 위한 마커
    private let carMarker = NMFMarker()
    private let locationManager = CLLocationManager()
    private let points = Points()

    private let firebaseManager = FirebaseManager()

    private let isDriver = true

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
        if isDriver {
            startUpdatingLocation()
        } else {
            firebaseManager.startObservingDriveLocation { latitude, longitude in
                self.updateCarMarker(latitide: latitude, longitude: longitude)
            }
        }
        showNaverMap()
        showBackButton()
        showPickuplocations()
        touchMarker(location: .startingPoint, address: "기숙사 18동")
        fetchDirections()
        detailView.noticeLateButton.addTarget(self, action: #selector(showNoticeLateModal), for: .touchUpInside)
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

    private func showBackButton() {
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

    // TODO: - 크루의 실제 위경도 입력 받아서 넣어주기
    private func showPickuplocations() {
        mapView.startingPoint.position = NMGLatLng(lat: points.startingPoint.lat, lng: points.startingPoint.lng)
        mapView.startingPoint.touchHandler = { (_: NMFOverlay) -> Bool in
            self.touchMarker(location: .startingPoint, address: "기숙사 18동")
            return true
        }
        mapView.startingPoint.mapView = mapView.naverMap

        if let coordinate = points.pickupLocation1 {
            mapView.pickupLocation1.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
            mapView.pickupLocation1.hidden = false
            mapView.pickupLocation1.touchHandler = { (_: NMFOverlay) -> Bool in
                self.touchMarker(location: .pickupLocation1, address: "테드집")
                return true
            }
            mapView.pickupLocation1.mapView = mapView.naverMap
        }

        if let coordinate = points.pickupLocation2 {
            mapView.pickupLocation2.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
            mapView.pickupLocation2.hidden = false
            mapView.pickupLocation2.touchHandler = { (_: NMFOverlay) -> Bool in
                self.touchMarker(location: .pickupLocation2, address: "롯데리아")
                return true
            }
            mapView.pickupLocation2.mapView = mapView.naverMap
        }

        if let coordinate = points.pickupLocation3 {
            mapView.pickupLocation3.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
            mapView.pickupLocation3.hidden = false
            mapView.pickupLocation3.touchHandler = { (_: NMFOverlay) -> Bool in
                self.touchMarker(location: .pickupLocation3, address: "미정")
                return true
            }
            mapView.pickupLocation3.mapView = mapView.naverMap
        }

        mapView.destination.position = NMGLatLng(lat: points.destination.lat, lng: points.destination.lng)
        mapView.destination.touchHandler = { (_: NMFOverlay) -> Bool in
            self.touchMarker(location: .destination, address: "애플 디벨로퍼 아카데미")
            return true
        }
        mapView.destination.mapView = mapView.naverMap
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
        let toastLabel = UILabel(frame: CGRect(
            x: (view.frame.size.width - 350) / 2,
            y: 60,
            width: 350,
            height: 60)
        )
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 16
        toastLabel.clipsToBounds  =  true

        view.addSubview(toastLabel)

        UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(_) in
            toastLabel.removeFromSuperview()
        })
    }

    /// 위도, 경도를 입력받아 자동차의 현재 위치를 맵뷰에서 업데이트
    func updateCarMarker(latitide: Double, longitude: Double) {
        carMarker.position = NMGLatLng(lat: latitide, lng: longitude)
        carMarker.mapView = mapView.naverMap
        mapView.naverMap.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitide, lng: longitude)))
    }
}

extension MapViewController: CLLocationManagerDelegate {

    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        // 운전자화면에서 자동차 마커 위치 변경
        updateCarMarker(latitide: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // 운전자인 경우 DB에 위도, 경도 업데이트
        firebaseManager.updateDriverCoordinate(coordinate: location.coordinate)
    }

    // 에러시 호출되는 함수
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
