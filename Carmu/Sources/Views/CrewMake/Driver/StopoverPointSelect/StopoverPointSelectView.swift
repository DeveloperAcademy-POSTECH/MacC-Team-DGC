//
//  StopoverPointSelect.swift
//  Carmu
//
//  Created by 김동현 on 11/8/23.
//

import UIKit

import SnapKit

final class StopoverPointSelectView: UIView {

    private let firstLineTitleStack = UIStackView()
    private let titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "크루원들의 ")
    private let titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "경유지")
    private let titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "를")
    let titleLabel5 = CrewMakeUtil.defalutTitle(titleText: "설정해주세요")

    let colorLine = CrewMakeUtil.createColorLineView()
    let startPointView: UILabel = {
        let label = UILabel()
        label.text = "출발지 주소"
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textTertiary
        return label
    }()
    let stopoverStackView = UIStackView()
    let stopover1 = AddressSelectButtonView(textFieldTitle: "경유지 1")
    lazy var stopover2 = AddressSelectButtonView(
        textFieldTitle: "경유지 2",
        hasXButton: true
    )
    lazy var stopover3 = AddressSelectButtonView(
        textFieldTitle: "경유지 3",
        hasXButton: true
    )
    let stopoverAddButton = StopoverPointAddButtonView()
    let endPointView: UILabel = {
        let label = UILabel()
        label.text = "도착지 주소"
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textTertiary
        return label
    }()

    let nextButton = NextButton(buttonTitle: "다음")

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
}

// MARK: - setup UI
extension StopoverPointSelectView {

    private func setupUI() {
        firstLineTitleStack.axis = .horizontal
        stopoverStackView.axis = .vertical
        stopoverStackView.distribution = .equalSpacing

        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)
        stopoverStackView.addArrangedSubview(stopover1)
        stopoverStackView.addArrangedSubview(stopover2)
        stopoverStackView.addArrangedSubview(stopover3)

        stopover2.label.isHidden = true
        stopover2.button.isHidden = true
        stopover3.label.isHidden = true
        stopover3.button.isHidden = true

        addSubview(firstLineTitleStack)
        addSubview(titleLabel5)
        addSubview(colorLine)
        addSubview(startPointView)
        addSubview(stopoverStackView)
        addSubview(stopoverAddButton)
        addSubview(endPointView)
        addSubview(nextButton)
    }

    private func setupConstraints() {
        setAutoLayoutTop()
        setAutoLayoutBottom()
    }

    private func setAutoLayoutTop() {
        firstLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(36)
            make.leading.equalToSuperview().inset(20)
        }

        titleLabel5.snp.makeConstraints { make in
            make.top.equalTo(firstLineTitleStack.snp.bottom)
            make.leading.equalToSuperview().inset(20)
        }

        colorLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel5.snp.bottom).offset(30)
            make.bottom.equalTo(stopover2).offset(30)
            make.leading.equalToSuperview().inset(20)
        }

        startPointView.snp.makeConstraints { make in
            make.top.equalTo(colorLine).offset(2)
            make.leading.equalTo(colorLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(32)
        }
    }

    private func setAutoLayoutBottom() {
        stopoverStackView.snp.makeConstraints { make in
            make.top.equalTo(startPointView.snp.bottom).offset(30)
            make.bottom.equalTo(nextButton.snp.top).offset(-90)
            make.leading.equalTo(colorLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(32)
        }

        stopoverAddButton.snp.makeConstraints { make in
            make.bottom.equalTo(endPointView.snp.top).offset(-12)
            make.leading.trailing.equalTo(stopoverStackView)
        }

        stopover1.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(64)
        }

        stopover2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
        }

        stopover3.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
        }

        endPointView.snp.makeConstraints { make in
            make.bottom.equalTo(colorLine).offset(-2)
            make.leading.equalTo(colorLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(32)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct StopoverPointSelectViewPreview: PreviewProvider {
    static var previews: some View {
        SOPViewControllerRepresentable()
    }
}
