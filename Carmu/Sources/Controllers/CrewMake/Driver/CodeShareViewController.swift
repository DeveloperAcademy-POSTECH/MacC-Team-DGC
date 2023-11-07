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
        view.backgroundColor = UIColor.semantic.backgroundDefault
        addRightBarButton()

        codeShareView.codeLabel.text = inviteCode
        codeShareView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )

        view.addSubview(codeShareView)
        codeShareView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension CodeShareViewController {

    @objc private func shareButtonTapped() {
        // TODO: - Activity View 구현 필요
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        if SceneDelegate.isFirst {
            SceneDelegate.updateIsFirstValue(false)
        } else {
            // 초기 화면이 아닐 경우(건너가기 후 그룹코드 입력)
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
