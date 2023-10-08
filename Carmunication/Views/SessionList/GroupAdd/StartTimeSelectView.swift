//
//  StartTimeSelectView.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

import SnapKit

final class StartTimeSelectView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "시간을 설정해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "해당 위치의 출발 또는 도착 예정 시간을 변경합니다"
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

    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.timeZone = .autoupdatingCurrent
        picker.locale = Locale(identifier: "ko_KR") // 오전/오후로 표시하게 하는 코드
        return picker
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.accPrimary!), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.theme.white, for: .normal)

        return button
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(closeButton)
        addSubview(timePicker)
        addSubview(saveButton)

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

// MARK: - Previewer
import SwiftUI

@available(iOS 13.0.0, *)
struct StartTimeViewPreview: PreviewProvider {

    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }

}
