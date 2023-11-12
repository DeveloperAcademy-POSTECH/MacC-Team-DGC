//
//  PositionSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

final class PositionSelectViewController: UIViewController {

    private let positionSelectView = PositionSelectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        positionSelectView.selectDriverButton.addTarget(
            self,
            action: #selector(driverButtonTapped),
            for: .touchUpInside
        )
        positionSelectView.selectCrewButton.addTarget(
            self,
            action: #selector(crewButtonTapped),
            for: .touchUpInside
        )
        positionSelectView.skipButton.addTarget(
            self,
            action: #selector(skipButtonTapped),
            for: .touchUpInside
        )
        view.addSubview(positionSelectView)
        positionSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension PositionSelectViewController {

    @objc private func driverButtonTapped() {
        let viewController = StartEndPointSelectViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func crewButtonTapped() {
        let viewController = InviteCodeInputViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func skipButtonTapped() {
        SceneDelegate.updateIsFirstValue(false)
        UserDefaults.standard.set(false, forKey: "isFirst")
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct PSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PositionSelectViewController
    func makeUIViewController(context: Context) -> PositionSelectViewController {
        return PositionSelectViewController()
    }
    func updateUIViewController(_ uiViewController: PositionSelectViewController, context: Context) {}
}
