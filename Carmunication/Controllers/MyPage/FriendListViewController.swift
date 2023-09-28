//
//  FriendListViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

final class FriendListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "친구관리"
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FriendListViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FriendListViewController
    func makeUIViewController(context: Context) -> FriendListViewController {
        return FriendListViewController()
    }
    func updateUIViewController(_ uiViewController: FriendListViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct FriendListViewPreview: PreviewProvider {
    static var previews: some View {
        FriendListViewControllerRepresentable()
    }
}
