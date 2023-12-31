//
//  SelectDetailStopoverPointView.swift
//  Carmu
//
//  Created by 김동현 on 11/10/23.
//

import UIKit

import NMapsMap

final class SelectDetailStopoverPointView: UIView {

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
        backButton.layer.shadowColor = UIColor.theme.black?.cgColor
        backButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        backButton.layer.shadowRadius = 8
        backButton.layer.shadowOpacity = 0.2
        backButton.layer.masksToBounds = false
        return backButton
    }()

    let pathOverlay = {
        let pathOverlay = NMFPath()
        pathOverlay.color = UIColor.theme.blue6 ?? .blue
        pathOverlay.outlineColor = UIColor.theme.blue3 ?? .blue
        return pathOverlay
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

    let startingPoint = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "startingPoint")
        marker.width = 52
        marker.height = 24
        return marker
    }()

    lazy var pickupLocation1 = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "stopover1")
        marker.width = 24
        marker.height = 24
        marker.hidden = true
        return marker
    }()

    lazy var pickupLocation2 = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "stopover2")
        marker.width = 24
        marker.height = 24
        marker.hidden = true
        return marker
    }()

    lazy var pickupLocation3 = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "stopover3")
        marker.width = 24
        marker.height = 24
        marker.hidden = true
        return marker
    }()

    let destination = {
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "destination")
        marker.width = 52
        marker.height = 24
        return marker
    }()

    let saveButton = NextButton(buttonTitle: "경유지로 설정")

    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
extension SelectDetailStopoverPointView {

    private func setupUI() {
        backgroundView.addSubview(buildingNameLabel)
        backgroundView.addSubview(detailAddressLabel)

        addSubview(mapView)
        addSubview(explainLabel)
        addSubview(backButton)
        addSubview(centerMarkerImage)
        addSubview(backgroundView)
        addSubview(saveButton)
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(backgroundView.snp.top).offset(20)
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
            make.width.height.equalTo(60)
        }

        backgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }

        buildingNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        detailAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(buildingNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(36)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.greaterThanOrEqualTo(200)
        }
    }

    func showPoints(points: PointLatLng, isValueSetted: [Bool]) {
        startingPoint.position = NMGLatLng(lat: points.startingPoint.lat, lng: points.startingPoint.lng)
        startingPoint.anchor = CGPoint(x: 0.5, y: 0.5)
        startingPoint.mapView = mapView
        
        // 추가만 하고 아직 주소값이 설정되지 않은 경유지는 마커 표시하지 않음
        if let coordinate = points.pickupLocation1, isValueSetted[0] == true {
            pickupLocation1.hidden = false
            pickupLocation1.position = coordinate
            pickupLocation1.anchor = CGPoint(x: 0.5, y: 0.5)
            pickupLocation1.mapView = mapView
        }

        if let coordinate = points.pickupLocation2, isValueSetted[1] == true {
            pickupLocation2.hidden = false
            pickupLocation2.position = coordinate
            pickupLocation2.anchor = CGPoint(x: 0.5, y: 0.5)
            pickupLocation2.mapView = mapView
        }

        if let coordinate = points.pickupLocation3, isValueSetted[2] == true {
            pickupLocation3.hidden = false
            pickupLocation3.position = coordinate
            pickupLocation3.anchor = CGPoint(x: 0.5, y: 0.5)
            pickupLocation3.mapView = mapView
        }

        destination.position = points.destination
        destination.anchor = CGPoint(x: 0.5, y: 0.5)
        destination.mapView = mapView
    }

    func showExplain() {
        self.explainLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Set isHidden back to true after 1 second
            self.explainLabel.isHidden = true
        }
    }
}

// MARK: - Previewer
import SwiftUI

@available(iOS 13.0.0, *)
struct SelectPointMapPreview: PreviewProvider {

    static var previews: some View {
        SDSPControllerRepresentable()
    }
}
