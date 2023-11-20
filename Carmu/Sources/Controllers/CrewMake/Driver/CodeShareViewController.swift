//
//  CodeShareViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

import SnapKit

final class CodeShareViewController: UIViewController {

    private let codeShareView = CodeShareView()
    var inviteCode: String

    init(inviteCode: String) {
        self.inviteCode = inviteCode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)
        addRightBarButton()

        codeShareView.codeLabel.text = inviteCode
        codeShareView.copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        codeShareView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        view.addSubview(codeShareView)
        codeShareView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private let firebaseManager = FirebaseManager()

//    override func viewDidDisappear(_ animated: Bool) {
//        SceneDelegate.updateIsFirstValue(false)
//        SceneDelegate.isCrewCreated = true
//    }
}

// MARK: - @objc Method
extension CodeShareViewController {

    @objc private func copyButtonTapped() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = inviteCode
        codeShareView.messageLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.codeShareView.messageLabel.isHidden = true
        }
    }

    @objc private func shareButtonTapped() {
        // TODO: - 추후 카카오톡 API 사용하여 메시지 형식 변경 예정
        let message = """
                        카풀을 함께해요!

                        카풀에 초대되었습니다!
                        카뮤 앱을 다운로드 받고, 동승자로 포지션을 설정한 후 아래의 코드를 입력하여 운전자와 카풀을 함께하세요!

                        초대코드 : \(inviteCode)

                        우리 카풀, 오래가자
                        카뮤
                        """

        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.message]
        present(activityViewController, animated: true, completion: nil)
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        if SceneDelegate.isFirst {
            SceneDelegate.updateIsFirstValue(false)
            SceneDelegate.isCrewCreated = true
        } else {
            // 초기 화면이 아닐 경우(건너가기 후 그룹코드 입력)
            navigationController?.popToRootViewController(animated: true)
            navigationController?.viewControllers.first?.viewDidAppear(true)
        }
    }
}

// MARK: - custom Method
extension CodeShareViewController {

    private func addRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor.semantic.accPrimary
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CodeShareViewController
    func makeUIViewController(context: Context) -> CodeShareViewController {
        return CodeShareViewController(inviteCode: "00000000")
    }
    func updateUIViewController(_ uiViewController: CodeShareViewController, context: Context) {}
}
