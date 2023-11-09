//
//  StopoverSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/8/23.
//

import UIKit

final class StopoverPointSelectViewController: UIViewController {

    private let stopoverPointSelectView = StopoverPointSelectView()
    private var stopoverCount = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        // TODO: 출발지, 도착지 주소 텍스트 설정
        stopoverPointSelectView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
        stopoverPointSelectView.stopoverAddButton.button.addTarget(self, action: #selector(addPointButtonTapped), for: .touchUpInside)
        view.addSubview(stopoverPointSelectView)
        stopoverPointSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension StopoverPointSelectViewController {

    @objc private func addPointButtonTapped() {
        if stopoverCount == 1 {
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.stopover3).offset(30)
                make.leading.equalTo(stopoverPointSelectView).inset(20)
            }
            stopoverPointSelectView.stopover2.label.isHidden = false
            stopoverPointSelectView.stopover2.button.isHidden = false
            stopoverCount += 1
        } else {
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.nextButton.snp.top).offset(-30)
                make.leading.equalTo(stopoverPointSelectView).inset(20)
            }
            stopoverPointSelectView.stopoverAddButton.isHidden = true
            stopoverPointSelectView.stopover3.label.isHidden = false
            stopoverPointSelectView.stopover3.button.isHidden = false
            stopoverCount += 1
        }
    }

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

//        detailViewController.addressSelectionHandler = { [weak self] addressDTO in
//            // TODO: 다음 작업에 Model에 값 적재하는 로직 구현 필요
//
//        }
        present(navigation, animated: true)
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        let viewController = StopoverPointCheckViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct SOPViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = StopoverPointSelectViewController
    func makeUIViewController(context: Context) -> StopoverPointSelectViewController {
        return StopoverPointSelectViewController()
    }
    func updateUIViewController(_ uiViewController: StopoverPointSelectViewController, context: Context) {}
}
