//
//  GroupAddView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

final class GroupAddView: UIView {

    // MARK: - 텍스트 필드
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "크루 이름을 입력하세요"
        textField.textAlignment = .left
        textField.font = UIFont.carmuFont.body2Long
        textField.textColor = UIColor.semantic.textPrimary
        textField.clearButtonMode = .always
        textField.borderStyle = .none
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 38))
        textField.leftViewMode = .always
        textField.keyboardType = .namePhonePad
        textField.autocapitalizationType = .none

        // 폰트 설정을 NSAttributedString 내부로 이동
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.semantic.textBody?.cgColor as Any,
            .font: UIFont.carmuFont.body2Long // 원하는 폰트 지정
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: "크루 이름을 입력하세요",
            attributes: placeholderAttributes
        )

        // 실선 스타일의 테두리와 cornerRadius 설정
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.theme.blue3?.cgColor

        textField.snp.makeConstraints { make in
            make.height.equalTo(38)
        }

        return textField
    }()

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
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true

        button.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(38)
        }

        return button
    }()

    let crewCreateButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("크루 만들기", for: .normal)
        button.setTitleColor(UIColor.theme.white, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.accPrimary!), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true

        button.snp.makeConstraints { make in
            make.height.equalTo(60)
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
        addSubview(textField)
        addSubview(stopoverPointAddButton)
        addSubview(tableViewComponent)
        addSubview(crewCreateButton)

        textField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        stopoverPointAddButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }

        tableViewComponent.snp.makeConstraints { make in
            make.top.equalTo(stopoverPointAddButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        crewCreateButton.snp.makeConstraints { make in
            make.top.equalTo(tableViewComponent.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(36)
        }
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
