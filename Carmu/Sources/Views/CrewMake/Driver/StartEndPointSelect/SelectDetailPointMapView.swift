//
//  SelectDetailPointMapView.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/14.
//

import UIKit

import NMapsMap

final class SelectDetailPointMapView: UIView {

    let mapView = NMFMapView()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    let backButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "modalXButton"), for: .normal)
        return backButton
    }()

    private let explainLabel: UILabel = {
        let label = UILabel()
        label.text = "정확한 경유 위치를 설정해주세요."
        label.textAlignment = .center
        label.font = UIFont.carmuFont.subhead2
        label.textColor = UIColor.semantic.textSecondary
        label.backgroundColor = UIColor.theme.trans60
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

    private let centerMarkerImage: UIImageView = {
        let image = UIImage(named: "centerMarker")
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image

        return imageView
    }()

    let buildingNameLabel: UILabel = {
        let label = UILabel()
        label.text = "주소지의 건물명"
        label.font = UIFont.carmuFont.body3
        label.textColor = UIColor.semantic.textPrimary

        return label
    }()

    let detailAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "경북 포항시 북구 지곡로 80"
        label.font = UIFont.carmuFont.body2
        label.textColor = UIColor.semantic.textBody

        return label
    }()

    let saveButton = NextButton(buttonTitle: "상세위치 설정")

    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
    }
}

// MARK: - Setup UI
extension SelectDetailPointMapView {

    private func setupUI() {
        backgroundView.addSubview(buildingNameLabel)
        backgroundView.addSubview(detailAddressLabel)

        addSubview(mapView)
        addSubview(backButton)
        addSubview(explainLabel)
        addSubview(centerMarkerImage)
        addSubview(backgroundView)
        addSubview(saveButton)
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(backgroundView.snp.top).offset(10)
        }

        explainLabel.snp.makeConstraints { make in
            make.bottom.equalTo(centerMarkerImage.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(223)
            make.height.equalTo(30)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(36)
        }

        centerMarkerImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mapView.snp.centerY).offset(0)
            make.width.height.equalTo(30)
        }

        backgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }

        buildingNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.greaterThanOrEqualTo(200)
        }

        detailAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(buildingNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.greaterThanOrEqualTo(200)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(36)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.greaterThanOrEqualTo(200)
            make.height.equalTo(60)
        }
    }
}

// custom Method
extension SelectDetailPointMapView {

    func showExplain() {
        self.explainLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Set isHidden back to true after 1 second
            self.explainLabel.isHidden = true
        }
    }
}

// MARK: - Previewer
import SwiftUI

@available(iOS 13.0.0, *)
struct SelectDetailPointMapViewPreview: PreviewProvider {

    static var previews: some View {
        SelectDetailControllerRepresentable()
    }
}
