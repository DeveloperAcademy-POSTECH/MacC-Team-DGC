//
//  CodeShareViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

class CodeShareViewController: UIViewController {

    private let codeShareView = CodeShareView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(codeShareView)
        codeShareView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CodeShareViewController
    func makeUIViewController(context: Context) -> CodeShareViewController {
        return CodeShareViewController()
    }
    func updateUIViewController(_ uiViewController: CodeShareViewController, context: Context) {}
}
