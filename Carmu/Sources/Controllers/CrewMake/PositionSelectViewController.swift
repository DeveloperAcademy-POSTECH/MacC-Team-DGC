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
        view.addSubview(positionSelectView)
        positionSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct PositionSelectViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PositionSelectViewController
    func makeUIViewController(context: Context) -> PositionSelectViewController {
        return PositionSelectViewController()
    }
    func updateUIViewController(_ uiViewController: PositionSelectViewController, context: Context) {}
}
