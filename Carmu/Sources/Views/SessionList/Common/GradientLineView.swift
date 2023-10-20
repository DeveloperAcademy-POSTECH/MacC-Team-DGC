//
//  GradientLineView.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/05.
//

import UIKit

final class GradientLineView: UIView {

    private let index: CGFloat
    private let cellCount: CGFloat
    private let cornerRadius: CGFloat

    init(index: CGFloat, cellCount: CGFloat, cornerRadius: CGFloat = 0.0) {
        self.index = index
        self.cellCount = cellCount
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        // 그래디언트 레이어 생성
        let gradientLayer = CAGradientLayer()
        let color = calculateColor(indexPath: index, cellCount: cellCount)

        gradientLayer.frame = rect
        gradientLayer.colors = [UIColor(hex: color[0])?.cgColor as Any, UIColor(hex: color[1])?.cgColor as Any]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = cornerRadius

        // 그래디언트 레이어를 뷰에 추가
        self.layer.addSublayer(gradientLayer)
    }

    private func calculateColor(indexPath: CGFloat, cellCount: CGFloat) -> [String] {
        // 상수 색 RGB 값으로 변경(RGBA 순)
        let startColor: [CGFloat] = [44, 255, 220]
        let endColor: [CGFloat] = [98, 122, 243]

        // 시작 및 끝 색상의 RGB 값을 계산
        var startColorRGB: [CGFloat] = []
        var endColorRGB: [CGFloat] = []

        for index in 0..<3 {
            let distance = endColor[index] - startColor[index]
            let startColorStd = (distance / cellCount * indexPath) + startColor[index]
            let endColorStd = (distance / cellCount * (indexPath + 1)) + startColor[index]
            startColorRGB.append(startColorStd)
            endColorRGB.append(endColorStd)
        }

        // 계산된 RGB 값을 16진수 Hex 코드로 변환
        let startColorHex = UIColor.rgbToHex(
            red: round(startColorRGB[0]) / 255,
            green: round(startColorRGB[1]) / 255,
            blue: round(startColorRGB[2]) / 255
        )
        let endColorHex = UIColor.rgbToHex(
            red: round(endColorRGB[0]) / 255,
            green: round(endColorRGB[1]) / 255,
            blue: round(endColorRGB[2]) / 255
        )

        return [startColorHex, endColorHex]
    }
}
