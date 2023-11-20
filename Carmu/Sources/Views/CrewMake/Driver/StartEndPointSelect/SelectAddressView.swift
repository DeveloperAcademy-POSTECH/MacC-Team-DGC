//
//  SelectPointMapView.swift
//  Carmu
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

final class SelectAddressView: UIView {

    // MARK: - 모달 상단 바
    private lazy var headerBar: UIView = {
        let headerStackView = UIView()
        return headerStackView
    }()

    // 상단 바 제목
    lazy var headerTitleLabel: UILabel = {
        let headerTitleLabel = UILabel()
        headerTitleLabel.text = "주소 설정"
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        headerTitleLabel.textAlignment = .center
        headerTitleLabel.textColor = UIColor.semantic.textPrimary
        return headerTitleLabel
    }()

    // 모달 닫기 버튼
    let closeButton: UIButton = {
        let closeButton = UIButton()
        let buttonImage = UIImage(systemName: "xmark")
        closeButton.setBackgroundImage(buttonImage, for: .normal)
        closeButton.tintColor = UIColor.semantic.accPrimary
        closeButton.contentMode = .scaleAspectFit
        return closeButton
    }()

    // MARK: - 텍스트 필드 배경
    let addressSearchTextFieldView: UIView = {
        let txfieldView = UIView()
        txfieldView.layer.cornerRadius = 20
        txfieldView.layer.borderWidth = 1.0
        txfieldView.layer.borderColor = UIColor.theme.blue3?.cgColor
        return txfieldView
    }()

    // MARK: - 텍스트 필드
    let addressSearchTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.font = UIFont.carmuFont.body2Long
        textField.textColor = UIColor.semantic.textPrimary
        textField.autocapitalizationType = .none

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.semantic.textPrimary as Any,
            .font: UIFont.carmuFont.body2Long
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: "출발지 검색",
            attributes: placeholderAttributes
        )
        return textField
    }()

    // MARK: - 텍스트 필드 clear 버튼
    let clearButton: UIButton = {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = UIColor.semantic.accPrimary
        clearButton.isHidden = true
        return clearButton
    }()

    let tableViewComponent: UITableView = {
        let tableView = UITableView()
        tableView.register(SelectAddressTableViewCell.self, forCellReuseIdentifier: "selectAddressCell")
        tableView.register(DefaultAddressTableViewCell.self, forCellReuseIdentifier: "defaultAddressCell")
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
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        addSubview(headerBar)
        addSubview(addressSearchTextFieldView)
        headerBar.addSubview(headerTitleLabel)
        headerBar.addSubview(closeButton)
        addressSearchTextFieldView.addSubview(addressSearchTextField)
        addressSearchTextFieldView.addSubview(clearButton)
        addSubview(tableViewComponent)
    }

    // MARK: - 오토 레이아웃 설정 메서드
    private func setupConstraints() {
        headerBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }

        headerTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(130)
        }

        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(21)
            make.height.equalTo(24)
        }

        addressSearchTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(headerBar.snp.bottom).offset(20)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(38)
        }

        addressSearchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(8)
        }

        clearButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }

        tableViewComponent.snp.makeConstraints { make in
            make.top.equalTo(addressSearchTextFieldView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - Previewer
import SwiftUI

@available(iOS 13.0.0, *)
struct SelectAddressViewPreview: PreviewProvider {

    static var previews: some View {
        SelectAddressViewControllerRepresentable()
    }
}
