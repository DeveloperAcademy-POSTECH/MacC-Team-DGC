//
//  StopoverPointCheckViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class StopoverPointCheckViewController: UIViewController {

    private let stopoverPointCheckView = StopoverPointCheckView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        view.addSubview(stopoverPointCheckView)
        stopoverPointCheckView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct SPCViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = StopoverPointCheckViewController
    func makeUIViewController(context: Context) -> StopoverPointCheckViewController {
        return StopoverPointCheckViewController()
    }
    func updateUIViewController(_ uiViewController: StopoverPointCheckViewController, context: Context) {}
}
