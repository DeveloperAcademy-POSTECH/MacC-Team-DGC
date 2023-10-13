//
//  SelectPointMapView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

final class SelectAddressView: UIView {

    // MARK: - 친구 추가 모달 상단 바
    private lazy var headerBar: UIView = {
        let headerStackView = UIView()

        return headerStackView
    }()

    // 상단 바 제목
    private lazy var headerTitleLabel: UILabel = {
        let headerTitleLabel = UILabel()
        headerTitleLabel.text = "주소 설정"
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        headerTitleLabel.textAlignment = .center
        headerTitleLabel.textColor = UIColor.semantic.textPrimary

        return headerTitleLabel
    }()

    // 모달 닫기 버튼
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        let buttonImage = UIImage(systemName: "chevron.left")
        closeButton.setBackgroundImage(buttonImage, for: .normal)
        closeButton.tintColor = UIColor.semantic.accPrimary
        closeButton.contentMode = .scaleAspectFit

        return closeButton
    }()

    // MARK: - 텍스트 필드 배경
    lazy var friendSearchTextFieldView: UIView = {
        let friendSearchTextFieldView = UIView()
        friendSearchTextFieldView.layer.cornerRadius = 20
        friendSearchTextFieldView.layer.borderWidth = 1.0
        friendSearchTextFieldView.layer.borderColor = UIColor.theme.blue3?.cgColor

        return friendSearchTextFieldView
    }()

    // MARK: - 텍스트 필드
    lazy var friendSearchTextField: UITextField = {
        let friendSearchTextField = UITextField()
        friendSearchTextField.textAlignment = .left
        friendSearchTextField.font = UIFont.carmuFont.body2Long
        friendSearchTextField.textColor = UIColor.semantic.textPrimary
        friendSearchTextField.autocapitalizationType = .none

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.semantic.textPrimary as Any,
            .font: UIFont.carmuFont.body2Long
        ]
        friendSearchTextField.attributedPlaceholder = NSAttributedString(
            string: "주소지를 검색하세요",
            attributes: placeholderAttributes
        )

        friendSearchTextField.rightView = textFieldUtilityStackView
        friendSearchTextField.rightViewMode = .whileEditing

        return friendSearchTextField
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "주소지를 검색하세요"
        searchBar.searchTextField.textColor = UIColor.semantic.textPrimary
        searchBar.searchTextField.autocapitalizationType = .none

        return searchBar
    }()

    // MARK: - 텍스트 필드 우측 스택
    private lazy var textFieldUtilityStackView: UIStackView = {
        let textFieldUtilityStackView = UIStackView()
        textFieldUtilityStackView.axis = .horizontal
        textFieldUtilityStackView.alignment = .center
        textFieldUtilityStackView.distribution = .fill

        return textFieldUtilityStackView
    }()

    // MARK: - 텍스트 필드 clear 버튼
    lazy var clearButton: UIButton = {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = UIColor.semantic.accPrimary

        return clearButton
    }()

    // MARK: - 텍스트 필드 검색 버튼
    lazy var friendSearchButton: UIButton = {
        let friendSearchButton = UIButton()
        friendSearchButton.setTitle("검색", for: .normal)
        friendSearchButton.setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        friendSearchButton.titleLabel?.font = UIFont.carmuFont.body2Long

        return friendSearchButton
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
        addSubview(friendSearchTextFieldView)
//        addSubview(searchBar)  // UITextField 대신 UISearchBar를 추가합니다.
        headerBar.addSubview(headerTitleLabel)
        headerBar.addSubview(closeButton)
        friendSearchTextFieldView.addSubview(friendSearchTextField)
        addSubview(tableViewComponent)

        textFieldUtilityStackView.addArrangedSubview(clearButton)
        textFieldUtilityStackView.addArrangedSubview(friendSearchButton)
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
            make.leading.equalToSuperview().inset(7)
            make.centerY.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(24)
        }

        friendSearchTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(headerBar.snp.bottom).offset(20)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(38)
        }

        friendSearchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(8)
        }

//        searchBar.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.top.bottom.equalToSuperview().inset(8)
//        }

        clearButton.snp.makeConstraints { make in
            make.trailing.equalTo(friendSearchButton.snp.leading).offset(-10)
        }

        tableViewComponent.snp.makeConstraints { make in
            make.top.equalTo(friendSearchTextFieldView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
//        tableViewComponent.snp.makeConstraints { make in
//            make.top.equalTo(searchBar.snp.bottom).offset(8)
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
//        }
    }
}
