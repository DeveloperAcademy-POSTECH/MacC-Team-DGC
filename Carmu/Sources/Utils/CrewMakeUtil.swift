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
            make.width.height.equalTo(greenLineView)
        }
        return colorLineView
    }
}
