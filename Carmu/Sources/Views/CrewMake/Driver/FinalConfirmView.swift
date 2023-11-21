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

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "전체 ")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "셔틀 계획을 확인")
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
    lazy var customStackCell = [StopoverSelectButton]()

    let nextButton = NextButton(buttonTitle: "탑승자 초대하기")

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
}

// MARK: - Setup UI, Constraints
extension FinalConfirmView {
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
