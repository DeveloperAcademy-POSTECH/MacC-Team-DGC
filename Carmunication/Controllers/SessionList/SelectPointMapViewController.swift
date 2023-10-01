//
//  SelectPointMapViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

final class SelectPointMapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let vStack = vStackContainer()
        view.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Component
extension SelectPointMapViewController {
    private func vStackContainer() -> UIStackView {
        let vStack = UIStackView(arrangedSubviews: [titleLabel(), backButton()])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .fillEqually
        return vStack
    }

    private func titleLabel() -> UILabel {
        let label = UILabel()
        label.text = "맵뷰"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func backButton() -> UIButton {
        let backButton = UIButton()
        backButton.setTitle("뒤로", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.setBackgroundImage(.pixel(ofColor: .blue), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }
}

// MARK: - @objc Method
extension SelectPointMapViewController {
    @objc private func backButtonAction() {
        dismiss(animated: true)
    }
}
