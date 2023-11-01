//
//  UIImage+Extension.swift
//  Carmu
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

/// UIImage 사이즈 조정을 위한 함수입니다.
/// ex. UIImage(named: "myPageButton").resizedImage(targetSize: CGSize(width: 48, height: 48))
extension UIImage {
    func resizedImage(targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
