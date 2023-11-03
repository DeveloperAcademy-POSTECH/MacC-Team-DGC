//
//  RepeatDaySelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class RepeatDaySelectViewController: UIViewController {

    private let repeatDaySelectView = RepeatDaySelectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(repeatDaySelectView)
        repeatDaySelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct RDSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RepeatDaySelectViewController
    func makeUIViewController(context: Context) -> RepeatDaySelectViewController {
        return RepeatDaySelectViewController()
    }
    func updateUIViewController(_ uiViewController: RepeatDaySelectViewController, context: Context) {}
}
