//
//  FinalConfirmViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class FinalConfirmViewController: UIViewController {

    private let finalConfirmView = FinalConfirmView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        finalConfirmView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )

        view.addSubview(finalConfirmView)
        finalConfirmView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension FinalConfirmViewController {

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        let viewController = CodeShareViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FCViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FinalConfirmViewController
    func makeUIViewController(context: Context) -> FinalConfirmViewController {
        return FinalConfirmViewController()
    }
    func updateUIViewController(_ uiViewController: FinalConfirmViewController, context: Context) {}
}
