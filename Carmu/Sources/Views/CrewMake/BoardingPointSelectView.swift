//
//  BoardingPointSelectView.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

class BoardingPointSelectView: UIView {

    private lazy var firstLineTitleStack = UIStackView()
    private lazy var secondLineTitleStack = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "탑승하시는 ")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "장소")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "를")
    private lazy var titleLabel4 = CrewMakeUtil.accPrimaryTitle(titleText: "선택")
    private lazy var titleLabel5 = CrewMakeUtil.defalutTitle(titleText: "해주세요")

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("카풀 시작하기", for: .normal)
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
        firstLineTitleStack.alignment = .center
        secondLineTitleStack.axis = .horizontal
        secondLineTitleStack.alignment = .center

        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)

        secondLineTitleStack.addArrangedSubview(titleLabel4)
        secondLineTitleStack.addArrangedSubview(titleLabel5)

        addSubview(firstLineTitleStack)
        addSubview(secondLineTitleStack)
        addSubview(nextButton)
    }

    private func setAutoLayout() {
        firstLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(78)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(secondLineTitleStack.snp.top)
        }

        secondLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(firstLineTitleStack.snp.bottom)
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
struct BoardingPointSelectViewPreview: PreviewProvider {
    static var previews: some View {
        BPSViewControllerRepresentable()
    }
}
