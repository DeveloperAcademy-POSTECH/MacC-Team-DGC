//
//  SessionFinishViewController.swift
//  Carmu
//
//  Created by 허준혁 on 11/14/23.
//

import UIKit

final class SessionFinishViewController: UIViewController {

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()

    private let characterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "characterDriver"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 셔틀 운행을 마쳤어요\n오늘도 힘내세요!"
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary
        label.numberOfLines = 2
        label.textAlignment = .center
        let attributedStr = NSMutableAttributedString(string: label.text ?? "")
        let range = (label.text as? NSString ?? "").range(of: "카풀 운행")
        attributedStr.addAttribute(.foregroundColor, value: UIColor.semantic.accPrimary ?? UIColor.blue, range: range)
        label.attributedText = attributedStr
        return label
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "carmuLogoSmall"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("customDetent")) { _ in
            return 422 - 34
        }

        if let sheet = sheetPresentationController {
            sheet.detents = [customDetent]
        }

        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(64)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }

        backgroundView.addSubview(characterImageView)
        characterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
        }

        backgroundView.addSubview(noticeLabel)
        noticeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }

        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(26)
            make.width.equalTo(80)
        }
    }
}
