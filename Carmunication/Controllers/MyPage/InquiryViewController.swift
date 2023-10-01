//
//  InquiryViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/01.
//

import UIKit

final class InquiryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "문의하기"
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct InquiryViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = InquiryViewController
    func makeUIViewController(context: Context) -> InquiryViewController {
        return InquiryViewController()
    }
    func updateUIViewController(_ uiViewController: InquiryViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct InquiryViewPreview: PreviewProvider {
    static var previews: some View {
        InquiryViewControllerRepresentable()
    }
}
