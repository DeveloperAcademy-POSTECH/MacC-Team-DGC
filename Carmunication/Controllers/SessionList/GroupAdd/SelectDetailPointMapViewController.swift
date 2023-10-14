//
//  SelectDetailPointMapViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/14.
//

import UIKit

class SelectDetailPointMapViewController: UIViewController {

    private let selectDetailPointMapView = SelectDetailPointMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(selectDetailPointMapView)

        selectDetailPointMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Previewer
import SwiftUI

struct SelectDetailControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = SelectDetailPointMapViewController

    func makeUIViewController(context: Context) -> SelectDetailPointMapViewController {
        return SelectDetailPointMapViewController()
    }

    func updateUIViewController(_ uiViewController: SelectDetailPointMapViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct SelectPreview: PreviewProvider {

    static var previews: some View {
        SelectDetailControllerRepresentable()
    }
}
