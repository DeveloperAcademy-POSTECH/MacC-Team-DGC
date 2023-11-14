//
//  LoadingViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/14/23.
//

import UIKit

final class LoadingViewController: UIViewController {

    var loadingView = LoadingView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct LoadingViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = LoadingViewController
    func makeUIViewController(context: Context) -> LoadingViewController {
        return LoadingViewController()
    }
    func updateUIViewController(_ uiViewController: LoadingViewController, context: Context) {}
}
