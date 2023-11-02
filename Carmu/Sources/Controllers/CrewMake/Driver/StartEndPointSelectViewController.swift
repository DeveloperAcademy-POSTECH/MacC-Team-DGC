//
//  StartEndPointSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class StartEndPointSelectViewController: UIViewController {

    private let startEndPointSelectView = StartEndPointSelectView()

    private var startPointAddress: String? {
        didSet {
            startEndPointSelectView.startPointButton.setTitle(
                "     " + (startPointAddress ?? ""),
                for: .normal
            )
            if let endPointAddress {
                startEndPointSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                startEndPointSelectView.nextButton.isEnabled = true
            }
        }
    }
    private var endPointAddress: String? {
        didSet {
            startEndPointSelectView.endPointButton.setTitle(
                "     " + (startPointAddress ?? ""),
                for: .normal
            )
            if let startPointAddress {
                startEndPointSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                startEndPointSelectView.nextButton.isEnabled = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        startEndPointSelectView.startPointButton.addTarget(
            self,
            action: #selector(findAddressButtonTapped),
            for: .touchUpInside
        )
        startEndPointSelectView.endPointButton.addTarget(
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

        detailViewController.selectAddressView.headerTitleLabel.text = {
            if sender.titleLabel?.text == "     출발지 검색" {
                return "출발지 주소 설정"
            } else {
                return "도착지 주소 설정"
            }
        }()

        detailViewController.addressSelectionHandler = { [weak self] addressDTO in
            if sender.titleLabel?.text == "     출발지 검색" {
                self?.startPointAddress = addressDTO.pointName
            } else {
                self?.endPointAddress = addressDTO.pointName
            }
            // TODO: 다음 작업에 Model에 값 적재하는 로직 구현 필요
        }
        present(navigation, animated: true)
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
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
