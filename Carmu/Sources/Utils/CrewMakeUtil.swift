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
     공통 그래디언트 배경색
     */
    static func backGroundLayer(_ view: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.semantic.backgroundDefault?.cgColor as Any,
            UIColor.semantic.backgroundSecond?.cgColor as Any
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return gradientLayer
    }
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
     원하는 색상과 폰트가 적용된 UILabel 반환
     */
    static func carmuCustomLabel(text: String, font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        return label
    }

    /**
     장소 선택 시 나오는 컬러 라인을 리턴하는 함수
     상단이 옥색, 하단이 보라색이다.
     */
    static func createColorLineView(_ colorStickHeight: CGFloat = 54) -> UIView {
        let colorLineView = UIView()
        let greenLineView = UIView()
        let purpleLineView = UIView()
        let whiteCircle1 = UIView()
        let whiteCircle2 = UIView()

        colorLineView.backgroundColor = UIColor.semantic.backgroundThird
        greenLineView.backgroundColor = UIColor.semantic.accSecondary
        purpleLineView.backgroundColor = UIColor.semantic.accPrimary
        whiteCircle1.backgroundColor = UIColor.semantic.backgroundDefault
        whiteCircle2.backgroundColor = UIColor.semantic.backgroundDefault

        colorLineView.layer.cornerRadius = 6
        greenLineView.layer.cornerRadius = 6
        purpleLineView.layer.cornerRadius = 6
        whiteCircle1.layer.cornerRadius = 3
        whiteCircle2.layer.cornerRadius = 3

        colorLineView.addSubview(greenLineView)
        colorLineView.addSubview(purpleLineView)
        colorLineView.addSubview(whiteCircle1)
        colorLineView.addSubview(whiteCircle2)

        greenLineView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(colorStickHeight)
        }

        purpleLineView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.width.height.equalTo(greenLineView)
        }

        whiteCircle1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(3)
            make.width.height.equalTo(6)
        }

        whiteCircle2.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(3)
            make.width.height.equalTo(whiteCircle1)
        }

        return colorLineView
    }
}
