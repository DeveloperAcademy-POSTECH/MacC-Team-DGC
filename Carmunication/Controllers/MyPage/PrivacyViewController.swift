//
//  PrivacyViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/01.
//

import UIKit

final class PrivacyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "개인정보 처리방침"
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct PrivacyViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PrivacyViewController
    func makeUIViewController(context: Context) -> PrivacyViewController {
        return PrivacyViewController()
    }
    func updateUIViewController(_ uiViewController: PrivacyViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct PrivacyViewPreview: PreviewProvider {
    static var previews: some View {
        PrivacyViewControllerRepresentable()
    }
}
