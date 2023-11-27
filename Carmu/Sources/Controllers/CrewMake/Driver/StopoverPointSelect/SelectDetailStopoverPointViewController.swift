//
//  SelectDetailStopoverPointView.swift
//  Carmu
//
//  Created by 김동현 on 11/10/23.
//

import UIKit

import NMapsMap

/**
 이 컨트롤러에서만 사용하는 NMGLatLng Model
 */
struct PointLatLng {
    var startingPoint: NMGLatLng
    var pickupLocation1: NMGLatLng?
    var pickupLocation2: NMGLatLng?
    var pickupLocation3: NMGLatLng?
    var destination: NMGLatLng
}

final class SelectDetailStopoverPointViewController: UIViewController {

    let stopoverPointMapView = SelectDetailStopoverPointView()
    private let loadingView = LoadingView()
    var addressSelectionHandler: ((AddressDTO) -> Void)?
    private var points: PointLatLng
    private var addressDTO = AddressDTO()
    var currentLatLng: NMGLatLng?
    var isCrewEdit: Bool = false // 크루 편집 시 넘어온 화면인지 체크
    var pointType: PointType = .stopover1 // 출발지~경유지~도착지 중 어느 포인트인지
    var isValueSetted = [false, false, false] // 경유지1,2,3에 상세주소 값이 들어가있는지 확인하기 위한 배열 (false면 값이 들어가 있지 않은 상태)

    init(crewData: Crew) {
        self.points = PointLatLng(
            startingPoint: NMGLatLng(
                lat: crewData.startingPoint?.latitude ?? 37.234,
                lng: crewData.startingPoint?.longitude ?? 132.232
            ),
            destination: NMGLatLng(
                lat: crewData.destination?.latitude ?? 37.234,
                lng: crewData.destination?.longitude ?? 132.232
            )
        )

        if crewData.stopover1 != nil {
            self.points.pickupLocation1 = NMGLatLng(
                lat: crewData.stopover1?.latitude ?? 37.234,
                lng: crewData.stopover1?.longitude ?? 132.232
            )
            // 경유지가 추가만 되고 아직 주소는 설정되지 않은 곳인지 확인
            if crewData.stopover1?.name != "주소를 검색해주세요" {
                isValueSetted[0] = true
            }
        }
        if crewData.stopover2 != nil {
            self.points.pickupLocation2 = NMGLatLng(
                lat: crewData.stopover2?.latitude ?? 37.234,
                lng: crewData.stopover2?.longitude ?? 132.232
            )
            if crewData.stopover2?.name != "주소를 검색해주세요" {
                isValueSetted[1] = true
            }
        }
        if crewData.stopover3 != nil {
            self.points.pickupLocation3 = NMGLatLng(
                lat: crewData.stopover3?.latitude ?? 37.234,
                lng: crewData.stopover3?.longitude ?? 132.232
            )
            if crewData.stopover3?.name != "주소를 검색해주세요" {
                isValueSetted[2] = true
            }
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        view.addSubview(stopoverPointMapView)
        stopoverPointMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        navigationSetting()
        stopoverPointMapView.mapView.addCameraDelegate(delegate: self)
        stopoverPointMapView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        stopoverPointMapView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)

        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingView.showLoadingView(showInterval: 1.5)
    }

    override func viewDidAppear(_ animated: Bool) {
        mapBoundSettingCheck(isEdit: isCrewEdit)
        stopoverPointMapView.showExplain()
    }
}

// MARK: - @objc Method
extension SelectDetailStopoverPointViewController {

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonAction() {
        addressDTO.pointName = stopoverPointMapView.buildingNameLabel.text
        addressDTO.pointDetailAddress = stopoverPointMapView.detailAddressLabel.text
        addressDTO.pointLat = currentLatLng?.lat
        addressDTO.pointLng = currentLatLng?.lng
        addressSelectionHandler?(addressDTO)
        dismiss(animated: true)
    }
}

// MARK: - Custom Method
extension SelectDetailStopoverPointViewController {

    /**
     출발, 도착 마커 표시, 경로 표시, 중간 좌표  지점 건물명, 상세주소 최초 업데이트
     */
    private func navigationSetting() {
        stopoverPointMapView.showPoints(points: points, isValueSetted: isValueSetted)
        fetchDirections()
    }

