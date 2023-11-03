//
//  BoardingPointSelectView.swift
//  Carmu
//
//  Created by 김동현 on 11/2/23.
//

import UIKit

final class BoardingPointSelectView: UIView {

    private lazy var firstLineTitleStack = UIStackView()
    private lazy var secondLineTitleStack = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "탑승하시는 ")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "장소")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "를")
    private lazy var titleLabel4 = CrewMakeUtil.accPrimaryTitle(titleText: "선택")
    private lazy var titleLabel5 = CrewMakeUtil.defalutTitle(titleText: "해주세요")

    lazy var selectTableStack = UIStackView()
    lazy var colorLineView = CrewMakeUtil.createColorLineView()
    var customTableView = UIStackView()
    lazy var customTableVieWCell: [StopoverSelectButton] = {
        var buttons: [StopoverSelectButton] = []

        for (index, address) in ["출발지 주소", "경유지 주소", "경유지 2주소 입니다dddfdfd", "도착지 주소"].enumerated() {
            let button = StopoverSelectButton(address: address, time: Date())
            button.tag = index
            buttons.append(button)
        }

        return buttons
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("카풀 시작하기", for: .normal)
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
        firstLineTitleStack.alignment = .center
        secondLineTitleStack.axis = .horizontal
        secondLineTitleStack.alignment = .center
        selectTableStack.axis = .horizontal
        selectTableStack.spacing = 12
        customTableView.axis = .vertical
        customTableView.distribution = .equalSpacing

        addSubview(firstLineTitleStack)
        addSubview(secondLineTitleStack)
        addSubview(nextButton)
        addSubview(selectTableStack)

        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)

        secondLineTitleStack.addArrangedSubview(titleLabel4)
        secondLineTitleStack.addArrangedSubview(titleLabel5)

        selectTableStack.addArrangedSubview(colorLineView)
        selectTableStack.addArrangedSubview(customTableView)

        for element in customTableVieWCell {
            customTableView.addArrangedSubview(element)
        }
    }

    private func setAutoLayout() {
        firstLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(36)
            make.bottom.equalTo(secondLineTitleStack.snp.top)
            make.leading.equalToSuperview().inset(20)
        }

        secondLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(firstLineTitleStack.snp.bottom)
            make.leading.equalToSuperview().inset(20)
        }

        selectTableStack.snp.makeConstraints { make in
            make.top.equalTo(secondLineTitleStack.snp.bottom).offset(66)
            make.bottom.equalTo(nextButton.snp.top).offset(-60)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        colorLineView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.trailing.equalTo(customTableView.snp.leading).offset(-12)
            make.width.equalTo(12)
        }

        customTableView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.leading.equalTo(colorLineView.snp.trailing).offset(12)
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
