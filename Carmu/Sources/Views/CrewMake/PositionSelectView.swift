//
//  PositionSelectView.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

import SnapKit

final class PositionSelectView: UIView {

    private var skipButton: UIButton = {
        let skipButton = UIButton()
        skipButton.setTitle("건너뛰기", for: .normal)
        skipButton.setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        skipButton.setTitleColor(UIColor.theme.gray4, for: .highlighted)
        skipButton.titleLabel?.font = UIFont.carmuFont.subhead3
        return skipButton
    }()

    private var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "함께하는 ")
    private var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "카풀")
    private var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "에서의")
    private var titleLabel4 = CrewMakeUtil.accPrimaryTitle(titleText: "포지션")
    private var titleLabel5 = CrewMakeUtil.defalutTitle(titleText: "을 설정해주세요")

    private let selectDriverButton = LargeSelectButton(
        topTitle: "운전자",
        bottomTitle: "여정 만들기",
        imageName: "PositionSelectDriver"
    )

    private let selectCrewButton = LargeSelectButton(
        topTitle: "동승자",
        bottomTitle: "여정 합류하기",
        imageName: "PositionSelectCrew"
    )

    private var explainLabel1: UILabel = {
        let label = UILabel()
        label.text = "여정의 전반적인\n과정을 계획합니다."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.carmuFont.body1
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    private lazy var explainLabel2: UILabel = {
        let label = UILabel()
        label.text = "운전자에게 초대링크를 받아\n여정에 합류합니다."
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
        addSubview(skipButton)
        addSubview(titleLabel1)
        addSubview(titleLabel2)
        addSubview(titleLabel3)
        addSubview(titleLabel4)
        addSubview(titleLabel5)
        addSubview(selectDriverButton)
        addSubview(selectCrewButton)
        addSubview(explainLabel1)
        addSubview(explainLabel2)
    }

    private func setAutoLayout() {
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(12)
            make.trailing.equalToSuperview().inset(20)
        }

        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(78)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(titleLabel5.snp.top)
        }

        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1)
            make.leading.equalTo(titleLabel1.snp.trailing)
            make.bottom.equalTo(titleLabel5.snp.top)
        }

        titleLabel3.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2)
            make.leading.equalTo(titleLabel2.snp.trailing)
            make.bottom.equalTo(titleLabel5.snp.top)
        }

        titleLabel4.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.leading.equalToSuperview().inset(20)
        }

        titleLabel5.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom)
            make.leading.equalTo(titleLabel4.snp.trailing)
        }

        selectDriverButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel4.snp.bottom).offset(120)
            make.width.equalTo(165)
            make.height.equalTo(240)
        }

        selectCrewButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel4.snp.bottom).offset(120)
            make.leading.greaterThanOrEqualTo(selectDriverButton.snp.trailing).offset(2)
            make.width.equalTo(165)
            make.height.equalTo(240)
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
