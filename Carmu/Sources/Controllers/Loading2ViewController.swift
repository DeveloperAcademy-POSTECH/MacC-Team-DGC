//
//  Loading2ViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/20/23.
//

import UIKit

final class Loading2ViewController: UIViewController {

    private let sloganImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launchSlogan")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let gifImage = {
        let image = GifView(gifName: "launchGif")
        image.contentMode = .scaleAspectFit
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)
        view.addSubview(gifImage)
        view.addSubview(sloganImage)

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
}
