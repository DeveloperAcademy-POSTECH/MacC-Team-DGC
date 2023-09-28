//
//  SettingsViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//

import FirebaseAuth
import UIKit

final class SettingsViewController: UIViewController {

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

    func showSignOutAlert() {
        let signOutAlert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        let signOutCancel = UIAlertAction(title: "취소", style: .cancel)
        let signOutOK = UIAlertAction(title: "확인", style: .destructive) { _ in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                if let window = UIApplication.shared.windows.first {
                    // 최초 화면으로 돌아가기
                    window.rootViewController = LoginViewController()
                    window.makeKeyAndVisible()
                }
            } catch let signOutError as NSError {
                print("로그아웃 에러: \(signOutError)")
            }
        }
        signOutAlert.addAction(signOutCancel)
        signOutAlert.addAction(signOutOK)
        self.present(signOutAlert, animated: false)
    }
}

// MARK: - 테이블 뷰 관련 델리게이트 메소드
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
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
    // 테이블 뷰 셀을 눌렀을 때에 대한 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 로그아웃 버튼 눌렀을 때
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                showSignOutAlert()
            }
        }
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
