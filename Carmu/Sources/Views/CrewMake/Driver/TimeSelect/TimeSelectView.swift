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

    lazy var selectTableStack = UIStackView()
    private lazy var colorLine = CrewMakeUtil.createColorLineView()
    var customTableView = UIStackView()
    lazy var customTableVieWCell = [TimeSelectCellView]()

    let nextButton = NextButton(buttonTitle: "다음")

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        firstLineTitleStack.axis = .horizontal
        selectTableStack.axis = .horizontal
        selectTableStack.spacing = 12
        customTableView.axis = .vertical
        customTableView.distribution = .equalSpacing

        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)

        selectTableStack.addArrangedSubview(colorLine)
        selectTableStack.addArrangedSubview(customTableView)

        addSubview(firstLineTitleStack)
        addSubview(titleLabel5)
        addSubview(selectTableStack)
        addSubview(nextButton)

        for element in customTableVieWCell {
            element.snp.makeConstraints { make in
                make.height.equalTo(54)
            }
            customTableView.addArrangedSubview(element)
        }
    }

    private func setupConstraints() {
        firstLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(36)
            make.leading.equalToSuperview().inset(20)
        }

        titleLabel5.snp.makeConstraints { make in
            make.top.equalTo(firstLineTitleStack.snp.bottom)
            make.leading.equalToSuperview().inset(20)
        }

        selectTableStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel5.snp.bottom).offset(66)
            make.bottom.equalTo(nextButton.snp.top).offset(-60)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        colorLine.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.width.equalTo(12)
        }

        customTableView.snp.makeConstraints { make in
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
struct TimeSelectViewPreview: PreviewProvider {
    static var previews: some View {
        TSViewControllerRepresentable()
    }
}
