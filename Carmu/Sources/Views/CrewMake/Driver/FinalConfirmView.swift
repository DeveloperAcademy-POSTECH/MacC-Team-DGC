//
//  FinalConfirmView.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

import SnapKit

final class FinalConfirmView: UIView {

    private lazy var firstLineTitleStack = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "전체 여정을 ")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "확인")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "해주세요")

    let daySelectButton: DaySelectButton = {
        let button = DaySelectButton(buttonTitle: "")
        button.backgroundColor = UIColor.semantic.backgroundSecond
        button.setTitleColor(UIColor.semantic.textBody, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.contentHorizontalAlignment = .center
        return button
    }()
    private let containerStack = UIStackView()
    private let colorLine = CrewMakeUtil.createColorLineView()
    private var customTableStack = UIStackView()
    lazy var customStackCell: [StopoverSelectButton] = {
        var buttons: [StopoverSelectButton] = []

        for (index, address) in ["출발지 주소", "경유지 주소", "경유지 2의 주소지 주소지 입니다.", "도착지 주소"].enumerated() {
            let button = StopoverSelectButton(address: address, time: Date())
            button.isEnabled = false
            button.tag = index
            buttons.append(button)
        }
        return buttons
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("카풀 초대하기", for: .normal)
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
        containerStack.axis = .horizontal
        containerStack.spacing = 10
        customTableStack.axis = .vertical
        customTableStack.distribution = .equalSpacing

        addSubview(firstLineTitleStack)
        addSubview(daySelectButton)
        addSubview(containerStack)
        addSubview(nextButton)

        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)

        containerStack.addArrangedSubview(colorLine)
        containerStack.addArrangedSubview(customTableStack)

        for element in customStackCell {
            customTableStack.addArrangedSubview(element)
        }
    }

    private func setAutoLayout() {
        firstLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(36)
            make.leading.equalToSuperview().inset(20)
        }

        daySelectButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerStack.snp.top).offset(-16)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(daySelectButton.titleLabel?.snp.width ?? 0).offset(27.5)
            make.height.equalTo(30)
        }

        containerStack.snp.makeConstraints { make in
            make.top.equalTo(firstLineTitleStack.snp.bottom).offset(80)
            make.bottom.equalTo(nextButton.snp.top).offset(-54)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        colorLine.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.width.equalTo(12)
        }

        customTableStack.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
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
struct FinalConfirmViewPreview: PreviewProvider {
    static var previews: some View {
        FCViewControllerRepresentable()
    }
}
