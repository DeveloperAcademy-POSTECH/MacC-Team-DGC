//
//  GroupAddView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

final class GroupAddView: UIView {

    /**
     Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
     */
    lazy var mainStack = {
        let shareButton = buttonComponent("링크 공유하기", .greatestFiniteMagnitude, 60, 30, .black, .gray)
        let mainStackView = UIStackView(
            arrangedSubviews: [mainTopButtonStack, tableViewComponent, shareButton]
        )
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        return mainStackView
    }()

    lazy var addButton = {
        buttonComponent("추가하기", 110, 30, 20, .blue, .cyan)
    }()

    lazy var mainTopButtonStack = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), addButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    var tableViewComponent = {
        let tableView = UITableView()
        tableView.register(GroupAddTableViewCell.self, forCellReuseIdentifier: "cell")
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
            make.bottom.equalToSuperview().inset(50)
        }
    }

    private func buttonComponent(
        _ title: String,
        _ width: CGFloat,
        _ height: CGFloat,
        _ cornerRadius: CGFloat,
        _ fontColor: UIColor,
        _ backgroundColor: UIColor
    ) -> UIButton {

        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(fontColor, for: .normal)
        button.setBackgroundImage(.pixel(ofColor: backgroundColor), for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        button.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }

        return button
    }
}
