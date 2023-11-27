//
//  SelectPointMapViewController.swift
//  Carmu
//
//  Created by 김동현 on 2023/09/24.
//

import MapKit
import UIKit

import SnapKit

final class SelectAddressViewController: UIViewController {

    let selectAddressView = SelectAddressView()
    private var isKeyboardActive = false
    var addressSelectionHandler: ((AddressDTO) -> Void)?
    var addressDTO: AddressDTO?

    private var searchCompleter: MKLocalSearchCompleter?
    private var completerResults: [MKLocalSearchCompletion]?
    private var places: MKMapItem? {
        didSet {
            selectAddressView.tableViewComponent.reloadData()
        }
    }
    private var localSearch: MKLocalSearch? {
        willSet {
            places = nil
            localSearch?.cancel()
        }
    }
    private let koreaBounds = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.34, longitude: 127.77),
        latitudinalMeters: 200000,
        longitudinalMeters: 200000
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        view.addSubview(selectAddressView)

        selectAddressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectAddressView.closeButton.addTarget(self, action: #selector(closeAddressView), for: .touchUpInside)
        selectAddressView.clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        selectAddressView.addressSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        selectAddressView.addressSearchTextField.delegate = self
        selectAddressView.tableViewComponent.delegate = self
        selectAddressView.tableViewComponent.dataSource = self

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .query
        searchCompleter?.region = koreaBounds

        // 뷰가 나타남과 동시에 텍스트 필드 on
        selectAddressView.addressSearchTextField.becomeFirstResponder()
        isKeyboardActive = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchCompleter = nil
        dismissTextField()
    }

    deinit {
        if let addressDTO = addressDTO { addressSelectionHandler?(addressDTO) }
    }
}

// MARK: - @objc Method
extension SelectAddressViewController {

    // 상단 닫기 버튼 클릭 시 동작
    @objc private func closeAddressView() {
        dismiss(animated: true)
    }

    // 텍스트필드 clear 버튼 눌렀을 때 동작
    @objc private func clearButtonPressed() {
        selectAddressView.addressSearchTextField.text = nil
        completerResults = nil
        selectAddressView.tableViewComponent.reloadData()
    }

    @objc private func dismissTextField() {
        if !isKeyboardActive {
            selectAddressView.addressSearchTextFieldView.backgroundColor = .clear
            selectAddressView.addressSearchTextFieldView.layer.borderWidth = 1.0
            selectAddressView.addressSearchTextField.resignFirstResponder()
            selectAddressView.tableViewComponent.reloadData()
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let searchText = textField.text {
            if searchText.isEmpty {
                completerResults?.removeAll()
                selectAddressView.tableViewComponent.reloadData()
            }
            searchCompleter?.queryFragment = searchText
            selectAddressView.tableViewComponent.reloadData()
        }
    }

    @objc private func keyboardWillChange(notification: Notification) { }
}

// MARK: - Custom Method
extension SelectAddressViewController {

    private func search(for suggestedCompletion: MKLocalSearchCompletion, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        searchRequest.region = koreaBounds
        searchRequest.resultTypes = .pointOfInterest

        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { (response, error) in
            guard error == nil else {
                // Handle the error if needed
                completion(nil)
                return
            }

            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                // Return the coordinate via the completion handler
                completion(coordinate)
            } else {
                // Handle the case when no coordinate is found
                completion(nil)
            }
        }
    }

    private func search(using searchRequest: MKLocalSearch.Request) -> CLLocationCoordinate2D {
        // 검색 지역 설정
        searchRequest.region = self.koreaBounds

        // 검색 유형 설정
        searchRequest.resultTypes = .pointOfInterest
        // MKLocalSearch 생성
        localSearch = MKLocalSearch(request: searchRequest)
        // 비동기로 검색 실행
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                return
            }
            // 검색한 결과 : reponse의 mapItems 값을 가져온다.
            self.places = response?.mapItems[0]
        }
        return places?.placemark.coordinate ?? CLLocationCoordinate2D()
    }

    private func getCoordinates(for address: String, completion: @escaping (Result<(Double, Double), Error>) -> Void) {
        guard !address.isEmpty else { return }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                // 검색 결과에서 위도와 경도를 비동기적으로 반환
                completion(.success((latitude, longitude)))
            } else {
                let noLocationError = NSError(
                    domain: "GeocodingError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "No location found for the address"]
                )
                completion(.failure(noLocationError))
            }
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate Method
extension SelectAddressViewController: MKLocalSearchCompleterDelegate {

