//
//  GroupDetailView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/6/23.
//

import UIKit

import SnapKit

final class GroupDetailView: UIView {

    var tableViewComponent = {
        let tableView = UITableView()
        tableView.register(GroupDetailTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    var selectedGroup: DummyGroup?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        let mainStackView = topLabelStack()
        let crewExitButton = buttonComponent(
            buttonWidth: .greatestFiniteMagnitude,
            buttonHeight: 60
        )

        addSubview(mainStackView)
        addSubview(tableViewComponent)
        addSubview(crewExitButton)

        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide)
        }

        tableViewComponent.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(20) // mainStackView 바로 아래에 20 포인트 간격으로 배치
            make.leading.trailing.equalToSuperview().inset(20)
        }

        crewExitButton.snp.makeConstraints { make in
            make.top.equalTo(tableViewComponent.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(36)
        }
    }

    /**
     Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
     */
    private func topLabelStack() -> UIStackView {
        let crewNameStack = crewNameLabel(selectedGroup?.groupTitle ?? "배찌의 행복여행")
        let distanceLabelStack = distanceLabel(selectedGroup?.accumulateDistance ?? 20)

        let mainStackView = UIStackView(arrangedSubviews: [crewNameStack, distanceLabelStack])
        mainStackView.axis = .vertical

        crewNameStack.snp.makeConstraints { make in
            make.bottom.equalTo(distanceLabelStack.snp.top).offset(-8)
        }
        return mainStackView
    }

    /**
     이 뷰에서 사용되는 buttonComponent
     */
    private func buttonComponent(
        buttonWidth width: CGFloat,
        buttonHeight height: CGFloat
    ) -> UIButton {
        let button = UIButton(type: .system)

        button.setTitle("크루 나가기", for: .normal)
        button.setTitleColor(UIColor.theme.white, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.negative!), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true

        button.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }

        return button
    }

    /**
     크루의 이름을 표시하는 라벨 스택
     */
    private func crewNameLabel(_ crewName: String) -> UIStackView {
        let stackView = UIStackView()
        let crewNameLabel = UILabel()
        crewNameLabel.text = crewName
        crewNameLabel.font = UIFont.carmuFont.headline2
        crewNameLabel.textColor = UIColor.semantic.textPrimary
        stackView.addArrangedSubview(crewNameLabel)

        return stackView
    }

    /**
     주행거리 표시 라벨 스택
     */
    private func distanceLabel(_ distance: Int) -> UIStackView {
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let stackView = UIStackView(arrangedSubviews: [label1, label2, label3, spacer()])

        label1.text = "이 크루와 함께한 여정은 "
        label2.text = "\(distance)km "
        label3.text = "입니다."

        label1.font = UIFont.carmuFont.subhead3
        label2.font = UIFont.carmuFont.subhead3
        label3.font = UIFont.carmuFont.subhead3
        label1.textColor = UIColor.semantic.textBody
        label2.textColor = UIColor.semantic.accPrimary
        label3.textColor = UIColor.semantic.textBody

        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .leading
        stackView.distribution = .fill

        return stackView
    }

    private func spacer() -> UIView {
        let spacerView = UIView()
        return spacerView
    }
}
