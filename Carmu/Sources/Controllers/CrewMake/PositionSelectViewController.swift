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
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

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

    // 현재 화면에서만 네비게이션 바 숨김을 위한 처리
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - @objc Method
extension PositionSelectViewController {

    @objc private func driverButtonTapped() {
        let viewController = CrewNameSettingViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func crewButtonTapped() {
        let viewController = InviteCodeInputViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func skipButtonTapped() {
        let alertController = UIAlertController(
            title: "설정이 되지 않았어요!",
            message: "셔틀을 만들거나 합류해야\n카뮤를 이용할 수 있습니다.",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
        let skipAction = UIAlertAction(title: "건너뛰기", style: .default) { _ in
            SceneDelegate.updateIsFirstValue(false)
            UserDefaults.standard.set(false, forKey: "isFirst")
        }

        alertController.addAction(cancelAction)
        alertController.addAction(skipAction)

        present(alertController, animated: true, completion: nil)
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
