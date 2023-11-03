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

    // enum 타입의 ProfileType 값을 받아서 대응하는 [일반 프로필 이미지]로 초기화해주는 이니셜라이저
    convenience init?(profileType: ProfileType) {
        let imageName = "profile" + profileType.rawValue.capitalizedFirstCharacter()
        self.init(named: imageName)
    }

    // enum 타입의 ProfileType 값을 받아서 대응하는 [선택된 프로필 이미지]로 초기화해주는 이니셜라이저
    convenience init?(selectedProfileType: ProfileType) {
        let selectedName = "selectedProfile" + selectedProfileType.rawValue.capitalizedFirstCharacter()
        self.init(named: selectedName)
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
