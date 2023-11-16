//
//  StopoverPointCheckView.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

import SnapKit

final class StopoverPointCheckView: UIView {

    private lazy var titleStackView = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "카풀의 ")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "경유지")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "가 있으신가요?")

    let noStopoverButton = LargeSelectButton(topTitle: "아니오", bottomTitle: "넘어가기", imageName: "NoStopoverPoint")

    let yesStopoverButton = LargeSelectButton(topTitle: "네", bottomTitle: "경유지 추가하기", imageName: "YesStopoverPoint")

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        setupViews()
        setAutoLayout()
    }

    private func setupViews() {
        titleStackView.axis = .horizontal

        titleStackView.addArrangedSubview(titleLabel1)
        titleStackView.addArrangedSubview(titleLabel2)
        titleStackView.addArrangedSubview(titleLabel3)

        addSubview(titleStackView)
        addSubview(noStopoverButton)
        addSubview(yesStopoverButton)
    }

    private func setAutoLayout() {

        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(36)
            make.leading.equalToSuperview().inset(20)
        }

        noStopoverButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo((superview?.snp.centerX) ?? 0).offset(-10)
            make.height.equalTo(240)
        }

        yesStopoverButton.snp.makeConstraints { make in
            make.top.equalTo(noStopoverButton)
            make.leading.equalTo((superview?.snp.centerX) ?? 0).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(noStopoverButton)
        }
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct StopoverPointCheckViewPreview: PreviewProvider {
    static var previews: some View {
        SPCViewControllerRepresentable()
    }
}
