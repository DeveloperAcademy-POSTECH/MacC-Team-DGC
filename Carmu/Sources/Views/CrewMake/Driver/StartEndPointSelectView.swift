//
//  StartEndPointSelectView.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class StartEndPointSelectView: UIView {

    private lazy var firstLineTitleStack = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "카풀 여정의 ")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "기본 정보")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "를")
    private lazy var titleLabel5 = CrewMakeUtil.defalutTitle(titleText: "설정해주세요")

    private lazy var colorLine = CrewMakeUtil.createColorLineView()

    private lazy var startPointStack = UIStackView()

    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = "출발지"
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary

        return label
    }()

    lazy var startPointButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("     출발지 검색", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.body2Long
        button.setTitleColor(UIColor.semantic.textBody, for: .normal)
        button.layer.borderColor = UIColor.theme.blue3?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.contentHorizontalAlignment = .left
        button.isSpringLoaded = true

        return button
    }()

    private lazy var endPointStack = UIStackView()

    private lazy var endLabel: UILabel = {
        let label = UILabel()
        label.text = "도착지"
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textPrimary

        return label
    }()

    lazy var endPointButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("     도착지 검색", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.body2Long
        button.setTitleColor(UIColor.semantic.textBody, for: .normal)
        button.layer.borderColor = UIColor.theme.blue3?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.contentHorizontalAlignment = .left
        button.isSpringLoaded = true

        return button
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = UIColor.semantic.backgroundThird
        button.titleLabel?.font = UIFont.carmuFont.headline2
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.setBackgroundImage(
            UIImage(color: UIColor.semantic.textSecondary ?? .white),
            for: .highlighted
        )
        button.layer.cornerRadius = 30
        button.isEnabled = false

        return button
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
        firstLineTitleStack.axis = .horizontal
        startPointStack.axis = .vertical
        endPointStack.axis = .vertical

        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)
        startPointStack.addArrangedSubview(startLabel)
        startPointStack.addArrangedSubview(startPointButton)
        endPointStack.addArrangedSubview(endLabel)
        endPointStack.addArrangedSubview(endPointButton)

        addSubview(firstLineTitleStack)
        addSubview(titleLabel5)
        addSubview(colorLine)
        addSubview(startPointStack)
        addSubview(endPointStack)
        addSubview(nextButton)
    }

    private func setAutoLayout() {
        firstLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(36)
            make.leading.equalToSuperview().inset(20)
        }

        titleLabel5.snp.makeConstraints { make in
            make.top.equalTo(firstLineTitleStack.snp.bottom)
            make.leading.equalToSuperview().inset(20)
        }

        colorLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel5.snp.bottom).offset(108)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }

        startPointStack.snp.makeConstraints { make in
            make.top.equalTo(colorLine).offset(8)
            make.leading.equalTo(colorLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(32)
            make.height.equalTo(74)
        }

        endPointStack.snp.makeConstraints { make in
            make.bottom.equalTo(colorLine).offset(-8)
            make.leading.equalTo(colorLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(32)
            make.height.equalTo(startPointStack)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct StartEndPointSelectViewPreview: PreviewProvider {
    static var previews: some View {
        SEPViewControllerRepresentable()
    }
}
