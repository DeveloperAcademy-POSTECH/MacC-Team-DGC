//
//  SessionListView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/6/23.
//

import UIKit

final class SessionListView: UIView {

    // Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
    lazy var mainStack = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical

        mainStackView.addArrangedSubview(tableViewComponent)
        tableViewComponent.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        mainStackView.addArrangedSubview(addNewGroupButton)
        addNewGroupButton.snp.makeConstraints { make in
            make.top.equalTo(tableViewComponent.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        return mainStackView
    }()

    // TODO: - 뒷 배경 흐리게 하여 뒷 셀 보이도록 처리하기
    lazy var addNewGroupButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ 새 그룹 만들기", for: .normal)
        button.setTitleColor(UIColor.semantic.textSecondary!, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.accPrimary!), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.snp.makeConstraints { make in
            make.width.equalTo(174)
            make.height.equalTo(62)
        }
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
            make.bottom.equalTo(safeAreaLayoutGuide).inset(36)
        }
    }
}