    // 자동완성 완료시 결과를 받는 method
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completerResults = completer.results
        self.selectAddressView.tableViewComponent.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("Error: \(error.localizedDescription).\n The query: \"\(completer.queryFragment)")
        }
    }
}

// MARK: - UITextFieldDelegate Method
extension SelectAddressViewController: UITextFieldDelegate {

    // 텍스트 필드의 편집이 시작될 때 호출되는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isKeyboardActive = true
        selectAddressView.clearButton.isHidden = false
        selectAddressView.tableViewComponent.reloadData()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        isKeyboardActive = false
        selectAddressView.clearButton.isHidden = true
        dismissTextField()
    }

    // 리턴 키를 눌렀을 때 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        selectAddressView.tableViewComponent.reloadData()
        selectAddressView.addressSearchTextField.resignFirstResponder()
        return true
    }
}

// MARK: - TableView Delegate Method
extension SelectAddressViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let results = completerResults, !results.isEmpty {
            // 검색 결과가 있는 경우
            if indexPath.row % 2 == 0 {
                // 짝수 번째 행일 때 (SelectAddressTableViewCell)
                return 79
            } else {
                // 홀수 번째 행일 때 (UITableViewCell)
                return 10
            }
        } else {
            // 검색 결과가 없는 경우
            return 79
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isKeyboardActive {
            // 키보드가 열려있을 경우 키보드를 닫음
            dismissTextField()
            isKeyboardActive = false
        }

        // tableView의 선택 상태를 해제
        tableView.deselectRow(at: indexPath, animated: true)

        if let selectedSuggestion = completerResults?[indexPath.row] {
            // Extract information from the selected cell
            let title = selectedSuggestion.title
            let subtitle = String.removeCountryAndPostalCode(from: selectedSuggestion.subtitle)
            guard let text = selectAddressView.headerTitleLabel.text else { return }
            let pointName = text.components(separatedBy: " ").first

            // Search for the coordinates using the selected suggestion
            search(for: selectedSuggestion) { [weak self] coordinate in
                guard let self = self else { return }
                if let coordinate = coordinate {
                    let selectAddressModel = SelectAddressDTO(
                        pointName: pointName,
                        buildingName: title,
                        detailAddress: subtitle,
                        coordinate: coordinate
                    )

                    let detailViewController = SelectDetailPointMapViewController()
                    detailViewController.selectAddressModel = selectAddressModel

                    detailViewController.addressSelectionHandler = { [weak self] addressDTO in
                        self?.addressDTO = addressDTO
                    }

                    if selectAddressView.headerTitleLabel.text == "출발지 주소 설정" {
                        detailViewController
                            .selectDetailPointMapView
                            .saveButton
                            .setTitle("출발지로 설정", for: .normal)
                    } else {
                        detailViewController
                            .selectDetailPointMapView
                            .saveButton
                            .setTitle("도착지로 설정", for: .normal)
                    }

                    self.navigationController?.pushViewController(detailViewController, animated: true)
                }
            }
        }
    }
}

// MARK: - Tableview DataSource Method
extension SelectAddressViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = completerResults, !results.isEmpty else {
            return 1
        }
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let results = completerResults, !results.isEmpty {
            // 검색 결과가 있는 경우
            if indexPath.row % 2 == 0 {
                // 짝수 번째 행일 때 (SelectAddressTableViewCell)
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "selectAddressCell"
                ) as? SelectAddressTableViewCell else {
                    return UITableViewCell()
                }

                if let suggestion = completerResults?[indexPath.row] {
                    cell.buildingNameLabel.text = suggestion.title
                    cell.detailAddressLabel.text = String.removeCountryAndPostalCode(from: suggestion.subtitle)
                }
                return cell
            } else {
                // 홀수 번째 행일 때 (UITableViewCell)
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "blankCell",
                    for: indexPath
                )
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
                return cell
            }
        } else {
            // 검색 결과가 없는 경우
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "defaultAddressCell",
                for: indexPath
            ) as? DefaultAddressTableViewCell {
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - Previewer
import SwiftUI

struct SelectAddressViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = SelectAddressViewController

    func makeUIViewController(context: Context) -> SelectAddressViewController {
        return SelectAddressViewController()
    }

    func updateUIViewController(_ uiViewController: SelectAddressViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct SelectAddressViewControllerPreview: PreviewProvider {

    static var previews: some View {
        SelectAddressViewControllerRepresentable()
    }
}
