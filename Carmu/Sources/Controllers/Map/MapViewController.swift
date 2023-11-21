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

final class MapViewController: UIViewController {

    private lazy var mapView = MapView(crew: crew)
    private lazy var detailView = MapDetailView(isDriver: isDriver)

    private let locationManager = CLLocationManager()

    private let firebaseManager = FirebaseManager()

    // [동승자] 내 현재 위치
    private var myCurrentCoordinate: CLLocationCoordinate2D?

    private var isDriver: Bool {
        crew.captainID == KeychainItem.currentUserIdentifier
    }

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

    private var crew: Crew

    init(crew: Crew) {
        self.crew = crew
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startUpdatingLocation()
        startObservingMemberStatus()
        startObservingDriverLocation()
        startObservingCrewLateTime()
        startObservingSessionStatus()
        setDetailView()
        setNaverMap()
    }

    override func viewDidAppear(_ animated: Bool) {
        // 출발지, 경유지, 도착지를 모두 포함하도록 맵뷰 초기 범위 설정
        initCameraUpdate()
        // 탑승자만 현위치 버튼을 표시
        if !isDriver {
            mapView.showCurrentLocationButton()
        }
    }

    /// [운전자, 탑승자] 실시간 위치 정보를 받아오기 위한 CoreLocation 세팅
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

    /// [운전자] 셔틀 탑승자의 지각 여부를 실시간으로 관찰하여 변화가 있을 경우 ScrollView에 반영
    private func startObservingMemberStatus() {
        guard isDriver else { return }
        firebaseManager.startObservingMemberStatus(crewID: crew.id) { memberStatus in
            self.detailView.crewScrollView.setDataSource(dataSource: memberStatus)
        }
    }

    /// [탑승자] 셔틀 탑승자는 운전자의 현재 위치를 실시간으로 추적하여 맵뷰에 반영
    private func startObservingDriverLocation() {
        guard !isDriver else { return }
        firebaseManager.startObservingDriverCoordinate(crewID: crew.id) { latitude, longitude in
            self.mapView.updateCarMarker(latitide: latitude, longitude: longitude)
        }
    }

    /// [탑승자] 셔틀 탑승자는 운전자가 보내는 지연시간을 실시간으로 추적, 하단뷰에 정보 반영
    private func startObservingCrewLateTime() {
        guard !isDriver else { return }
        firebaseManager.startObservingCrewLateTime(crewID: crew.id) { lateTime in
            self.crew.lateTime = lateTime
            self.detailView.setLateTime(crew: self.crew)
        }
    }

    /// [탑승자] 운전자가 운행을 종료했는지 실시간으로 추적하여 운행이 종료되었다면 얼럿을 띄워주고 맵뷰를 종료하는 메서드
    private func startObservingSessionStatus() {
        guard !isDriver else { return }
        firebaseManager.startObservingSessionStatus(crewID: crew.id) { sessionStatus in
            guard sessionStatus == .waiting else { return }
            self.showFinishedAlert()
        }
    }

    /// [탑승자] 운행이 종료되었다는 얼럿을 띄우고 맵뷰를 종료하는 메서드
    private func showFinishedAlert() {
        let alert = UIAlertController(title: "운전자가 셔틀 운행을 종료했습니다", message: "확인을 누르면 대기화면으로 돌아갑니다", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }

    /// [운전자] 도착지 주변에서 일정 시간이 지났는데 운행을 종료하지 않았을 경우 맵뷰를 종료하는 얼럿을 띄우는 메서드
    private func showFinishedAlertForDriver() {
        guard crew.sessionStatus == .sessionStart else { return }
        guard let pnc = self.presentingViewController as? UINavigationController else { return }
        guard let pvc = pnc.topViewController as? SessionStartViewController else { return }
        let alert = UIAlertController(title: "셔틀 운행이 종료되었습니다", message: "확인을 누르면 대기화면으로 돌아갑니다", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true) {
                self.updateSessionStatus(to: .waiting)
                pvc.showCarpoolFinishedModal()
            }
        }
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }

    /// [운전자, 탑승자] 운전자, 탑승자별로 다른 하단뷰를 표시
    private func setDetailView() {
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(isDriver ? 312 : 273)
        }

        detailView.titleLabel.text = crew.name

        // 운전자의 경우 하단뷰에 탑승자 정보 표시
        if isDriver {
            detailView.crewScrollView.setDataSource(dataSource: crew.memberStatus ?? [])
        // 동승자의 경우 탑승 위치, 시간 표기
        } else if let location = firebaseManager.myPickUpLocation(crew: crew) {
            detailView.pickUpLocationAddressLabel.text = location.detailAddress ?? ""
            detailView.setLateTime(crew: crew)
        }

        detailView.giveUpButton.addTarget(self, action: #selector(giveUpButtonDidTap), for: .touchUpInside)
        detailView.noticeLateButton.addTarget(self, action: #selector(showNoticeLateModal), for: .touchUpInside)
        detailView.finishShuttleButton.addTarget(self, action: #selector(finishShuttleButtonDidTap), for: .touchUpInside)
    }

    /// [운전자, 탑승자] Naver 지도(출발, 경유, 도착지 및 운전 경로 등등)를 위한 설정
    private func setNaverMap() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(detailView.snp.top)
        }

        // 운전 경로 표시
        fetchDirections()

        mapView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        mapView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
    }

