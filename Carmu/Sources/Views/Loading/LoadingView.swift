//
//  LoadingView.swift
//  Carmu
//
//  Created by 김동현 on 11/14/23.
//

import UIKit

final class LoadingView: UIView {

    private let loadingLabelStack = UIStackView()

    private let loadingLabel = {
        let label = UILabel()
        label.text = "기다리는 중"
        label.textAlignment = .center
        label.font = UIFont.carmuFont.headline2
        label.textColor = UIColor.semantic.textSecondary
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.color = UIColor.semantic.textSecondary
        indicator.startAnimating()
        return indicator
    }()

    private let characterImage = {
        let imageView = UIImageView()
        let image = UIImage(named: "LoadingCharacterRed")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Setup UI
extension LoadingView {

    private func setupUI() {
        backgroundColor = UIColor.theme.darkblue7

        loadingLabelStack.axis = .horizontal
        loadingLabelStack.addArrangedSubview(loadingLabel)
        loadingLabelStack.addArrangedSubview(activityIndicator)

        addSubview(loadingLabelStack)
        addSubview(characterImage)
    }

    private func setupConstraints() {
        loadingLabelStack.snp.makeConstraints { make in
            make.bottom.equalTo(characterImage.snp.top).offset(-50)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(34)
        }

        characterImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(70)
        }
    }
}

// MARK: - custom Method
extension LoadingView {
    func showLoadingView(showInterval second: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + second) {
            self.removeFromSuperview()
        }
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct LoadingViewPreview: PreviewProvider {
    static var previews: some View {
        LoadingViewControllerRepresentable()
    }
}
