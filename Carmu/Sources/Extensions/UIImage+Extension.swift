//
//  UIImage+Extension.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/03.
//
import UIKit

extension UIImage {

    convenience init(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }

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
