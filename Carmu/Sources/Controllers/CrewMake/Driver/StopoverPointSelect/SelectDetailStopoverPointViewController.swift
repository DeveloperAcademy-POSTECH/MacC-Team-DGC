//
//  SelectDetailStopoverPointView.swift
//  Carmu
//
//  Created by 김동현 on 11/10/23.
//

import UIKit

import NMapsMap

/**
 개발용 임시 Point 모델
 */
struct Point1 {
    let startingPoint = NMGLatLng(lat: 36.01759520, lng: 129.32206275)
    let pickupLocation1: NMGLatLng? = nil
    let pickupLocation2: NMGLatLng? = nil
    let pickupLocation3: NMGLatLng? = nil
    let destination = NMGLatLng(lat: 36.0108783, lng: 129.327818)
}

final class SelectDetailStopoverPointViewController: UIViewController {

    private let stopoverPointMapView = SelectDetailStopoverPointView()
    var addressSelectionHandler: ((AddressDTO) -> Void)?
    private let points = Point1()
    private var addressDTO = AddressDTO()

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
        getAddressAndBuildingName(
            for: NMGLatLng(
                lat: calculateCenter(points: points, isLng: false),
                lng: calculateCenter(points: points)
            )
        ) { buildingName, detailAddress in
            // 주소와 건물명을 업데이트
            self.stopoverPointMapView.buildingNameLabel.text = buildingName
            self.stopoverPointMapView.detailAddressLabel.text = detailAddress
        }
    }

    /**
     출발, 도착, 경유지를 한 화면에 표시할 수 있는 영역을 보이도록 CameraUpdate 하는 메서드
     */
    private func mapBoundSetting() {
        let bounds = mapBoundsForPoints(points: Point1())
        let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 50)
        stopoverPointMapView.mapView.moveCamera(cameraUpdate)
    }

    private func mapBoundsForPoints(points: Point1) -> NMGLatLngBounds {
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

    /**
     중간 지점의 좌표를 반환하는 메서드
        (기본값 : 경도 반환
        isLng = false : 위도 반환)
     */
    private func calculateCenter(points: Point1, isLng: Bool = true) -> Double {
        if isLng {
            return (points.startingPoint.lng + points.destination.lng) / 2
        } else {
            return (points.startingPoint.lat + points.destination.lat) / 2
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
        return SelectDetailStopoverPointViewController()
    }

    func updateUIViewController(_ uiViewController: SelectDetailStopoverPointViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct SelectedPreview: PreviewProvider {

    static var previews: some View {
        SDSPControllerRepresentable()
    }
}
