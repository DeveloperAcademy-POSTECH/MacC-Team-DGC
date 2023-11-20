//
//  GifView.swift
//  Carmu
//
//  Created by 김동현 on 11/20/23.
//

import UIKit

class GifView: UIView {

    private let gifName: String

    init(gifName: String) {
        self.gifName = gifName
        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let gif = UIImage.gifImageWithName(gifName)

        let imageView = UIImageView(image: gif)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
    }
}
