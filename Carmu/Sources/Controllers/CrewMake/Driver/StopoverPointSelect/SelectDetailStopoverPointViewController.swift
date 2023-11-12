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

    private let stopoverPointMapView = SelectDetailStopoverPointView()
    var addressSelectionHandler: ((AddressDTO) -> Void)?
    private var points: PointLatLng
    private var addressDTO = AddressDTO()
    private var currentLatLng: NMGLatLng?

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
        }
        if crewData.stopover2 != nil {
            self.points.pickupLocation2 = NMGLatLng(
                lat: crewData.stopover2?.latitude ?? 37.234,
                lng: crewData.stopover2?.longitude ?? 132.232
            )
        }
        if crewData.stopover3 != nil {
            self.points.pickupLocation3 = NMGLatLng(
                lat: crewData.stopover3?.latitude ?? 37.234,
                lng: crewData.stopover3?.longitude ?? 132.232
            )
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(stopoverPointMapView)
        stopoverPointMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        navigationSetting()
        stopoverPointMapView.mapView.addCameraDelegate(delegate: self)
        stopoverPointMapView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        stopoverPointMapView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        mapBoundSetting()
        stopoverPointMapView.showExplain()
    }
}

// MARK: - @objc Method
extension SelectDetailStopoverPointViewController {

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonAction() {
        // TODO: 데이터 전달 구현
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
        stopoverPointMapView.showPoints(points: points)
        fetchDirections()
    }

    /**
     출발, 도착, 경유지를 한 화면에 표시할 수 있는 영역을 보이도록 CameraUpdate 하는 메서드
     */
    private func mapBoundSetting() {
        let bounds = mapBoundsForPoints(points: points)
        print("bounds: ", bounds)
        let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 50)
        stopoverPointMapView.mapView.moveCamera(cameraUpdate)
        currentLatLng = bounds.center

        getAddressAndBuildingName(
            for: bounds.center
        ) { buildingName, detailAddress in
            // 주소와 건물명을 업데이트
            self.stopoverPointMapView.buildingNameLabel.text = buildingName
            self.stopoverPointMapView.detailAddressLabel.text = detailAddress
        }
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
        print("latLngs: ", latLngs)
        return NMGLatLngBounds(latLngs: latLngs)
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
                self.stopoverPointMapView.pathOverlay.path = NMGLineString(points: points)
                DispatchQueue.main.async {
                    self.stopoverPointMapView.pathOverlay.mapView = self.stopoverPointMapView.mapView
                }
            }
        }
        task.resume()
    }

    private func getAddressAndBuildingName(
        for coordinate: NMGLatLng,
        completion: @escaping (String?, String?) -> Void
    ) {
        let geocoder = CLGeocoder()
        let location = CLLocation(
            latitude: coordinate.lat,
            longitude: coordinate.lng
        )

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "")")
                completion(nil, nil)
                return
            }

            if let placemark = placemarks?.first {
                var placemarkDsc = placemark.description.components(separatedBy: ", ")
                if placemarkDsc[0] == placemarkDsc[1] {
                    placemarkDsc.remove(at: 0)
                }
                let buildingName = placemark.areasOfInterest?[0] ?? placemark.name ?? ""
                let detailAddress = self.filterDetailAddress(placemarkDsc[1])

                completion(buildingName, detailAddress)
            } else {
                completion(nil, nil)
            }
        }
    }

    // 상세주소 필터링
    private func filterDetailAddress(_ words: String) -> String {
        if let firstPart = words.split(separator: "@").first {
            return String(firstPart).replacingOccurrences(of: "대한민국 ", with: "")
        }
        return ""
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
        getAddressAndBuildingName(for: center) { buildingName, detailAddress in
            // 주소와 건물명을 업데이트
            self.stopoverPointMapView.buildingNameLabel.text = buildingName
            self.stopoverPointMapView.detailAddressLabel.text = detailAddress
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
                crews: [UserIdentifier](),
                crewStatus: [UserIdentifier: Status]()
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
