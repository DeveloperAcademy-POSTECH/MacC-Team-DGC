//
//  SelectDetailPointMapViewController.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/14.
//

import UIKit

import NMapsMap

final class SelectDetailPointMapViewController: UIViewController {

    let selectDetailPointMapView = SelectDetailPointMapView()
    private let loadingView = LoadingView()
    var selectAddressModel = SelectAddressDTO()
    var addressSelectionHandler: ((AddressDTO) -> Void)?
    private var addressDTO = AddressDTO()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        view.addSubview(selectDetailPointMapView)
        selectDetailPointMapView.mapView.addCameraDelegate(delegate: self)
        selectDetailPointMapView.mapView.zoomLevel = 17
        selectDetailPointMapView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        selectDetailPointMapView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        selectDetailPointMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingView.showLoadingView(showInterval: 1.5)
    }

    override func viewDidAppear(_ animated: Bool) {
        selectDetailPointMapView.mapView.moveCamera(
            NMFCameraUpdate(
                scrollTo: NMGLatLng(
                    lat: selectAddressModel.coordinate?.latitude ?? 36.66,
                    lng: selectAddressModel.coordinate?.longitude ?? 128.33
                )
            )
        )
        selectDetailPointMapView.buildingNameLabel.text = selectAddressModel.buildingName
        selectDetailPointMapView.detailAddressLabel.text = selectAddressModel.detailAddress
        selectDetailPointMapView.showExplain()
    }
}

// MARK: - @objc Method
extension SelectDetailPointMapViewController {

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveButtonAction() {
        self.addressDTO.pointName = selectAddressModel.buildingName
        self.addressDTO.pointDetailAddress = selectAddressModel.detailAddress
        self.addressDTO.pointLat = selectAddressModel.coordinate?.latitude
        self.addressDTO.pointLng = selectAddressModel.coordinate?.longitude
        addressSelectionHandler?(addressDTO)
        dismiss(animated: true)
    }
}

// MARK: - Custom Method
extension SelectDetailPointMapViewController {

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
extension SelectDetailPointMapViewController: NMFMapViewCameraDelegate {

    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let center = mapView.projection.latlng(
            from: CGPoint(
                x: mapView.frame.size.width / 2,
                y: mapView.frame.size.height / 2
            )
        )

        getAddressAndBuildingName(center) { detailAddress, buildingName in
            DispatchQueue.main.async {
                // 네이버 지도 API 정확성 부족으로 인한 예외 처리
                if detailAddress == "" || buildingName == "" {
                    self.selectDetailPointMapView.buildingNameLabel.text = "위치를 다시 설정해주세요"
                    self.selectDetailPointMapView.detailAddressLabel.text = "지도를 옆으로 조금만 옮겨보세요!"
                    self.selectDetailPointMapView.saveButton.isEnabled = false
                    self.selectDetailPointMapView.saveButton.backgroundColor = UIColor.semantic.backgroundThird
                } else {
                    self.selectDetailPointMapView.buildingNameLabel.text = buildingName
                    self.selectDetailPointMapView.detailAddressLabel.text = detailAddress
                    self.selectAddressModel.buildingName = buildingName
                    self.selectAddressModel.detailAddress = detailAddress
                    self.selectAddressModel.coordinate?.latitude = center.lat
                    self.selectAddressModel.coordinate?.longitude = center.lng
                    self.selectDetailPointMapView.saveButton.isEnabled = true
                    self.selectDetailPointMapView.saveButton.backgroundColor = UIColor.semantic.accPrimary
                }
            }
        }
    }
}

// MARK: - Previewer
import SwiftUI

struct SelectDetailControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = SelectDetailPointMapViewController

    func makeUIViewController(context: Context) -> SelectDetailPointMapViewController {
        return SelectDetailPointMapViewController()
    }

    func updateUIViewController(_ uiViewController: SelectDetailPointMapViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct SelectPreview: PreviewProvider {

    static var previews: some View {
        SelectDetailControllerRepresentable()
    }
}
