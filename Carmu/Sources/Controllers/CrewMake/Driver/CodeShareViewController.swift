//
//  CodeShareViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class CodeShareViewController: UIViewController {

    private let codeShareView = CodeShareView()
    var inviteCode: String

    init(inviteCode: String) {
        self.inviteCode = inviteCode
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - @objc Method
extension CodeShareViewController {

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        if SceneDelegate.isFirst {
            SceneDelegate.updateIsFirstValue(false)
        } else {
            // 초기 화면이 아닐 경우(건너가기 후 그룹코드 입력)
        }
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
