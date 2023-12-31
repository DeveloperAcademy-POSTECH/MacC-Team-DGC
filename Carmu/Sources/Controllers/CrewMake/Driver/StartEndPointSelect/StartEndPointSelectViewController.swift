//
//  StartEndPointSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class StartEndPointSelectViewController: UIViewController {

    private let startEndPointSelectView = StartEndPointSelectView()
    var crewData = Crew(memberStatus: [MemberStatus]())

    private var startPointAddress: String? {
        didSet {
            startEndPointSelectView.startPointView.button.setTitle("     " + (startPointAddress ?? ""), for: .normal)
            if endPointAddress != nil {
                startEndPointSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                startEndPointSelectView.nextButton.isEnabled = true
            }
        }
    }
    private var endPointAddress: String? {
        didSet {
            startEndPointSelectView.endPointView.button.setTitle("     " + (endPointAddress ?? ""), for: .normal)
            if startPointAddress != nil {
                startEndPointSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                startEndPointSelectView.nextButton.isEnabled = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

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

        startEndPointSelectView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
        startEndPointSelectView.nextButton.isEnabled = false

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
        if sender == startEndPointSelectView.startPointView.button {
            detailViewController.selectAddressView.headerTitleLabel.text = "출발지 주소 설정"

        } else {
            detailViewController.selectAddressView.headerTitleLabel.text = "도착지 주소 설정"
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.semantic.textPrimary as Any,
                .font: UIFont.carmuFont.body2Long
            ]
            detailViewController.selectAddressView.addressSearchTextField.attributedPlaceholder = NSAttributedString(
                string: "도착지 검색",
                attributes: placeholderAttributes
            )
        }
        navigation.navigationBar.isHidden = true

        detailViewController.addressSelectionHandler = { [weak self] addressDTO in
            var point = Point()
            point.name = addressDTO.pointName
            point.detailAddress = addressDTO.pointDetailAddress
            point.latitude = addressDTO.pointLat
            point.longitude = addressDTO.pointLng

            if sender == self?.startEndPointSelectView.startPointView.button {
                self?.startPointAddress = addressDTO.pointName
                self?.startEndPointSelectView.startPointView.button.setTitleColor(UIColor.semantic.textTertiary, for: .normal)
                self?.startEndPointSelectView.startPointView.button.titleLabel?.font = UIFont.carmuFont.subhead2
                self?.crewData.startingPoint = point
            } else {
                self?.endPointAddress = addressDTO.pointName
                self?.startEndPointSelectView.endPointView.button.setTitleColor(UIColor.semantic.textTertiary, for: .normal)
                self?.startEndPointSelectView.endPointView.button.titleLabel?.font = UIFont.carmuFont.subhead2
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
