//
//  SessionListView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

final class SessionListView: UIView {

    // Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
    // TODO: 버튼 크기 조절과 셀과 함께 유동적으로 움직이는 버튼 구현
    private lazy var mainStack = {
        let mainStackView = UIStackView()
        let stackView = addNewGroupButton
        let tableView = tableViewComponent
        mainStackView.axis = .vertical
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(stackView)

        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }

        return mainStackView
    }()

    // TODO: - 뒷 배경 흐리게 하여 뒷 셀 보이도록 처리하기
    lazy var addNewGroupButton: UIButton = {
        let button = buttonComponent(
            title: "+ 새 그룹 만들기",
            width: 174,
            height: 62,
            fontColor: UIColor.semantic.textSecondary!,
            backgroundColor: UIColor.semantic.accPrimary!
        )
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        return button
    }()

    let tableViewComponent = {
        let tableView = UITableView()
        tableView.register(CustomListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(NotFoundCrewTableViewCell.self, forCellReuseIdentifier: "notFoundCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }

    private func buttonComponent(
        title: String,
        width: CGFloat,
        height: CGFloat,
        fontColor: UIColor,
        backgroundColor: UIColor
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(fontColor, for: .normal)
        button.setBackgroundImage(.pixel(ofColor: backgroundColor), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        return button
    }
}
