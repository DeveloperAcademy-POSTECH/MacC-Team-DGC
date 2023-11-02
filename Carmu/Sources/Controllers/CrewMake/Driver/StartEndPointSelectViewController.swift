//
//  StartEndPointSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class StartEndPointSelectViewController: UIViewController {

    private let startEndPointSelectView = StartEndPointSelectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(startEndPointSelectView)
        startEndPointSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
