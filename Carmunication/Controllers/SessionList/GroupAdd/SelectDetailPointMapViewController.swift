//
//  SelectDetailPointMapViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/14.
//

import UIKit

class SelectDetailPointMapViewController: UIViewController {

    private let selectDetailPointMapView = SelectDetailPointMapView()
    var selectAddressModel: SelectAddressModel

    init(selectAddressModel: SelectAddressModel) {
        self.selectAddressModel = selectAddressModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(selectDetailPointMapView)

        selectDetailPointMapView.pointNameLabel.text = selectAddressModel.pointName
        selectDetailPointMapView.buildingNameLabel.text = selectAddressModel.buildingName
        selectDetailPointMapView.detailAddressLabel.text = selectAddressModel.detailAddress
        selectDetailPointMapView.centerMarkerLabel.text = selectAddressModel.pointName

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
        return SelectDetailPointMapViewController(selectAddressModel: SelectAddressModel(detailAddress: "우리집"))
    }

    func updateUIViewController(_ uiViewController: SelectDetailPointMapViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct SelectPreview: PreviewProvider {

    static var previews: some View {
        SelectDetailControllerRepresentable()
    }
}
