//
//  TimeSelectModalView.swift
//  Carmu
//
//  Created by 김동현 on 11/5/23.
//

import UIKit

import SnapKit

final class TimeSelectModalView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "시간을 설정해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이전 장소보다 더 늦은 시간이어야 설정할 수 있어요."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        let backgroundImage = UIImage(named: "stopoverRemove")
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()

    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.timeZone = .autoupdatingCurrent
        picker.locale = Locale(identifier: "ko_KR") // 오전/오후로 표시하게 하는 코드
        return picker
    }()

    let saveButton = NextButton(buttonTitle: "시간 설정하기")

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
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(closeButton)
        addSubview(timePicker)
        addSubview(saveButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().inset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(28)
        }

        timePicker.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.bottom.equalTo(saveButton.snp.top).offset(-32)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(36)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.greaterThanOrEqualTo(200)
            make.height.equalTo(60)
        }
    }
}
