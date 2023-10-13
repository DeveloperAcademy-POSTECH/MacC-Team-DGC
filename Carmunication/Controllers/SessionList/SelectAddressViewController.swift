//
//  SelectPointMapViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import MapKit
import UIKit

import SnapKit

/**
 searchCompleter: MKLocalSearchCompleter // 검색을 도와주는 변수
 searchRegion: MKCoordinateRegion // 검색 지역 범위를 결정하는 변수
 completerResults: [MKLocalSearchCompletion] // 검색한 결과를 담는 변수
 places: MKMapItem // tableView에서 선택한 Location의 정보를 담는 변수
 localSearch: MKLocalSearch? // tableView에서 선택한 Location의 정보를 가져오는 변수
 */
final class SelectAddressViewController: UIViewController {

    private let selectAddressView = SelectAddressView()

    private var searchCompleter: MKLocalSearchCompleter?
    private var completerResults: [MKLocalSearchCompletion]?

    private var places: MKMapItem? {
        didSet {
            selectAddressView.tableViewComponent.reloadData()
        }
    }

    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(selectAddressView)
        selectAddressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectAddressView.closeButton.addTarget(
            self,
            action: #selector(closeFriendAddView),
            for: .touchUpInside
        )
        selectAddressView.friendSearchButton.addTarget(
            self,
            action: #selector(performFriendSearch),
            for: .touchUpInside
        )
        selectAddressView.clearButton.addTarget(
            self,
            action: #selector(clearButtonPressed),
            for: .touchUpInside
        )
        selectAddressView.friendSearchTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )

        let koreaCoordinate = CLLocationCoordinate2D(latitude: 36.34, longitude: 127.77)
        let koreaBounds = MKCoordinateRegion(center: koreaCoordinate, latitudinalMeters: 200000, longitudinalMeters: 200000)

        searchCompleter = MKLocalSearchCompleter()
//        selectAddressView.searchBar.becomeFirstResponder()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .query
        searchCompleter?.region = koreaBounds

        selectAddressView.searchBar.delegate = self
        selectAddressView.friendSearchTextField.delegate = self
        selectAddressView.tableViewComponent.delegate = self
        selectAddressView.tableViewComponent.dataSource = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchCompleter = nil
    }
}

// MARK: - @objc Method
extension SelectAddressViewController {

    // 상단 닫기 버튼 클릭 시 동작
    @objc private func closeFriendAddView() {
        self.dismiss(animated: true)
    }

    // [검색] 버튼을 눌렀을 때 동작
    @objc private func performFriendSearch(_ textField: UITextField) {
        // TODO: - 친구 검색 기능 구현 필요
        print("친구 검색")
        if let searchText = textField.text {
            performDetailedSearch(for: searchText)
        }
    }

    // 텍스트필드 clear 버튼 눌렀을 때 동작
    @objc private func clearButtonPressed() {
        selectAddressView.friendSearchTextField.text = nil
        selectAddressView.tableViewComponent.reloadData()
    }

    // 텍스트 필드 비활성화 시 동작
    @objc private func dismissTextField() {
        selectAddressView.friendSearchTextFieldView.backgroundColor = .clear
        selectAddressView.friendSearchTextFieldView.layer.borderWidth = 1.0
        selectAddressView.friendSearchTextField.resignFirstResponder() // 최초 응답자 해제
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        // 텍스트 필드 내용이 변경될 때마다 호출되는 메서드
        if let searchText = textField.text {
            if searchText == "" {
                completerResults?.removeAll()
                selectAddressView.tableViewComponent.reloadData()
            }
            searchCompleter?.queryFragment = searchText
            selectAddressView.tableViewComponent.reloadData()
        }
    }

    func performDetailedSearch(for searchText: String) {
        // searchText를 사용하여 원하는 검색 작업 수행
        // 예를 들어, MKLocalSearch를 사용하여 위치 검색을 수행할 수 있습니다.
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText

        // 검색 요청 제출
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (response, error) in
            if let error = error {
                print("Error performing search: \(error.localizedDescription)")
            } else if let response = response {
                // 검색 결과를 response에서 처리
                if let firstMapItem = response.mapItems.first {
                    // 첫 번째 결과 항목을 사용하여 상세 정보 표시 또는 원하는 동작 수행
                    print("검색 결과: \(firstMapItem.name ?? "알 수 없음")")
                } else {
                    print("검색 결과 없음")
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate Method
extension SelectAddressViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            completerResults?.removeAll()
            selectAddressView.tableViewComponent.reloadData()
        }

        searchCompleter?.queryFragment = searchText
        selectAddressView.tableViewComponent.reloadData()
    }
}

// MARK: - MKLocalSearchCompleterDelegate Method
extension SelectAddressViewController: MKLocalSearchCompleterDelegate {
    // 자동완성 완료시 결과를 받는 method
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        completerResults = completer.results
        selectAddressView.tableViewComponent.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print(
"""
MKLocalSearchCompleter encountered an error: \(error.localizedDescription).\n
The query fragment is: \"\(completer.queryFragment)\"
"""
            )
        }
    }
}

// MARK: - UITextFieldDelegate Method
extension SelectAddressViewController: UITextFieldDelegate {

    // 텍스트 필드의 편집이 시작될 때 호출되는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {

        selectAddressView.friendSearchTextFieldView.backgroundColor = UIColor.semantic.backgroundSecond
        selectAddressView.friendSearchTextFieldView.layer.borderWidth = 0
        selectAddressView.tableViewComponent.reloadData()
    }

    // 리턴 키를 눌렀을 때 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissTextField()
        selectAddressView.tableViewComponent.reloadData()
        return true
    }
}

// MARK: - TableView Delegate Method
extension SelectAddressViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Tableview DataSource Method
extension SelectAddressViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if selectAddressView.friendSearchTextField.hasText {
//            return completerResults?.count ?? 0
//        } else {
//            return 1
//        }
        return completerResults?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        if selectAddressView.searchBar. {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "selectAddressCell"
            ) as? SelectAddressTableViewCell else {
                return UITableViewCell()
            }

            if let suggestion = completerResults?[indexPath.row] {
                cell.buildingNameLabel.text = suggestion.title
                cell.detailAddressLabel.text = suggestion.subtitle
            }
            return cell

//        } else {
//            if let cell = tableView.dequeueReusableCell(
//                withIdentifier: "defaultAddressCell",
//                for: indexPath
//            ) as? DefaultAddressTableViewCell {
//                return cell
//            }
//        }
//        return UITableViewCell()
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
