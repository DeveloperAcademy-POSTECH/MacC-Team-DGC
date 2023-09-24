//
//  SelectPointMapViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

class SelectPointMapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let vStack = vStackContainer()
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Component
extension SelectPointMapViewController {
    func vStackContainer() -> UIStackView {
        let vStack = UIStackView(arrangedSubviews: [titleLabel(), backButton()])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .fillEqually
        return vStack
    }
    func titleLabel() -> UILabel {
        let label = UILabel()
        label.text = "맵뷰"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    func backButton() -> UIButton {
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
    @objc func backButtonAction() {
        dismiss(animated: true)
    }
}
