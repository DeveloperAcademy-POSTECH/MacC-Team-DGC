//
//  SelectPointMapViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import MapKit
import UIKit

import SnapKit

final class SelectAddressViewController: UIViewController {

    private let selectAddressView = SelectAddressView()

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

        selectAddressView.friendSearchTextField.delegate = self
        selectAddressView.tableViewComponent.delegate = self
        selectAddressView.tableViewComponent.dataSource = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTextField))
        view.addGestureRecognizer(tapGesture)
    }

    // 클래스의 인스턴스가 메모리에서 해제되기 전에 호출되는 메서드
    deinit {
        // 옵저버 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - @objc Method
extension SelectAddressViewController {

    // 상단 닫기 버튼 클릭 시 동작
    @objc private func closeFriendAddView() {
        self.dismiss(animated: true)
    }

    // [검색] 버튼을 눌렀을 때 동작
    @objc private func performFriendSearch() {
        // TODO: - 친구 검색 기능 구현 필요
        print("친구 검색")
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

    @objc private func textFieldDidChange() {
        // 텍스트 필드 내용이 변경될 때마다 호출되는 메서드
        selectAddressView.tableViewComponent.reloadData()
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
        return selectAddressView.friendSearchTextField.hasText ? 10 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if selectAddressView.friendSearchTextField.hasText {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "selectAddressCell",
                for: indexPath
            ) as? SelectAddressTableViewCell {
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: "defaultAddressCell",
                for: indexPath
            ) as? DefaultAddressTableViewCell {
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
