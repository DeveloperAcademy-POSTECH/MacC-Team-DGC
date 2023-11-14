//
//  StartEndPointSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class StartEndPointSelectViewController: UIViewController {

    private let startEndPointSelectView = StartEndPointSelectView()
    var crewData = Crew(crews: [UserIdentifier](), crewStatus: [CrewStatus]())

    private var startPointAddress: String? {
        didSet {
            startEndPointSelectView.startPointView.button.setTitle(
                "     " + (startPointAddress ?? ""),
                for: .normal
            )
            if endPointAddress != nil {
                startEndPointSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                startEndPointSelectView.nextButton.isEnabled = true
            }
        }
    }
    private var endPointAddress: String? {
        didSet {
            startEndPointSelectView.endPointView.button.setTitle(
                "     " + (endPointAddress ?? ""),
                for: .normal
            )
            if startPointAddress != nil {
                startEndPointSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                startEndPointSelectView.nextButton.isEnabled = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        startEndPointSelectView.startPointView.button.addTarget(
            self,
            action: #selector(findAddressButtonTapped),
            for: .touchUpInside
        )
        startEndPointSelectView.endPointView.button.addTarget(
            self,
            action: #selector(findAddressButtonTapped),
            for: .touchUpInside
        )
        startEndPointSelectView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
        view.addSubview(startEndPointSelectView)
        startEndPointSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension StartEndPointSelectViewController {

    @objc private func findAddressButtonTapped(_ sender: UIButton) {
        let detailViewController = SelectAddressViewController()
        let navigation = UINavigationController(rootViewController: detailViewController)

        detailViewController.addressSelectionHandler = { [weak self] addressDTO in
            var point = Point()
            point.name = addressDTO.pointName
            point.detailAddress = addressDTO.pointDetailAddress
            point.latitude = addressDTO.pointLat
            point.longitude = addressDTO.pointLng

            if sender.titleLabel?.text == "     출발지 검색" {
                self?.startPointAddress = addressDTO.pointName
                self?.crewData.startingPoint = point
            } else {
                self?.endPointAddress = addressDTO.pointName
                self?.crewData.destination = point
            }
        }
        present(navigation, animated: true)
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        let viewController = StopoverPointCheckViewController(crewData: crewData)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct SEPViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = StartEndPointSelectViewController
    func makeUIViewController(context: Context) -> StartEndPointSelectViewController {
        return StartEndPointSelectViewController()
    }
    func updateUIViewController(_ uiViewController: StartEndPointSelectViewController, context: Context) {}
}
