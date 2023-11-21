//
//  Loading2ViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/20/23.
//

import UIKit

final class LaunchScreenViewController: UIViewController {

    var launchScreenView = LaunchScreenView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        view.addSubview(launchScreenView)
        launchScreenView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct Loading2ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = LaunchScreenViewController
    func makeUIViewController(context: Context) -> LaunchScreenViewController {
        return LaunchScreenViewController()
    }
    func updateUIViewController(_ uiViewController: LaunchScreenViewController, context: Context) {}
}
