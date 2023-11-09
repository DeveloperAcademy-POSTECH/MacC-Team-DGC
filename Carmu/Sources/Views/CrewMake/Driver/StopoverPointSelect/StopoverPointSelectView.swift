//
//  StopoverPointSelect.swift
//  Carmu
//
//  Created by 김동현 on 11/8/23.
//

import UIKit

import SnapKit

final class StopoverPointSelectView: UIView {

    private lazy var firstLineTitleStack = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "크루원들의 ")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "경유지")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "를")
    private lazy var titleLabel5 = CrewMakeUtil.defalutTitle(titleText: "설정해주세요")

    private lazy var colorLine = CrewMakeUtil.createColorLineView()

    let startPointView: UILabel = {
        let label = UILabel()
        label.text = "출발지 주소"
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.textTertiary
        return label
    }()

    let stopoverStackView = UIStackView()
    let stopover1 = AddressSelectButtonView(textFieldTitle: "경유지 1")
    var stopover2: UIView = StopoverPointAddButtonView()
    var stopover3: UIView?

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
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        firstLineTitleStack.axis = .horizontal
        stopoverStackView.axis = .vertical
        stopoverStackView.distribution = .equalSpacing

        firstLineTitleStack.addArrangedSubview(titleLabel1)
        firstLineTitleStack.addArrangedSubview(titleLabel2)
        firstLineTitleStack.addArrangedSubview(titleLabel3)
        stopoverStackView.addArrangedSubview(stopover1)
        stopoverStackView.addArrangedSubview(stopover2)

        if let stopover3 = stopover3 {
            stopoverStackView.addArrangedSubview(stopover3)
        }

        addSubview(firstLineTitleStack)
        addSubview(titleLabel5)
        addSubview(colorLine)
        addSubview(startPointView)
        addSubview(stopoverStackView)
        addSubview(endPointView)
        addSubview(nextButton)
    }

    private func setupConstraints() {
        setAutoLayout1()
        setAutoLayout2()
    }

    private func setAutoLayout1() {
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
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(314)
        }

        startPointView.snp.makeConstraints { make in
            make.top.equalTo(colorLine).offset(2)
            make.leading.equalTo(colorLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(32)
        }
    }

    private func setAutoLayout2() {
        stopoverStackView.snp.makeConstraints { make in
            make.top.equalTo(startPointView.snp.bottom).offset(20)
            make.bottom.equalTo(endPointView.snp.top).offset(-40)
            make.leading.equalTo(colorLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(32)
        }

        stopover1.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(64)
        }

        stopover2.snp.makeConstraints { make in
            make.top.equalTo(stopover1.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        if let stopover3 = stopover3 {
            stopover3.snp.makeConstraints { make in
                make.top.equalTo(stopover2.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(60)
            }
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