    // 크루 편집 여부에 따라 카메라 업데이트를 다르게 처리
    func mapBoundSettingCheck(isEdit: Bool = false) {
        if isEdit {
            mapBoundSettingForEdit(pointType: pointType)
        } else {
            mapBoundSetting()
        }
    }
    /**
     출발, 도착, 경유지를 한 화면에 표시할 수 있는 영역을 보이도록 CameraUpdate 하는 메서드
     -  bounds의 중앙으로 잡아주는 경우 (기본)
     */
    private func mapBoundSetting() {
        let bounds = mapBoundsForPoints(points: points)
        let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 50)
        stopoverPointMapView.mapView.moveCamera(cameraUpdate)
        currentLatLng = bounds.center

        getAddressAndBuildingName(bounds.center) { buildingName, detailAddress in
            // 주소와 건물명을 업데이트
            DispatchQueue.main.async {
                self.stopoverPointMapView.buildingNameLabel.text = buildingName
                self.stopoverPointMapView.detailAddressLabel.text = detailAddress
            }
        }
    }
    /**
     - 해당하는 기존 포인트 위치로 카메라 업데이트 (크루 편집 시)
     */
    private func mapBoundSettingForEdit(pointType: PointType) {
        let cameraUpdate: NMFCameraUpdate
        switch pointType {
        case .start:
            cameraUpdate = NMFCameraUpdate(scrollTo: points.startingPoint)
            getAddressAndBuildingName(points.startingPoint) { buildingName, detailAddress in
                // 주소와 건물명을 업데이트
                DispatchQueue.main.async {
                    self.stopoverPointMapView.buildingNameLabel.text = buildingName
                    self.stopoverPointMapView.detailAddressLabel.text = detailAddress
                }
            }
        case .destination:
            cameraUpdate = NMFCameraUpdate(scrollTo: points.destination)
            getAddressAndBuildingName(points.destination) { buildingName, detailAddress in
                // 주소와 건물명을 업데이트
                DispatchQueue.main.async {
                    self.stopoverPointMapView.buildingNameLabel.text = buildingName
                    self.stopoverPointMapView.detailAddressLabel.text = detailAddress
                }
            }
        case .stopover1:
            guard let pickupLocation1 = points.pickupLocation1 else { return }
            cameraUpdate = NMFCameraUpdate(scrollTo: pickupLocation1)
            getAddressAndBuildingName(pickupLocation1) { buildingName, detailAddress in
                // 주소와 건물명을 업데이트
                DispatchQueue.main.async {
                    self.stopoverPointMapView.buildingNameLabel.text = buildingName
                    self.stopoverPointMapView.detailAddressLabel.text = detailAddress
                }
            }
        case .stopover2:
            guard let pickupLocation2 = points.pickupLocation2 else { return }
            cameraUpdate = NMFCameraUpdate(scrollTo: pickupLocation2)
            getAddressAndBuildingName(pickupLocation2) { buildingName, detailAddress in
                // 주소와 건물명을 업데이트
                DispatchQueue.main.async {
                    self.stopoverPointMapView.buildingNameLabel.text = buildingName
                    self.stopoverPointMapView.detailAddressLabel.text = detailAddress
                }
            }
        case .stopover3:
            guard let pickupLocation3 = points.pickupLocation3 else { return }
            cameraUpdate = NMFCameraUpdate(scrollTo: pickupLocation3)
            getAddressAndBuildingName(pickupLocation3) { buildingName, detailAddress in
                // 주소와 건물명을 업데이트
                DispatchQueue.main.async {
                    self.stopoverPointMapView.buildingNameLabel.text = buildingName
                    self.stopoverPointMapView.detailAddressLabel.text = detailAddress
                }
            }
        }
        stopoverPointMapView.mapView.moveCamera(cameraUpdate)
    }

    private func mapBoundsForPoints(points: PointLatLng) -> NMGLatLngBounds {
        var latLngs: [NMGLatLng] = []

        latLngs.append(points.startingPoint)
        if let latLng1 = points.pickupLocation1 {
            latLngs.append(latLng1)
        }
        if let latLng2 = points.pickupLocation2 {
            latLngs.append(latLng2)
        }
        if let latLng3 = points.pickupLocation3 {
            latLngs.append(latLng3)
        }
        latLngs.append(points.destination)
        return NMGLatLngBounds(latLngs: latLngs)
    }

    private func fetchDirections() {
        var urlString = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving"
        + "?start=\(points.startingPoint.lng),\(points.startingPoint.lat)"
        + "&goal=\(points.destination.lng),\(points.destination.lat)"
        // 추가만 하고 아직 주소값이 설정되지 않은 경유지는 경로에 표시하지 않음
        if let stopover1 = points.pickupLocation1, isValueSetted[0] == true {
            urlString += "&waypoints=\(stopover1.lng),\(stopover1.lat)"
        }
        if let stopover2 = points.pickupLocation2, isValueSetted[1] == true {
            urlString += "|\(stopover2.lng),\(stopover2.lat)"
        }
        if let stopover3 = points.pickupLocation3, isValueSetted[2] == true {
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
                self.stopoverPointMapView.pathOverlay.path = NMGLineString(points: points)
                DispatchQueue.main.async {
                    self.stopoverPointMapView.pathOverlay.mapView = self.stopoverPointMapView.mapView
                }
            }
        }
        task.resume()
    }

    private func getAddressAndBuildingName(_ latLng: NMGLatLng, completion: @escaping (String, String) -> Void) {
        let urlString = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&"
        + "coords=\(latLng.lng),\(latLng.lat)"
        + "&sourcecrs=epsg:4326&output=json&orders=roadaddr"

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
                print("데이터를 받아오지 못함")
                return
            }
            if let jsonData = responseString.data(using: .utf8),
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let resultsArray = jsonObject["results"] as? [[String: Any]] {

                let parseArray = self.parseAddressData(jsonData: resultsArray)
                completion(parseArray.0, parseArray.1)
            }
        }
        task.resume()
    }

    /**
     Naver API를 통해 받아온 데이터 중 주소와 관련된 데이터만 String으로 가공하여 반환하는 메서드
     기본적으로 튜플 0 에는 전체 상세 주소가 들어가고, 1에는 상세 주소(지곡로 80)이 들어감.
     만약 건물명이 있다면, 1에 건물명이 들어간다.
     */
    private func parseAddressData(jsonData: [[String: Any]]) -> (String, String) {
        var countryName = [String]()
        var detailAddress = [String]()
        var buildingName = ""

        for result in jsonData {
            if let region = result["region"] as? [String: Any] {
                for index in 1...2 {
                    if let area = region["area\(index)"] as? [String: Any],
                       let name = area["name"] as? String {
                        countryName.append(name)
                    }
                }
            }

            if let land = result["land"] as? [String: Any] {
                let addition0 = land["addition0"] as? [String: Any]
                detailAddress.append(land["name"] as? String ?? "")
                detailAddress.append(land["number1"] as? String ?? "")

                if let value = addition0?["value"] as? String {
                    if value != "" {
                        buildingName = value
                    }
                }
            }
        }

        let addressFullname = (countryName + detailAddress).joined(separator: " ")

        if buildingName == "" {
            return (addressFullname, detailAddress.joined(separator: " "))
        } else {
            return (addressFullname, buildingName)
        }
    }
}

