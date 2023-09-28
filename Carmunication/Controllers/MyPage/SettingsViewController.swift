//
//  SettingsViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

final class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // 테이블 뷰 섹션과 row의 데이터
    let sections = ["친구 관리", "기타"]
    let friendManagementOptions = ["친구 관리"]
    let otherOptions = ["개인정보 처리방침", "문의하기", "로그아웃", "회원 탈퇴"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "설정"

        // 테이블 뷰 생성
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    // 섹션 수 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    // 각 섹션의 row 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return friendManagementOptions.count
        } else {
            return otherOptions.count
        }
    }
    // 각 row에 대한 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

        if indexPath.section == 0 {
            cell.textLabel?.text = friendManagementOptions[indexPath.row]
        } else {
            cell.textLabel?.text = otherOptions[indexPath.row]
        }

        return cell
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct SettingsViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SettingsViewController
    func makeUIViewController(context: Context) -> SettingsViewController {
        return SettingsViewController()
    }
    func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct SettingsViewPreview: PreviewProvider {
    static var previews: some View {
        SettingsViewControllerRepresentable()
    }
}
