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
    let destination = Coordinate(lat: 36.01449161092546, lng: 129.32561818469742)
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
        pathOverlay.color = UIColor.theme.blue6 ?? .blue
        pathOverlay.outlineColor = UIColor.theme.blue3 ?? .blue
        pathOverlay.width = 8
        if let uiImage = UIImage(named: "triangle") {
            pathOverlay.patternIcon = NMFOverlayImage(image: uiImage)
            pathOverlay.patternInterval = 10
        }
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
        fetchDirections()
        mapView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        detailView.giveUpButton.addTarget(self, action: #selector(giveUpButtonDidTap), for: .touchUpInside)
        detailView.noticeLateButton.addTarget(self, action: #selector(showNoticeLateModal), for: .touchUpInside)
        detailView.finishCarpoolButton.addTarget(self, action: #selector(finishCarpoolButtonDidTap), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        initCameraUpdate()
    }

    @objc private func backButtonDidTap() {
        dismiss(animated: true)
    }

    @objc private func showNoticeLateModal() {
        present(NoticeLateViewController(), animated: true)
    }

    @objc private func finishCarpoolButtonDidTap() {
        guard let pnc = presentingViewController as? UINavigationController else { return }
        guard let pvc = pnc.topViewController as? SessionStartViewController else { return }
        dismiss(animated: true) {
            pvc.showCarpoolFinishedModal()
        }
    }

    private func showNaverMap() {
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(isDriver ? 312 : 273)
        }

        detailView.titleLabel.text = "운좋은 카풀팟"

        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(detailView.snp.top)
        }
    }

    private func initCameraUpdate() {
        var latLngs: [NMGLatLng] = []
        latLngs.append(NMGLatLng(lat: points.startingPoint.lat, lng: points.startingPoint.lng))
        latLngs.append(NMGLatLng(lat: points.destination.lat, lng: points.destination.lng))
        if let coordinate = points.pickupLocation1 {
            latLngs.append(NMGLatLng(lat: coordinate.lat, lng: coordinate.lng))
        }
        if let coordinate = points.pickupLocation2 {
            latLngs.append(NMGLatLng(lat: coordinate.lat, lng: coordinate.lng))
        }
        if let coordinate = points.pickupLocation3 {
            latLngs.append(NMGLatLng(lat: coordinate.lat, lng: coordinate.lng))
        }
        let paddingInsets = UIEdgeInsets(top: 170, left: 50, bottom: 50, right: 50)
        let cameraUpdate = NMFCameraUpdate(fit: NMGLatLngBounds(latLngs: latLngs), paddingInsets: paddingInsets)
        mapView.naverMap.moveCamera(cameraUpdate)
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

    @objc func giveUpButtonDidTap() {
        let alert = UIAlertController(title: "정말 포기하시겠습니까?", message: "탑승을 중도 포기합니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
        let giveUpAction = UIAlertAction(title: "포기하기", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(giveUpAction)
        present(alert, animated: true)
    }

    private func distanceFromDestination(current: CLLocation) -> Double {
        let destinationCoordinate = CLLocation(latitude: points.destination.lat, longitude: points.destination.lng)
        let distance = destinationCoordinate.distance(from: current)
        return Double(distance)
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
        // 도착지로부터 200m 이내인 경우 하단 레이아웃 변경
        if distanceFromDestination(current: location) <= 200.0 {
            detailView.showFinishCarpoolButton()
        }
    }

    // 에러시 호출되는 함수
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
