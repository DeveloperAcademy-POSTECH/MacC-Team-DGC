//
//  CustomListTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//
import SnapKit
import UIKit

// MARK: - Preview canvas 세팅
import SwiftUI

struct CustomListTableViewCellRepresentable: UIViewControllerRepresentable {

    // Create a UIViewController that contains your UITableViewCell
    class UIViewControllerType: UIViewController {
        let tableViewCell = CustomListTableViewCell() // Initialize your custom cell
        override func viewDidLoad() {
            super.viewDidLoad()
            tableViewCell.titleLabel.text = "타이틀"
            view.addSubview(tableViewCell)
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            tableViewCell.frame = view.bounds
        }
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        return UIViewControllerType()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

@available(iOS 13.0.0, *)
struct CustomListTableViewCellPreview: PreviewProvider {

    static var previews: some View {
        CustomListTableViewCellRepresentable()
            .previewLayout(.fixed(width: 320, height: 134)) // Set an appropriate size
    }
}
