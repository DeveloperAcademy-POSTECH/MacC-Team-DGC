//
//  GroupAddViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

struct AddressAndTime {
    var address: String = "포항시 남구 지곡로 80"
    var time: String = "09:30"
}

final class GroupAddViewController: UIViewController {

    private var cellData: [AddressAndTime] = [
        AddressAndTime(address: "C5", time: "08:30"),
        AddressAndTime(address: "가속기", time: "09:30"),
        AddressAndTime(address: "울산", time: "10:30"),
        AddressAndTime(address: "서울", time: "14:30")
    ]

    private let groupAddView = GroupAddView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        navigationBarSetting()
        groupAddView.tableViewComponent.dataSource = self
        groupAddView.tableViewComponent.delegate = self

        groupAddView.stopoverPointAddButton.addTarget(self, action: #selector(addStopoverPoint), for: .touchUpInside)

        view.addSubview(groupAddView)

        groupAddView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - tableView protocol Method
extension GroupAddViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GroupAddTableViewCell {
            return cell

        } else {
            // 셀을 생성하는 데 실패한 경우, 기본 UITableViewCell을 반환.
            return UITableViewCell()
        }
    }
    /**
     셀 선택 시 화면 전환 로직 구현
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detailViewController = SelectPointMapViewController()
        detailViewController.title = "장소 선택"
        detailViewController.modalPresentationStyle = .fullScreen

        present(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Component
extension GroupAddViewController {

    private func navigationBarSetting() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationController?.navigationBar.tintColor = UIColor.semantic.accPrimary
        navigationItem.leftBarButtonItem = backButton
    }

    /**
     backButton을 누를 때 적용되는 액션 메서드
     */
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - @objc Method
extension GroupAddViewController {

    /**
     버튼이 눌린 section을 식별하거나 다른 작업 수행
     */
    @objc private func buttonTapped(_ sender: UIButton) {

        let section = sender.tag
        cellData.remove(at: section)
        groupAddView.tableViewComponent.reloadData()
    }

    @objc private func addStopoverPoint() {

        cellData.insert(AddressAndTime(address: "새로 들어온 데이터", time: "12:30"), at: cellData.count - 1)
        groupAddView.tableViewComponent.reloadData()
    }
}

// MARK: - Previewer
import SwiftUI

struct GroupAddViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = GroupAddViewController

    func makeUIViewController(context: Context) -> GroupAddViewController {
        return GroupAddViewController()
    }

    func updateUIViewController(_ uiViewController: GroupAddViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct GroupAddViewControllerPreview: PreviewProvider {

    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }

}
