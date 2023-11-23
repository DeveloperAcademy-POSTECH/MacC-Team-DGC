//
//  InquiryViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/01.
//

import MessageUI
import UIKit

final class InquiryViewController: UIViewController {

    private let inquiryView = InquiryView()

    let inquiryContents = ["E-mail", "app store리뷰 남기기"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        navigationController?.navigationBar.topItem?.title = "" // 백버튼 텍스트 제거

        view.addSubview(inquiryView)
        inquiryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        inquiryView.question1Button.addTarget(self, action: #selector(moveToQuestionDetailView), for: .touchUpInside)
        inquiryView.question2Button.addTarget(self, action: #selector(moveToQuestionDetailView), for: .touchUpInside)
        inquiryView.question3Button.addTarget(self, action: #selector(moveToQuestionDetailView), for: .touchUpInside)

        inquiryView.inquiryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        inquiryView.inquiryTableView.dataSource = self
        inquiryView.inquiryTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "문의하기"
    }

    // 자주 묻는 질문 클릭 시 질문 상세 뷰로 이동
    // TODO: - 질문 별로 다른 내용 전달되도록 수정 필요
    @objc private func moveToQuestionDetailView() {
        let questionDetailVC = QuestionDetailViewController()
        navigationController?.pushViewController(questionDetailVC, animated: true)
    }

    // MARK: - 이메일 작성 화면 띄우기
    private func showEmailInquiryView() {
        // 이메일을 사용 가능한 지 체크 (디바이스 내 Mail앱을 이용할 수 있는지)
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self

            compseVC.setToRecipients(["carmu@email.com"])
            compseVC.setSubject("Carmu 문의사항")
            compseVC.setMessageBody("문의하실 내용을 작성해주세요.", isHTML: false)

            self.present(compseVC, animated: true)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    // 이메일 사용 불가 시 알럿
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "이메일 작성 실패", message: "디바이스에 Mail 계정이 연결되어 있는지 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let errorConfirm = UIAlertAction(title: "확인", style: .cancel)
        sendMailErrorAlert.addAction(errorConfirm)
        self.present(sendMailErrorAlert, animated: true)
    }
}

// MARK: - 메일 보내기 관련 델리게이트 구현
extension InquiryViewController: MFMailComposeViewControllerDelegate {

    // 메일 보내기 버튼을 눌렀을 때 호출되는 델리게이트 메서드
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource 델리게이트 구현
extension InquiryViewController: UITableViewDataSource {

    // 각 섹션의 row 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inquiryContents.count
    }

    // 테이블 뷰 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.backgroundColor = UIColor.semantic.backgroundDefault
        cell.textLabel?.textColor = UIColor.semantic.textPrimary

        cell.textLabel?.text = inquiryContents[indexPath.row]
        if indexPath.row == 1 {
            cell.textLabel?.font = UIFont.carmuFont.subhead3
            cell.textLabel?.textColor = UIColor.semantic.accPrimary
        } else {
            cell.textLabel?.font = UIFont.carmuFont.body3
            cell.textLabel?.textColor = UIColor.semantic.textPrimary
        }
        return cell
    }

    // 테이블 뷰 헤더 타이틀 구성
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "1:1 문의하기"
    }

    // 테이블 뷰 섹션 헤더 제목 색상
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor.semantic.textBody
        }
    }
}

// MARK: - UITableViewDelegate 델리게이트 구현
extension InquiryViewController: UITableViewDelegate {

    // 테이블 뷰 셀을 눌렀을 때에 대한 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("이메일 문의하기")
            showEmailInquiryView()
        } else {
            // TODO: - 평점 남기러 가기 구현하기
            print("평점 남기러 가기")
        }
        // 클릭 후에는 셀의 선택이 해제된다.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
