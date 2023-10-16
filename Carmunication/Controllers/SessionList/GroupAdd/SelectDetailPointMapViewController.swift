//
//  SelectDetailPointMapViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/14.
//

import UIKit

import NMapsMap

final class SelectDetailPointMapViewController: UIViewController {

    private let selectDetailPointMapView = SelectDetailPointMapView()
    let selectAddressModel: SelectAddressModel

    init(selectAddressModel: SelectAddressModel) {
        self.selectAddressModel = selectAddressModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(selectDetailPointMapView)

        selectDetailPointMapView.mapView.addCameraDelegate(delegate: self)

        selectDetailPointMapView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)

        selectDetailPointMapView.pointNameLabel.text = selectAddressModel.pointName
        selectDetailPointMapView.buildingNameLabel.text = selectAddressModel.buildingName
        selectDetailPointMapView.detailAddressLabel.text = selectAddressModel.detailAddress
        selectDetailPointMapView.centerMarkerLabel.text = selectAddressModel.pointName

        selectDetailPointMapView.mapView.moveCamera(
            NMFCameraUpdate(
                scrollTo: NMGLatLng(
                    lat: selectAddressModel.coordinate?.latitude ?? 36.66,
                    lng: selectAddressModel.coordinate?.longitude ?? 128.33
                )
            )
        )
        selectDetailPointMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension SelectDetailPointMapViewController {
    @objc private func saveButtonAction() {
        dismiss(animated: true)
    }
}

// MARK: - Custom Method
extension SelectDetailPointMapViewController {

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
extension SelectDetailPointMapViewController: NMFMapViewCameraDelegate {

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
            self.selectDetailPointMapView.buildingNameLabel.text = buildingName
            self.selectDetailPointMapView.detailAddressLabel.text = detailAddress
        }
    }
}

// MARK: - Previewer
import SwiftUI

struct SelectDetailControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = SelectDetailPointMapViewController

    func makeUIViewController(context: Context) -> SelectDetailPointMapViewController {
        return SelectDetailPointMapViewController(selectAddressModel: SelectAddressModel(detailAddress: "우리집"))
    }

    func updateUIViewController(_ uiViewController: SelectDetailPointMapViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct SelectPreview: PreviewProvider {

    static var previews: some View {
        SelectDetailControllerRepresentable()
    }
}
