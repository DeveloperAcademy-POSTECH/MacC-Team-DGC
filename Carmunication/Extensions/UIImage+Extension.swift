//
//  UIImage+Extension.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/03.
//
import UIKit

extension UIImage {

    public static func pixel(ofColor color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(pixel.size)

        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        context.setFillColor(color.cgColor)
        context.fill(pixel)

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

extension UIImage {
    // 이미지 비율 유지하면서 사이즈를 줄여주는 메소드
    func aspectFit(toSize newSize: CGSize) -> UIImage {
        let widthRatio = newSize.width / size.width
        let heightRatio = newSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)

        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()

        return scaledImage ?? self
    }
}
