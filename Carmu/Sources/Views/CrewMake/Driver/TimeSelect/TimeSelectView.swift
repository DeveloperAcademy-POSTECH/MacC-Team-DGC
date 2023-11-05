//
//  TimeSelectView.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class TimeSelectView: UIView {

    private lazy var firstLineTitleStack = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "장소들의 ")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "예정 시간")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "을")
    private lazy var titleLabel5 = CrewMakeUtil.defalutTitle(titleText: "설정해주세요")

    private lazy var colorLine = CrewMakeUtil.createColorLineView()

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = UIColor.semantic.accPrimary
        button.titleLabel?.font = UIFont.carmuFont.headline2
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.setBackgroundImage(
            UIImage(color: UIColor.semantic.textSecondary ?? .white),
            for: .highlighted
        )
        button.layer.cornerRadius = 30

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

        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)

        addSubview(firstLineTitleStack)
        addSubview(titleLabel5)
        addSubview(colorLine)
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
            make.top.equalTo(titleLabel5.snp.bottom).offset(40)
            make.bottom.equalTo(nextButton.snp.top).offset(-52)
            make.leading.equalToSuperview().inset(20)
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
struct TimeSelectViewPreview: PreviewProvider {
    static var previews: some View {
        TSViewControllerRepresentable()
    }
}
