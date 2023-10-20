//
//  FriendAddView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/10.
//

import UIKit

final class FriendAddView: UIView {

    // MARK: - 친구 추가 모달 상단 바
    private lazy var headerBar: UIView = {
        let headerStackView = UIView()
        return headerStackView
    }()

    // 상단 바 제목
    private lazy var headerTitleLabel: UILabel = {
        let headerTitleLabel = UILabel()
        headerTitleLabel.text = "친구추가"
        headerTitleLabel.textAlignment = .center
        // TODO: 폰트 적용 필요
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        headerTitleLabel.textColor = UIColor.semantic.textPrimary
        return headerTitleLabel
    }()

    // 모달 닫기 버튼
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.semantic.accPrimary
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
            string: "친구의 닉네임을 검색하세요.",
            attributes: placeholderAttributes
        )

        friendSearchTextField.rightView = textFieldUtilityStackView
        friendSearchTextField.rightViewMode = .whileEditing

        return friendSearchTextField
    }()

    // MARK: - 텍스트 필드 우측 스택
    lazy var textFieldUtilityStackView: UIStackView = {
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

    // MARK: - 친구 검색 결과를 보여주기 위한 테이블 뷰
    lazy var searchedFriendTableView: UITableView = {
        let searchedFriendTableView = UITableView()
        searchedFriendTableView.separatorStyle = .none
        searchedFriendTableView.showsVerticalScrollIndicator = false
        return searchedFriendTableView
    }()

    // MARK: - 친구 추가하기 버튼
    lazy var friendAddButton: UIButton = {
        let friendAddButton = UIButton()
        friendAddButton.backgroundColor = UIColor.theme.blue6
        friendAddButton.setTitle("친구 추가하기", for: .normal)
        friendAddButton.titleLabel?.font = UIFont.carmuFont.subhead3
        friendAddButton.setTitleColor(UIColor.theme.white, for: .normal)
        friendAddButton.layer.cornerRadius = 30

        friendAddButton.setTitleColor(UIColor.semantic.textDisableBT, for: .disabled)
        return friendAddButton
    }()

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

    func setupViews() {
        addSubview(headerBar)
        addSubview(friendSearchTextFieldView)
        addSubview(searchedFriendTableView)
        addSubview(friendAddButton)

        headerBar.addSubview(headerTitleLabel)
        headerBar.addSubview(closeButton)

        friendSearchTextFieldView.addSubview(friendSearchTextField)

        textFieldUtilityStackView.addArrangedSubview(clearButton)
        textFieldUtilityStackView.addArrangedSubview(friendSearchButton)
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
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
            make.width.height.equalTo(22)
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
        clearButton.snp.makeConstraints { make in
            make.trailing.equalTo(friendSearchButton.snp.leading).offset(-10)
        }
        searchedFriendTableView.snp.makeConstraints { make in
            make.top.equalTo(friendSearchTextFieldView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            // TODO: - 하단에 남는 공간이 많아서 임의로 넉넉하게 잡은 크기임
            make.height.equalTo(150)
        }
        friendAddButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(60)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FriendAddViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FriendAddViewController
    func makeUIViewController(context: Context) -> FriendAddViewController {
        return FriendAddViewController()
    }
    func updateUIViewController(_ uiViewController: FriendAddViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct FriendAddViewPreview: PreviewProvider {
    static var previews: some View {
        FriendAddViewControllerRepresentable()
    }
}
