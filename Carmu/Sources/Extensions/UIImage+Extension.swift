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

    // enum 타입의 ProfileImageColor 값을 받아서 대응하는 [일반 프로필 이미지]로 초기화해주는 이니셜라이저
    convenience init?(profileImageColor: ProfileImageColor) {
        let imageName = "profile" + profileImageColor.rawValue.capitalized()
        self.init(named: imageName)
    }

    // enum 타입의 ProfileImageColor 값을 받아서 대응하는 [선택된 프로필 이미지]로 초기화해주는 이니셜라이저
    convenience init?(selectedProfileImageColor: ProfileImageColor) {
        let selectedName = "selectedProfile" + selectedProfileImageColor.rawValue.capitalized()
        self.init(named: selectedName)
    }

    // enum 타입의 ProfileImageColor 값을 받아서 대응하는 [마이페이지에서 보여줄 프로필 이미지]로 초기화해주는 이니셜라이저
    convenience init?(myPageImageColor: ProfileImageColor) {
        let selectedName = "myPageProfile" + myPageImageColor.rawValue.capitalized()
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

// MARK: - gif 파일 사용을 위한 extension
extension UIImage {

    static func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        return UIImage.gifImageWithData(imageData)
    }

    static func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var gifDuration = 0.0

        for index in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
                let durationSeconds = UIImage.getFrameDuration(from: source, at: index)
                gifDuration += durationSeconds
                images.append(UIImage(cgImage: cgImage))
            }
        }

        let gifImage = UIImage.animatedImage(with: images, duration: gifDuration)
        return gifImage
    }

    static func getFrameDuration(from source: CGImageSource, at index: Int) -> Double {
        var frameDuration = 0.1
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any] else {
            return frameDuration
        }

        if let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
            if let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                frameDuration = delayTime
            } else {
                frameDuration = 0.1
            }
        }
        return frameDuration
    }
}
