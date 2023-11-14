//
//  PointEditView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/13.
//

import UIKit

enum TimeType: String {
    case departure = "출발"
    case arrival = "도착"
}

enum PointType {
    case start
    case stopover1
    case stopover2
    case stopover3
    case end
}

/**
 크루 편집 화면에서 각 경유지의 주소와 시간을 편집할 수 있는 셀 형태의 뷰
 */
final class PointEditView: UIView {

    // MARK: - 경유지 삭제 버튼
    lazy var xButton: UIButton = {
        let xButton = UIButton()
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = UIColor.semantic.stoke
        xButton.isHidden = true // 기본은 숨김
        return xButton
    }()

    // MARK: - 상세주소 설정 버튼
    let addressEditButton = AddressEditButton(originalAddress: "주소1", pointType: .start)

    // MARK: - 시간 타입 라벨 (출발 시간인지 도착 시간인지)
    let timeTypeLabel = TimeTypeLabel(timeType: .departure)

    // MARK: - 시간 설정 버튼
    let timeEditButton = TimeEditButton(originalTime: "00:00 AM", pointType: .start)

    /**
     pointType: 주소, 시간 설정 버튼에서 어떤 장소에 대한 뷰인지를 식별하기 위한 값
     originalAddress: 기존에 설정돼있던 주소의 대표명
     originalArrivalTime: 기존에 설정돼있던 출발 또는 도착 시간
     hasXButton: X버튼 여부 (경유지의 경우 필요함)
     isDeparture: 출발시간인지 도착시간인지
     */
    init(pointType: PointType, originalAddress: String, originalArrivalTime: Date, hasXButton: Bool = false, isDeparture: Bool = true) {
        super.init(frame: .zero)

        // 출발 - 도착 텍스트 구분
        timeTypeLabel.text = isDeparture ? TimeType.departure.rawValue : TimeType.arrival.rawValue

        // TODO: - 시간 텍스트 변환 로직 필요
        addSubview(timeEditButton)
        timeEditButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(84)
            make.height.equalTo(30)
        }

        // TODO: - 출발/도착 구분 로직 필요
        addSubview(timeTypeLabel)
        timeTypeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(timeEditButton.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
        }

        addressEditButton.pointType = pointType
        addressEditButton.setTitle(originalAddress, for: .normal)
        addSubview(addressEditButton)
        addressEditButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(timeTypeLabel.snp.leading).offset(-20)
            make.centerY.equalTo(timeEditButton)
            make.height.equalTo(34)
        }

        if hasXButton {
            xButton.isHidden = false
            addSubview(xButton)
            xButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.bottom.equalTo(timeEditButton.snp.top).offset(-8)
                make.width.height.equalTo(20)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func enableToAdd() {
        let stopoverAddButton = StopoverPointAddButtonView()
        addSubview(stopoverAddButton)
        stopoverAddButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(addressEditButton.snp.bottom).offset(20)
        }
    }
}

// MARK: - 주소 편집 버튼
final class AddressEditButton: UIButton {

    // #selector 메서드에서 어떤 지점의 버튼인지를 식별하기 위한 값 (출발지,경유지,도착지)
    var pointType: PointType?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(originalAddress: String, pointType: PointType) {
        super.init(frame: .zero)
        self.pointType = pointType
        setTitle(originalAddress, for: .normal)
        titleLabel?.font = UIFont.carmuFont.subhead2
        setTitleColor(UIColor.semantic.textTertiary, for: .normal)
        backgroundColor = UIColor.semantic.backgroundDefault
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.semantic.stoke?.cgColor
        contentHorizontalAlignment = .leading
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        configuration = config
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 시간 타입 라벨
final class TimeTypeLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(timeType: TimeType) {
        super.init(frame: .zero)
        text = timeType.rawValue
        font = UIFont.carmuFont.body1
        textColor = UIColor.semantic.textTertiary
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 시간 설정 버튼
final class TimeEditButton: UIButton {

    // #selector 메서드에서 어떤 지점의 버튼인지를 식별하기 위한 값 (출발지,경유지,도착지)
    var pointType: PointType?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(originalTime: String, pointType: PointType) {
        super.init(frame: .zero)
        self.pointType = pointType
        setTitle(originalTime, for: .normal)
        titleLabel?.font = UIFont.carmuFont.subhead3
        setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        backgroundColor = UIColor.semantic.backgroundThird
        layer.cornerRadius = 4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
