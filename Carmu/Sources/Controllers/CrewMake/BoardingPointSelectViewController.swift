//
//  BoardingPointSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class BoardingPointSelectViewController: UIViewController {

    private let boardingPointSelectView = BoardingPointSelectView()
    private var selectedButton: StopoverSelectButton?
    private var selectedPoint: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        for element in boardingPointSelectView.customTableVieWCell {
            element.addTarget(self, action: #selector(stopoverPointTapped), for: .touchUpInside)
        }
        boardingPointSelectView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        view.addSubview(boardingPointSelectView)
        boardingPointSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}

// MARK: - @objc Method
extension BoardingPointSelectViewController {
    @objc private func stopoverPointTapped(_ sender: StopoverSelectButton) {
        if selectedButton == sender {
            selectedButton?.resetButtonAppearance()
            selectedPoint = nil
            selectedButton = nil
            boardingPointSelectView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
            boardingPointSelectView.nextButton.isEnabled = false
            return
        }
        // 이전에 선택한 버튼을 원래 상태로 복구
        selectedButton?.resetButtonAppearance()

        // 선택한 버튼 업데이트
        selectedButton = sender

        // 선택한 버튼의 색상 변경
        sender.setSelectedButtonAppearance()

        boardingPointSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
        boardingPointSelectView.nextButton.isEnabled = true
        selectedPoint = sender.tag
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct BPSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = BoardingPointSelectViewController
    func makeUIViewController(context: Context) -> BoardingPointSelectViewController {
        return BoardingPointSelectViewController()
    }
    func updateUIViewController(_ uiViewController: BoardingPointSelectViewController, context: Context) {}
}
