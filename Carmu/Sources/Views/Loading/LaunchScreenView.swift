//
//  Loading2View.swift
//  Carmu
//
//  Created by 김동현 on 11/20/23.
//

import UIKit

final class LaunchScreenView: UIView {

    private let sloganImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launchSlogan")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let gifImage = GifView(gifName: "launchGif")

    init() {
        super.init(frame: .zero)
        addSubview(gifImage)
        addSubview(sloganImage)

        gifImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(54)
        }
        sloganImage.snp.makeConstraints { make in
            make.centerX.equalTo(gifImage)
            make.bottom.equalTo(gifImage.snp.top).offset(-22)
            make.width.equalTo(154)
            make.height.equalTo(30)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct Loading2ViewPreview: PreviewProvider {
    static var previews: some View {
        Loading2ViewControllerRepresentable()
    }
}
