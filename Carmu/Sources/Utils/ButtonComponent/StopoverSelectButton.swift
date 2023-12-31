//
//  StopoverSelectButton.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

/**
 경유지 설정 화면에서 선택하는 버튼.
 */
final class StopoverSelectButton: UIButton {

    let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.headline1

        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.body1

        return label
    }()

    let detailTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.semantic.textPrimary
        label.font = UIFont.carmuFont.subhead3

        return label
    }()

    // 버튼 컴포넌트의 기본 높이를 54로 지정
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 54)
    }

    /**
     address: 출발지의 대표명
     isStart: 도착지라면 false(기본값 true)
     time: 출발 또는 도착 시간
     */
    init(address: String, _ isStart: Bool = true, time: Date) {
        super.init(frame: .zero)

        addressLabel.text = address
        timeLabel.text = isStart ? "출발" : "도착"
        detailTimeLabel.text = Date.formattedDate(from: time, dateFormat: "aa hh:mm")

        addSubview(addressLabel)
        addSubview(timeLabel)
        addSubview(detailTimeLabel)

        backgroundColor = UIColor.semantic.backgroundDefault
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.theme.blue6?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2

        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(150)
        }

        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(detailTimeLabel.snp.leading).offset(-5)
        }

        detailTimeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 버튼을 탭할 시 외형 변경에 필요한 메서드
extension StopoverSelectButton {
    // 선택한 버튼의 외관을 변경
    func setSelectedButtonAppearance() {
        backgroundColor = UIColor.theme.blue6
        addressLabel.textColor = UIColor.semantic.textSecondary
        timeLabel.textColor = UIColor.semantic.textSecondary
        detailTimeLabel.textColor = UIColor.semantic.textSecondary
    }

    // 선택한 버튼의 외관을 복구
    func resetButtonAppearance() {
        backgroundColor = UIColor.semantic.backgroundDefault
        addressLabel.textColor = UIColor.semantic.textPrimary
        timeLabel.textColor = UIColor.semantic.textPrimary
        detailTimeLabel.textColor = UIColor.semantic.textPrimary
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct BoringPointSelectViewPreview: PreviewProvider {
    static var previews: some View {
        BPSViewControllerRepresentable()
    }
}
