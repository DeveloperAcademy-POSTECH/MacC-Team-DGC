//
//  PointEditTableViewCell.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/15.
//

import UIKit

// MARK: - 셀의 설정 버튼 탭 시 이벤트를 처리하기 위한 델리게이트 프로토콜
protocol PointEditTableViewCellDelegate: AnyObject {

    func timeEditButtonTapped(sender: UIButton)
    func addressEditButtonTapped(sender: UIButton, pointType: PointType, pointData: Point)
}

// MARK: - 크루 편집 화면에서의 포인트 별 편집 테이블 뷰 셀
final class PointEditTableViewCell: UITableViewCell {

    weak var pointEditTableViewCellDelegate: PointEditTableViewCellDelegate?

    static let cellIdentifier = "pointEditTableViewCell"
    var pointType: PointType = .start
    var pointData: Point?

    // 주소 설정 버튼
    lazy var addressEditButton: UIButton = {
        let addressEditButton = UIButton()
        addressEditButton.setTitle("주소를 검색해주세요.", for: .normal)
        addressEditButton.titleLabel?.font = UIFont.carmuFont.subhead2
        addressEditButton.setTitleColor(UIColor.semantic.textTertiary, for: .normal)
        addressEditButton.backgroundColor = UIColor.semantic.backgroundDefault
        addressEditButton.layer.cornerRadius = 16
        addressEditButton.layer.borderWidth = 1
        addressEditButton.layer.borderColor = UIColor.semantic.stoke?.cgColor
        addressEditButton.contentHorizontalAlignment = .leading
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        addressEditButton.configuration = config
        return addressEditButton
    }()

    // 시간 타입 라벨
    lazy var timeTypeLabel: UILabel = {
        let timeTypeLabel = UILabel()
        timeTypeLabel.text = "출발"
        timeTypeLabel.font = UIFont.carmuFont.body1
        timeTypeLabel.textColor = UIColor.semantic.textTertiary
        return timeTypeLabel
    }()

    // 시간 설정 버튼
    lazy var timeEditButton: UIButton = {
        let timeEditButton = UIButton()
        timeEditButton.setTitle("오전 08:00", for: .normal)
        timeEditButton.titleLabel?.font = UIFont.carmuFont.subhead3
        timeEditButton.setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        timeEditButton.backgroundColor = UIColor.semantic.backgroundThird
        timeEditButton.layer.cornerRadius = 4
        return timeEditButton
    }()

    // 경유지 삭제 버튼
    lazy var xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.semantic.stoke
        button.isHidden = true
        return button
    }()

    // 경유지 추가 버튼 뷰
    lazy var addButtonContainer: UIView = {
        let addButtonContainer = UIView()
        addButtonContainer.backgroundColor = .red
        addButtonContainer.isHidden = true
        return addButtonContainer
    }()
    // 경유지 추가 버튼
    lazy var addButton: UIButton = {
        let addButton = UIButton(type: .system)
        addButton.setTitle("􀅼 경유지 추가", for: .normal)
        addButton.titleLabel?.font = UIFont.carmuFont.subhead2
        addButton.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        addButton.setBackgroundImage(UIImage(color: UIColor.semantic.accPrimary ?? .white), for: .normal)
        addButton.layer.cornerRadius = 15
        addButton.layer.masksToBounds = true
        return addButton
    }()
    // 제한 안내 문구
    lazy var guideLabel: UILabel = {
        let guideLabel = UILabel()
        guideLabel.text = "경유지는 최대 3개까지 생성할 수 있습니다."
        guideLabel.font = UIFont.carmuFont.body1Long
        guideLabel.textColor = UIColor.semantic.textBody
        guideLabel.backgroundColor = .purple
        return guideLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        timeEditButton.addTarget(self, action: #selector(timeEditButtonTapped), for: .touchUpInside)
        addressEditButton.addTarget(self, action: #selector(addressEditButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none // 셀 선택 막음

//        backgroundColor = .red
//        layer.cornerRadius = 10
//        contentView.backgroundColor = .yellow
//        contentView.layer.cornerRadius = 10

        contentView.addSubview(timeEditButton)
        timeEditButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(84)
            make.height.equalTo(30)
        }

        contentView.addSubview(timeTypeLabel)
        timeTypeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(timeEditButton.snp.leading).offset(-4)
            make.centerY.equalTo(timeEditButton)
            make.width.equalTo(22)
        }

        contentView.addSubview(addressEditButton)
        addressEditButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(timeTypeLabel.snp.leading).offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(34)
        }

        contentView.addSubview(xButton)
        xButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(timeEditButton.snp.top).offset(-7)
            make.width.equalTo(21)
        }

        // 경유지 추가 버튼 세팅
        contentView.addSubview(addButtonContainer)
        addButtonContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
        }
        addButtonContainer.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(107)
            make.height.equalTo(30)
        }
        addButtonContainer.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - 셀 컨텐츠 표시 관련 메서드
extension PointEditTableViewCell {

    // 경유지 추가 버튼 셀로 전환해주는 메서드 (반대도 가능)
    func setupStopoverAddButton(_ isEnable: Bool) {
        if isEnable {
            addButtonContainer.isHidden = false
            addressEditButton.isHidden = true
            timeTypeLabel.isHidden = true
            timeEditButton.isHidden = true
            xButton.isHidden = true
        } else {
            addButtonContainer.isHidden = true
            addressEditButton.isHidden = false
            timeTypeLabel.isHidden = false
            timeEditButton.isHidden = false
            xButton.isHidden = false
        }
    }

    // X 버튼 활성화 여부 메서드
    func setupXButton(_ isEnable: Bool) {
        if isEnable {
            xButton.isHidden = false
        } else {
            xButton.isHidden = true
        }
    }

    // 출발지일 경우에 맞춰 레이아웃을 재구성하는 메서드
    func remakeStartPointLayout() {
        addressEditButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
            make.trailing.equalTo(timeTypeLabel.snp.leading).offset(-20)
            make.height.equalTo(34)
        }
        timeEditButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.width.equalTo(84)
            make.height.equalTo(30)
        }
    }

    // 도착지일 경우에 맞춰 레이아웃을 재구성하는 메서드
    func remakeEndPointLayout() {
        addressEditButton.snp.remakeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(timeTypeLabel.snp.leading).offset(-20)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(34)
        }
        timeEditButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(84)
            make.height.equalTo(30)
        }
    }

    // [도착 시간]으로 변경
    func setupArrivalLabel() {
        timeTypeLabel.text = "도착"
    }
}

extension PointEditTableViewCell {

    // 시간 설정 버튼에 액션 연결
    @objc func timeEditButtonTapped(sender: UIButton) {
        pointEditTableViewCellDelegate?.timeEditButtonTapped(sender: sender)
    }

    // 주소 설정 버튼에 액션 연결
    @objc func addressEditButtonTapped(sender: UIButton) {
        pointEditTableViewCellDelegate?.addressEditButtonTapped(sender: sender, pointType: pointType, pointData: pointData ?? Point())
    }
}
