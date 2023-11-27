//
//  StopoverPointCheckViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class StopoverPointCheckViewController: UIViewController {

    private let stopoverPointCheckView = StopoverPointCheckView()
    var crewData: Crew

    init(crewData: Crew) {
        self.crewData = crewData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        stopoverPointCheckView.yesStopoverButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        stopoverPointCheckView.noStopoverButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)

        view.addSubview(stopoverPointCheckView)
        stopoverPointCheckView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension StopoverPointCheckViewController {

    @objc private func yesButtonTapped() {
        let viewController = StopoverPointSelectViewController(crewData: crewData)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func noButtonTapped() {
        let viewController = TimeSelectViewController(crewData: crewData)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct SPCViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = StopoverPointCheckViewController
    func makeUIViewController(context: Context) -> StopoverPointCheckViewController {
        return StopoverPointCheckViewController(
            crewData: Crew(
                memberStatus: [MemberStatus]()
            )
        )
    }
    func updateUIViewController(_ uiViewController: StopoverPointCheckViewController, context: Context) {}
}
