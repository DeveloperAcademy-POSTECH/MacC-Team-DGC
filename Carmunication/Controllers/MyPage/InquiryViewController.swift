//
//  InquiryViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/01.
//

import UIKit

final class InquiryViewController: UIViewController {

    private let inquiryView = InquiryView()

    let inquiryContents = ["평점 남기러 가기", "이메일로 문의하기"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "문의하기"
        view.addSubview(inquiryView)
        inquiryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        inquiryView.inquiryTableView.dataSource = self
        inquiryView.inquiryTableView.delegate = self
    }
}

extension InquiryViewController: UITableViewDataSource, UITableViewDelegate {

    // 각 섹션의 row 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inquiryContents.count
    }
    // 테이블 뷰 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

        cell.textLabel?.text = inquiryContents[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    // 테이블 뷰 셀을 눌렀을 때에 대한 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // TODO: - 평점 남기러 가기 구현하기
            print("평점 남기러 가기")
        } else {
            // TODO: - 이메일로 문의하기 구현하기 (MFMailComposeViewController 사용)
            print("이메일로 문의하기")
        }
        // 클릭 후에는 셀의 선택이 해제된다.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
