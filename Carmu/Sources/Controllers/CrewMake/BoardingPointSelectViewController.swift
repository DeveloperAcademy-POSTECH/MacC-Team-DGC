//
//  BoardingPointSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class BoardingPointSelectViewController: UIViewController {

    private let boardingPointSelectView = BoardingPointSelectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(boardingPointSelectView)
        boardingPointSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
