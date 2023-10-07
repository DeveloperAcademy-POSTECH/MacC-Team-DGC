//
//  GroupAddView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

final class GroupAddView: UIView {

    let tableViewComponent = {
        let tableView = UITableView()
        tableView.register(GroupAddTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    let stopoverPointAddButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("경유지 추가", for: .normal)
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.accPrimary!), for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true

        button.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(38)
        }

        return button
    }()

    var selectedGroup: DummyGroup?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        let crewCreateButton = crewCreateButton(
            buttonWidth: .greatestFiniteMagnitude,
            buttonHeight: 60
        )

        addSubview(tableViewComponent)
        addSubview(crewCreateButton)

        tableViewComponent.snp.makeConstraints { make in

            make.leading.trailing.equalToSuperview().inset(20)
        }

        crewCreateButton.snp.makeConstraints { make in
            make.top.equalTo(tableViewComponent.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(36)
        }
    }

    /**
     크루 만들기 버튼
     */
    private func crewCreateButton(
        buttonWidth width: CGFloat,
        buttonHeight height: CGFloat
    ) -> UIButton {
        let button = UIButton(type: .system)

        button.setTitle("크루 만들기", for: .normal)
        button.setTitleColor(UIColor.theme.white, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.accPrimary!), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true

        button.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }

        return button
    }
}

// MARK: - Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct GroupAddViewPreview: PreviewProvider {

    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }

}
