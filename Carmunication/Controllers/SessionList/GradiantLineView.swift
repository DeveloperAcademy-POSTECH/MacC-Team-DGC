//
//  GradiantLineView.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/05.
//

import UIKit

class GradientLineView: UIView {

    var index: CGFloat
    var cellCount: CGFloat

    init(index: CGFloat, cellCount: CGFloat) {
        self.index = index
        self.cellCount = cellCount
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // 그래디언트 레이어 생성
        let gradientLayer = CAGradientLayer()
        let color = calculateColor(indexPath: index, cellCount: cellCount)
        print("hexcode로 변환한 시작 color : ", color[0])
        print("hexcode로 변환한 끝 color : ", color[1])

        gradientLayer.frame = rect
        gradientLayer.colors = [UIColor(hex: color[0])?.cgColor, UIColor(hex: color[1])?.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        print("index : ", index)
        print("startPoint y : ", gradientLayer.startPoint)
        print("endPoint y : ", gradientLayer.endPoint)
        // 실선을 그릴 베지어 패스 생성
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))

        // 실선 스타일 설정
        path.lineWidth = 2.0
        let dashes: [CGFloat] = [4, 4]
        path.setLineDash(dashes, count: dashes.count, phase: 0)

        // 그래디언트 레이어에 실선 패스를 마스크로 적용
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shapeLayer

        // 그래디언트 레이어를 뷰에 추가
        self.layer.addSublayer(gradientLayer)
    }

    //    private func calculateColor(_ indexPath: CGFloat, _ cellCount: CGFloat, _ isEnd: Bool = false) -> String {
    //
    //        // 그래디언트 시작 색상 및 끝 색상 설정
    //        let constantStartColor = UIColor.semantic.accSecondary
    //        let constantEndColor = UIColor.semantic.accPrimary
    //
    //        // UIColor 객체의 CGColor 가져오기
    //        guard let startCGColor = constantStartColor?.cgColor,
    //              let endCGColor = constantEndColor?.cgColor else {
    //            return ""
    //        }
    //
    //        // CGColor 객체로부터 RGB 값을 추출
    //        let startComponents = startCGColor.components
    //        let endComponents = endCGColor.components
    //
    //        // RGB 값 계산
    //        let startRed = (startComponents?[0] ?? 0 + endComponents?[0] ?? 0) * 1 / cellCount * indexPath
    //        let startGreen = (startComponents?[1] ?? 0 + endComponents?[1] ?? 0) * 1 / cellCount * indexPath
    //        let startBlue = (startComponents?[2] ?? 0 + endComponents?[2] ?? 0) * 1 / cellCount * (isEnd ? indexPath + 1 : indexPath)
    //        // 나머지 값들도 위와 같은 방식으로 계산
    //
    //        // 계산된 RGB 값을 Hex 코드로 변환
    //        let startColorHex = rgbToHex(red: startRed, green: startGreen, blue: startBlue)
    //
    //        return startColorHex
    //    }

    private func calculateColor(indexPath: CGFloat, cellCount: CGFloat) -> [String] {

        // 상수 색 RGB 값으로 변경(RGBA 순)
        var startColor: [CGFloat] = [44, 255, 220]
        var endColor: [CGFloat] = [98, 122, 243]

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

        print("startColorRGB 값: ", startColorRGB)
        print("endColorRGB 값: ",endColorRGB)
        // 계산된 RGB 값을 16진수 Hex 코드로 변환
        let startColorHex = rgbToHex(red: round(startColorRGB[0]) / 255, green: round(startColorRGB[1]) / 255, blue: round(startColorRGB[2]) / 255)
        let endColorHex = rgbToHex(red: round(endColorRGB[0]) / 255, green: round(endColorRGB[1]) / 255, blue: round(endColorRGB[2]) / 255)

        return [startColorHex, endColorHex]
    }

    // RGB 값을 16진수 Hex 코드로 변환하는 함수
    func rgbToHex(red: CGFloat, green: CGFloat, blue: CGFloat) -> String {
        let redInt = Int(red * 255)
        let greenInt = Int(green * 255)
        let blueInt = Int(blue * 255)
        return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
    }
}
