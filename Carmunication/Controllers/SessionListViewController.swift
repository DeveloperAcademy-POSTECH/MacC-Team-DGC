//
//  SessionListViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

final class SessionListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Preview canvas 세팅
import SwiftUI

struct SessionListViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SessionListViewController
    func makeUIViewController(context: Context) -> SessionListViewController {
        return SessionListViewController()
    }
    func updateUIViewController(_ uiViewController: SessionListViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct SecondViewPreview: PreviewProvider {
    static var previews: some View {
        SessionListViewControllerRepresentable()
    }
}
