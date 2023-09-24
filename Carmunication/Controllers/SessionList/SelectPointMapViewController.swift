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
        let label = UILabel()
        label.text = "맵뷰"
        label.translatesAutoresizingMaskIntoConstraints = false
        let backButton = UIButton()
        backButton.setTitle("뒤로", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.setBackgroundImage(.pixel(ofColor: .blue), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        let vStack = UIStackView(arrangedSubviews: [label, backButton])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .fillEqually
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    @objc func backButtonAction() {
        dismiss(animated: true)
    }
}
