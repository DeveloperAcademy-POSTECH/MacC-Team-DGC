//
//  PositionSelectView.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

import SnapKit

final class PositionSelectView: UIView {

    lazy var skipButton: UIButton = {
        let skipButton = UIButton()
        skipButton.setTitle("건너뛰기", for: .normal)
        skipButton.setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        skipButton.setTitleColor(UIColor.theme.gray4, for: .highlighted)
        skipButton.titleLabel?.font = UIFont.carmuFont.body3
        return skipButton
    }()

    private let firstLineStack = UIStackView()
    private let secondLineStack = UIStackView()

    private let titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "셔틀을 ")
    private let titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "계획")
    private let titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "하거나")
    private let titleLabel4 = CrewMakeUtil.defalutTitle(titleText: "셔틀에 ")
    private let titleLabel5 = CrewMakeUtil.accPrimaryTitle(titleText: "합류")
    private let titleLabel6 = CrewMakeUtil.defalutTitle(titleText: "해주세요")

    lazy var selectDriverButton = LargeSelectButton(
        topTitle: "기사님",
        bottomTitle: "셔틀 계획하기",
        imageName: "PositionSelectDriver"
    )

    lazy var selectCrewButton = LargeSelectButton(
        topTitle: "탑승자",
        bottomTitle: "셔틀 합류하기",
        imageName: "PositionSelectCrew"
    )

    private var explainLabel1: UILabel = {
        let label = UILabel()
        label.text = "셔틀의 전반적인 과정을\n계획합니다."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.carmuFont.body1
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    private lazy var explainLabel2: UILabel = {
        let label = UILabel()
        label.text = "셔틀 초대링크를 받아\n합류합니다."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.carmuFont.body1
        label.textColor = UIColor.semantic.textBody
        return label
    }()

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
        firstLineStack.axis = .horizontal
        secondLineStack.axis = .horizontal

        firstLineStack.addArrangedSubview(titleLabel1)
        firstLineStack.addArrangedSubview(titleLabel2)
        firstLineStack.addArrangedSubview(titleLabel3)
        secondLineStack.addArrangedSubview(titleLabel4)
        secondLineStack.addArrangedSubview(titleLabel5)
        secondLineStack.addArrangedSubview(titleLabel6)

        addSubview(skipButton)
        addSubview(firstLineStack)
        addSubview(secondLineStack)
        addSubview(selectDriverButton)
        addSubview(selectCrewButton)
        addSubview(explainLabel1)
        addSubview(explainLabel2)
    }

    private func setAutoLayout() {
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.trailing.equalToSuperview().inset(20)
        }

        firstLineStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(78)
            make.leading.equalToSuperview().inset(20)
        }

        secondLineStack.snp.makeConstraints { make in
            make.top.equalTo(firstLineStack.snp.bottom)
            make.leading.equalTo(firstLineStack)
        }

        selectDriverButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo((superview?.snp.centerX) ?? 0).offset(-10)
            make.height.equalTo(240)
        }

        selectCrewButton.snp.makeConstraints { make in
            make.top.equalTo(selectDriverButton)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo((superview?.snp.centerX) ?? 0).offset(10)
            make.height.equalTo(selectDriverButton)
        }

        explainLabel1.snp.makeConstraints { make in
            make.centerX.equalTo(selectDriverButton.snp.centerX)
            make.top.equalTo(selectDriverButton.snp.bottom).offset(16)
        }

        explainLabel2.snp.makeConstraints { make in
            make.centerX.equalTo(selectCrewButton.snp.centerX)
            make.top.equalTo(selectCrewButton.snp.bottom).offset(16)
        }
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct PositionSelectViewPreview: PreviewProvider {
    static var previews: some View {
        PSViewControllerRepresentable()
    }
}
