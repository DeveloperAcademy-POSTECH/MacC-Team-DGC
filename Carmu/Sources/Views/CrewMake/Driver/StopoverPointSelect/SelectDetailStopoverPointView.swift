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
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.semantic.backgroundDefault?.cgColor
        view.layer.shadowColor = UIColor.theme.blue6?.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.2

        return view
    }()

    private let centerMarkerImage: UIImageView = {
        let image = UIImage(named: "CenterMarker")
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image

        return imageView
    }()

    let centerMarkerLabel: UILabel = {
        let label = UILabel()
        label.text = "경유지1"
        label.font = UIFont.carmuFont.subhead2
        label.textColor = UIColor.semantic.textPrimary

        return label
    }()

    let pointNameLabel: UILabel = {
        let label = UILabel()
        label.text = "경유지1"
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "의 탑승 위치를 설정해주세요."
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary

        return label
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

    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("상세 위치 설정 완료", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.setBackgroundImage(
            .pixel(ofColor: UIColor.semantic.accPrimary!),
            for: .normal
        )
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.theme.white, for: .normal)

        return button
    }()

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

    private func setupUI() {
        addSubview(mapView)
        addSubview(centerMarkerImage)
        addSubview(centerMarkerLabel)
        addSubview(backgroundView)
        addSubview(pointNameLabel)
        addSubview(titleLabel)
        addSubview(buildingNameLabel)
        addSubview(detailAddressLabel)
        addSubview(saveButton)
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(backgroundView.snp.top)
        }

        centerMarkerImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mapView.snp.centerY).offset(0)
            make.width.height.equalTo(60)
        }

        centerMarkerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(centerMarkerImage.snp.top).inset(13)
        }

        backgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(mapView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(229)
            make.height.greaterThanOrEqualTo(180)
        }

        pointNameLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).inset(20)
            make.leading.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(pointNameLabel.snp.trailing).inset(-4)
            make.centerY.equalTo(pointNameLabel)
        }

        buildingNameLabel.snp.makeConstraints { make in
            make.top.equalTo(pointNameLabel.snp.bottom).offset(12)
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

// MARK: - Previewer
import SwiftUI

@available(iOS 13.0.0, *)
struct SelectPointMapPreview: PreviewProvider {

    static var previews: some View {
        SDSPControllerRepresentable()
    }
}
