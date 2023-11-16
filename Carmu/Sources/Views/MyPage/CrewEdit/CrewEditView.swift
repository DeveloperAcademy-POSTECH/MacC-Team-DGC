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
    let repeatDayEditButton: UIButton = {
        let repeatDayEditButton = UIButton()

        // 폰트 및 텍스트 설정
        let textFont = UIFont.carmuFont.subhead2
        var titleAttr = AttributedString("  반복")
        titleAttr.font = textFont
        titleAttr.foregroundColor = UIColor.semantic.textBody
        // SF Symbol 설정
        let symbolFont = UIFont.boldSystemFont(ofSize: 20) // TODO: - 피그마랑 모양이 좀 달라서 정확한 폰트 확인 필요
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
    let colorLine = CrewMakeUtil.createColorLineView()

    // 경로 편집 테이블 뷰
    let pointEditTableView: UITableView = {
        let pointEditTableView = UITableView()
        pointEditTableView.backgroundColor = .gray
        pointEditTableView.separatorStyle = .none
        pointEditTableView.isScrollEnabled = false
        return pointEditTableView
    }()

    // 경유지 추가 버튼
    let stopoverAddButton = StopoverPointAddButtonView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.semantic.backgroundDefault
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        // 반복요일 버튼
        addSubview(repeatDayEditButton)
        repeatDayEditButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(34)
        }

        // 컬러라인
        addSubview(colorLine)
        colorLine.snp.makeConstraints { make in
            make.top.equalTo(repeatDayEditButton.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(179)
        }

        addSubview(pointEditTableView)
        pointEditTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(colorLine)
            make.leading.equalTo(colorLine.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
        }
        
    }
}
