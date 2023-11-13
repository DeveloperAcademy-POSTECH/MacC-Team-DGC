//
//  CrewEditView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import UIKit

import SnapKit

// MARK: - 마이페이지(운전자) 크루 편집 뷰
final class CrewEditView: UIView {

    // 반복 요일 설정 버튼
    private let repeatDayEditButton: UIButton = {
        let repeatDayEditButton = UIButton()
        // 폰트 및 텍스트 설정
        let textFont = UIFont.carmuFont.subhead2
        var titleAttr = AttributedString("  반복")
        titleAttr.font = textFont
        titleAttr.foregroundColor = UIColor.semantic.textBody
        // SF Symbol 설정
        let symbolFont = UIFont.boldSystemFont(ofSize: 20) // TODO: - 정확한 폰트 확인 필요
        let symbolConfiguration = UIImage.SymbolConfiguration(font: symbolFont)
        let symbolImage = UIImage(systemName: "calendar", withConfiguration: symbolConfiguration)

        // 버튼 Configuration 설정
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttr
        config.image = symbolImage
        config.imagePlacement = .leading
        config.background.cornerRadius = 17
        config.baseBackgroundColor = UIColor.semantic.backgroundSecond
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 12,
            bottom: 5,
            trailing: 12
        )
        config.baseForegroundColor = UIColor.semantic.accPrimary
        repeatDayEditButton.configuration = config
        return repeatDayEditButton
    }()

    // 좌측 경로 표시 선
    private let colorLine = CrewMakeUtil.createColorLineView()
    // 출발지 ~ 도착지 포인트들에 대한 설정 뷰를 쌓을 스택 뷰
    private let pointStackView: UIStackView = {
        let pointStackView = UIStackView()
        pointStackView.axis = .vertical
        pointStackView.distribution = .equalCentering
        pointStackView.backgroundColor = .yellow
        return pointStackView
    }()
    private let startPoint = PointEditView(originalAddress: "추울발", originalArrivalTime: Date())
    private let endPoint = PointEditView(originalAddress: "도착맨", originalArrivalTime: Date())
    private lazy var stopover1 = PointEditView(originalAddress: "경유1", originalArrivalTime: Date(), hasXButton: true)
    private lazy var stopover2 = PointEditView(originalAddress: "등유2", originalArrivalTime: Date(), hasXButton: true)
    private lazy var stopover3 = PointEditView(originalAddress: "휘발유3", originalArrivalTime: Date(), hasXButton: true)
    private let stopoverAddButton = StopoverPointAddButtonView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.semantic.backgroundDefault
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(repeatDayEditButton)
        addSubview(colorLine)
        addSubview(pointStackView)
        pointStackView.addArrangedSubview(startPoint)
        pointStackView.addArrangedSubview(stopover1)
        pointStackView.addArrangedSubview(stopover2)
        pointStackView.addArrangedSubview(stopover3)
        pointStackView.addArrangedSubview(endPoint)
        addSubview(stopoverAddButton)
    }

    private func setupConstraints() {
        repeatDayEditButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(20)
        }

        colorLine.snp.makeConstraints { make in
            make.top.equalTo(repeatDayEditButton.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(pointStackView)
        }

        pointStackView.snp.makeConstraints { make in
            make.top.equalTo(colorLine)
            make.leading.equalTo(colorLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(179)
        }

        startPoint.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        endPoint.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CrewEditViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CrewEditViewController
    func makeUIViewController(context: Context) -> CrewEditViewController {
        return CrewEditViewController(userCrewData: crewData!) // 프리뷰라서 강제 바인딩 했습니다.
    }
    func updateUIViewController(_ uiViewController: CrewEditViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct CrewEditViewPreview: PreviewProvider {
    static var previews: some View {
        CrewEditViewControllerRepresentable()
    }
}