// MARK: - Naver Map Delegate Method
extension SelectDetailStopoverPointViewController: NMFMapViewCameraDelegate {

    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let center = mapView.projection.latlng(
            from: CGPoint(
                x: mapView.frame.size.width / 2,
                y: mapView.frame.size.height / 2
            )
        )
        currentLatLng = center
        // 주소와 건물명 가져오기
        getAddressAndBuildingName(center) { detailAddress, buildingName in
            DispatchQueue.main.async {
                // 네이버 지도 API 정확성 부족으로 인한 예외 처리
                if detailAddress == "" || buildingName == "" {
                    self.stopoverPointMapView.buildingNameLabel.text = "위치를 다시 설정해주세요"
                    self.stopoverPointMapView.detailAddressLabel.text = "지도를 옆으로 조금만 옮겨보세요!"
                    self.stopoverPointMapView.saveButton.isEnabled = false
                    self.stopoverPointMapView.saveButton.backgroundColor = UIColor.semantic.backgroundThird
                } else {
                    self.stopoverPointMapView.buildingNameLabel.text = buildingName
                    self.stopoverPointMapView.detailAddressLabel.text = detailAddress
                    self.stopoverPointMapView.saveButton.isEnabled = true
                    self.stopoverPointMapView.saveButton.backgroundColor = UIColor.semantic.accPrimary
                }
            }
        }
    }
}

// MARK: - Previewer
import SwiftUI

struct SDSPControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = SelectDetailStopoverPointViewController

    func makeUIViewController(context: Context) -> SelectDetailStopoverPointViewController {
        return SelectDetailStopoverPointViewController(
            crewData: Crew(
                memberStatus: [MemberStatus]()
            )
        )
    }

    func updateUIViewController(_ uiViewController: SelectDetailStopoverPointViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct SelectedPreview: PreviewProvider {

    static var previews: some View {
        SDSPControllerRepresentable()
    }
}
