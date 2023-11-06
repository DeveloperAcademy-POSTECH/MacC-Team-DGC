//
//  RepeatDaySelectView.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class RepeatDaySelectView: UIView {

    private let secondLineTitleStack = UIStackView()

    private let titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "카풀이 반복되는")
    private let titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "요일을 설정")
    private let titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "해주세요")

    let weekdayButton = DaySelectButton(buttonTitle: "주중")
    let weekendButton = DaySelectButton(buttonTitle: "주말")
    let everydayButton = DaySelectButton(buttonTitle: "매일")

    let dayTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 10
        return tableView
    }()

    let nextButton = NextButton(buttonTitle: "다음")

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

// MARK: - Setup UI, Constraint
extension RepeatDaySelectView {

    private func setupViews() {
        secondLineTitleStack.axis = .horizontal

        secondLineTitleStack.addArrangedSubview(titleLabel2)
        secondLineTitleStack.addArrangedSubview(titleLabel3)

        addSubview(titleLabel1)
        addSubview(secondLineTitleStack)
        addSubview(weekdayButton)
        addSubview(weekendButton)
        addSubview(everydayButton)
        addSubview(dayTableView)
        addSubview(nextButton)
    }

    private func setAutoLayout() {
        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(36)
            make.leading.equalToSuperview().inset(20)
        }

        secondLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.leading.equalToSuperview().inset(20)
        }

        weekdayButton.snp.makeConstraints { make in
            make.top.equalTo(secondLineTitleStack.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(60)
        }

        weekendButton.snp.makeConstraints { make in
            make.centerY.equalTo(weekdayButton)
            make.leading.equalTo(weekdayButton.snp.trailing).offset(10)
            make.width.equalTo(60)
        }

        everydayButton.snp.makeConstraints { make in
            make.centerY.equalTo(weekdayButton)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(60)
        }

        dayTableView.snp.makeConstraints { make in
            make.top.equalTo(weekdayButton.snp.bottom).offset(24)
            make.bottom.equalTo(nextButton.snp.top).offset(-40)
            make.horizontalEdges.equalToSuperview().inset(20)

        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Previewer
import SwiftUI

@available(iOS 13.0.0, *)
struct RepeatDaySelectViewPreview: PreviewProvider {

    static var previews: some View {
        RDSViewControllerRepresentable()
    }
}
