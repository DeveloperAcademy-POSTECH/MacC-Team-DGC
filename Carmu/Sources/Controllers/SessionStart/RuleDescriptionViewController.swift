//
//  RuleDescriptionViewController.swift
//  Carmu
//
//  Created by 김태형 on 2023/11/10.
//

import UIKit

import SnapKit

final class RuleDescriptionViewController: UIViewController {

    private lazy var ruleDescriptionView = RuleDescriptionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        view.addSubview(ruleDescriptionView)
        view.addSubview(closeInfoButton)

        ruleDescriptionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(460)
        }
        closeInfoButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.top.equalTo(ruleDescriptionView.snp.top).offset(-8)
            make.trailing.equalTo(ruleDescriptionView.snp.trailing).offset(8)
        }

        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)

        closeInfoButton.addTarget(self, action: #selector(closeInfoButtonDidTapped), for: .touchUpInside)
    }

    private lazy var blurView: UIView = {
        let containerView = UIView()
        let blurEffect = UIBlurEffect(style: .dark)
        let cumstomBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0)
        cumstomBlurEffectView.frame = self.view.bounds
        let view = UIView()
        view.backgroundColor = UIColor.theme.trans60
        view.frame = self.view.bounds

        containerView.addSubview(cumstomBlurEffectView)
        containerView.addSubview(view)
        return containerView
    }()

    lazy var closeInfoButton: UIButton = {
        let button = UIButton()
        let closeImage = UIImage(systemName: "xmark")
        button.setImage(closeImage, for: .normal)
        button.tintColor = UIColor.theme.gray8
        button.backgroundColor = UIColor.theme.gray4
        button.layer.cornerRadius = 14
        return button
    }()

    @objc private func closeInfoButtonDidTapped() {
        presentingViewController?.dismiss(animated: true)
    }
}