    /// [운전자, 탑승자] '포기하기' 버튼 선택시 동작
    @objc func giveUpButtonDidTap() {
        let alert = UIAlertController(title: "정말 포기하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.message = isDriver ? "셔틀 운행을 중도 포기합니다" : "셔틀 탑승을 중도 포기합니다"
        let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
        let giveUpAction = UIAlertAction(title: "포기하기", style: .destructive) { _ in
            self.updateSessionStatus(to: .waiting)
            self.dismiss(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(giveUpAction)
        present(alert, animated: true)
    }

    /// [운전자, 탑승자] '지각 알리기' 버튼 선택시 동작
    @objc private func showNoticeLateModal() {
        present(NoticeLateViewController(crew: crew), animated: true)
    }

    /// [운전자] '운행 종료하기' 버튼 선택시 동작
    @objc private func finishShuttleButtonDidTap() {
        guard let pnc = presentingViewController as? UINavigationController else { return }
        guard let pvc = pnc.topViewController as? SessionStartViewController else { return }
        dismiss(animated: true) {
            self.updateSessionStatus(to: .waiting)
            pvc.showCarpoolFinishedModal()
        }
    }

    /// [운전자, 탑승자] '<' 버튼 선택시 동작
    @objc private func backButtonDidTap() {
        dismiss(animated: true)
    }

    /// [탑승자] 현위치 버튼 선택시 동작
    @objc private func currentLocationButtonDidTap() {
        guard let myCurrentCoordinate = myCurrentCoordinate else { return }
        mapView.naverMap.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(from: myCurrentCoordinate)))
    }

    /// [운전자, 탑승자] 출발지, 경유지, 도착지를 모두 포함하는 Bound 설정
    private func initCameraUpdate() {
        var latLngs: [NMGLatLng] = []
        if let coordinate = crew.startingPoint, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            latLngs.append(NMGLatLng(lat: latitude, lng: longitude))
        }
        if let coordinate = crew.stopover1, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            latLngs.append(NMGLatLng(lat: latitude, lng: longitude))
        }
        if let coordinate = crew.stopover2, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            latLngs.append(NMGLatLng(lat: latitude, lng: longitude))
        }
        if let coordinate = crew.stopover3, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            latLngs.append(NMGLatLng(lat: latitude, lng: longitude))
        }
        if let coordinate = crew.destination, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            latLngs.append(NMGLatLng(lat: latitude, lng: longitude))
        }
        let paddingInsets = UIEdgeInsets(top: 170, left: 80, bottom: 50, right: 50)
        let cameraUpdate = NMFCameraUpdate(fit: NMGLatLngBounds(latLngs: latLngs), paddingInsets: paddingInsets)
        mapView.naverMap.moveCamera(cameraUpdate)
    }

    /// [운전자, 탑승자] 맵뷰에 셔틀 이동경로 표시
    private func fetchDirections() {
        var urlString = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving"
        if let coordinate = crew.startingPoint, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            urlString += "?start=\(longitude),\(latitude)"
        }
        if let coordinate = crew.destination, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            urlString += "&goal=\(longitude),\(latitude)"
        }
        if let coordinate = crew.stopover1, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            urlString += "&waypoints=\(longitude),\(latitude)"
        }
        if let coordinate = crew.stopover2, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            urlString += "|\(longitude),\(latitude)"
        }
        if let coordinate = crew.stopover3, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            urlString += "|\(longitude),\(latitude)"
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

    /// [운전자] 도착지로부터 몇 m 떨어져있는지 반환하는 함수 (200m 이내라면 버튼이 달라짐)
    private func distanceFromDestination(current: CLLocation) -> Double {
        // TODO: - 불필요한 옵셔널로 인한 guard문 삭제, 무효한 데이터이므로 도착지에 도착하지 못하도록 200보다 큰 수로 설정해둠
        guard let coordinate = crew.destination, let latitude = coordinate.latitude, let longitude = coordinate.longitude else {
            return 300.0
        }
        let destinationCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        let distance = destinationCoordinate.distance(from: current)
        return Double(distance)
    }

    /// [운전자] '포기하기' 버튼 혹은 '운행 종료하기' 버튼 선택시 sessionStatus를 변경하는 메서드
    private func updateSessionStatus(to sessionStatus: Status) {
        crew.sessionStatus = sessionStatus
        firebaseManager.updateSessionStatus(to: sessionStatus, crew: crew)
    }
}

extension MapViewController: CLLocationManagerDelegate {

    /**
     [운전자, 탑승자] 실시간 현재 위치를 업데이트
     운전자의 경우 현재 위치를 맵뷰에 자동차 마커로 표시하고 DB에 현재 위치를 반영, 도착지 주변인 경우 하단뷰에 버튼 변경
     탑승자의 경우 현재 위치를 동그라미 마커로 표시
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        if isDriver {
            // 운전자화면에서 자동차 마커 위치 변경
            mapView.updateCarMarker(latitide: location.coordinate.latitude, longitude: location.coordinate.longitude)
            // 운전자인 경우 DB에 위도, 경도 업데이트
            firebaseManager.updateDriverCoordinate(coordinate: location.coordinate, crewID: crew.id)
            // 도착지로부터 200m 이내인 경우 하단 레이아웃 변경, 15분 후 셔틀 종료 안내 얼럿
            if distanceFromDestination(current: location) <= 200.0 {
                detailView.showFinishCarpoolButton()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 900) {
                    self.showFinishedAlertForDriver()
                }
            }
        } else {
            mapView.updateMyPositionMarker(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            myCurrentCoordinate = location.coordinate
        }
    }

    // 에러시 호출되는 함수
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
