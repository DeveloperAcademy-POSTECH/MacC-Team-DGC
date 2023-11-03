//
//  TimeSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class TimeSelectViewController: UIViewController {


    private let timeSelectView = TimeSelectView()

    // TODO: 추후 시간 입력 여부와 값 업데이트를 위한 프로퍼티
    private var startPointTime: Date? {
        didSet {
            if endPointTime != nil {
                timeSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                timeSelectView.nextButton.isEnabled = true
            }
        }
    }
    private var endPointTime: Date? {
        didSet {
            if startPointTime != nil {
                timeSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                timeSelectView.nextButton.isEnabled = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        timeSelectView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
        view.addSubview(timeSelectView)
        timeSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension TimeSelectViewController {

    @objc private func findAddressButtonTapped(_ sender: UIButton) {

    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct TSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = TimeSelectViewController
    func makeUIViewController(context: Context) -> TimeSelectViewController {
        return TimeSelectViewController()
    }
    func updateUIViewController(_ uiViewController: TimeSelectViewController, context: Context) {}
}
