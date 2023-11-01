//
//  InviteCodeInputViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

final class InviteCodeInputViewController: UIViewController {

    private let inviteCodeInputView = InviteCodeInputView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        view.addSubview(inviteCodeInputView)
        inviteCodeInputView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        inviteCodeInputView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }
}

extension InviteCodeInputViewController {
    // @objc Method
    @objc private func nextButtonTapped() {
        // TODO: 코드 유효성 텍스트 라벨 표시 로직 추가 필요
        inviteCodeInputView.conformCodeLabel.isHidden = false
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct ICIViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = InviteCodeInputViewController
    func makeUIViewController(context: Context) -> InviteCodeInputViewController {
        return InviteCodeInputViewController()
    }
    func updateUIViewController(_ uiViewController: InviteCodeInputViewController, context: Context) {}
}
