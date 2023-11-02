//
//  TitleUtil.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

/**
 주요 화면 상단에 표시되는 타이틀 텍스트의 Util
 */
final class CrewMakeUtil {
    /**
     textPrimary색 제목
     */
    static func defalutTitle(titleText: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.carmuFont.headline2
        titleLabel.textColor = UIColor.semantic.textPrimary
        return titleLabel
    }

    /**
     accPrimary색 제목
     */
    static func accPrimaryTitle(titleText: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.carmuFont.headline2
        titleLabel.textColor = UIColor.semantic.accPrimary
        return titleLabel
    }

    /**
     장소 선택 시 나오는 컬러 라인을 리턴하는 함수
     상단이 옥색, 하단이 보라색이다.
     */
    static func createColorLineView() -> UIView {
        let colorLineView = UIView()
        let greenLineView = UIView()
        let purpleLineView = UIView()

        colorLineView.backgroundColor = UIColor.semantic.backgroundThird
        greenLineView.backgroundColor = UIColor.semantic.accSecondary
        purpleLineView.backgroundColor = UIColor.semantic.accPrimary

        colorLineView.layer.cornerRadius = 8
        greenLineView.layer.cornerRadius = 8
        purpleLineView.layer.cornerRadius = 8

        colorLineView.addSubview(greenLineView)
        colorLineView.addSubview(purpleLineView)

        greenLineView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(54)
        }

        purpleLineView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(54)
        }
        return colorLineView
    }

    static func stopoverPointSelectButton(address: String, _ isStartTime: Bool = true, time: Date) -> UIButton {
        let button = UIButton()
        let addressLabel = UILabel()
        let timeLabel = UILabel()
        let detailTimeLabel = UILabel()

        addressLabel.text = address
        timeLabel.text = isStartTime ? "출발" : "도착"
        detailTimeLabel.text = Date.formattedDate(from: time, dateFormat: "aa hh:mm")

        button.backgroundColor = UIColor.semantic.backgroundDefault
        addressLabel.textColor = UIColor.semantic.textPrimary
        timeLabel.textColor = UIColor.semantic.textPrimary
        detailTimeLabel.textColor = UIColor.semantic.textPrimary
        addressLabel.font = UIFont.carmuFont.headline1
        timeLabel.font = UIFont.carmuFont.body1
        detailTimeLabel.font = UIFont.carmuFont.subhead3

        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.theme.blue6?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.2

        button.addSubview(addressLabel)
        button.addSubview(timeLabel)
        button.addSubview(detailTimeLabel)

        button.snp.makeConstraints { make in
            make.height.equalTo(54)
        }

        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.greaterThanOrEqualTo(timeLabel.snp.leading).offset(-30)
            make.width.equalTo(140)
        }

        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(detailTimeLabel.snp.leading).offset(-5)
            make.width.equalTo(22)
        }

        detailTimeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(74)
        }

        return button
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
