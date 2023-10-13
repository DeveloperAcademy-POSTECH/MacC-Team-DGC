//
//  SessionStartMidView.swift
//  Carmunication
//
//  Created by 김태형 on 2023/10/12.
//

import UIKit

import SnapKit

final class SessionStartMidView: UIView {

    let groupNameView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.blue8
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    let groupNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.carmuFont.headline1
        lbl.textAlignment = .center
        lbl.text = "---"
        return lbl
    }()
    let whiteCircleImageViewLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .white
        return imageView
    }()
    let whiteCircleImageViewRight: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .white
        return imageView
    }()

    // 기존의 journeySummaryView와 동일
    let summaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    // 오늘의 날짜
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.theme.darkblue4
        lbl.font = UIFont.carmuFont.body2Long
        return lbl
    }()

    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.blue3
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setTodayDate()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        setTodayDate()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let padding = summaryView.frame.height / 5
        lineView.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().inset(padding)
        }
    }

    private func setupUI() {

        addSubview(groupNameView)

        groupNameView.addSubview(groupNameLabel)
        groupNameView.addSubview(whiteCircleImageViewLeft)
        groupNameView.addSubview(whiteCircleImageViewRight)

        addSubview(summaryView)

        summaryView.addSubview(dateLabel)
        summaryView.addSubview(lineView)
    }

    private func setupConstraints() {

        groupNameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        groupNameLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        whiteCircleImageViewLeft.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalTo(groupNameLabel)
            make.width.height.equalTo(10)
        }
        whiteCircleImageViewRight.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(groupNameLabel)
            make.width.height.equalTo(10)
        }

        summaryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.lessThanOrEqualTo(groupNameLabel.snp.bottom).inset(-12)
            make.bottom.lessThanOrEqualToSuperview().inset(20).priority(.high)
            make.bottom.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.top.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        lineView.snp.makeConstraints { make in
            make.leading.trailing.lessThanOrEqualToSuperview().inset(20)
            make.height.equalTo(1)
        }
    }

    private func setTodayDate() {

        let today = Date()
        let formattedDate = Date.formattedDate(from: today)
        dateLabel.text = formattedDate
    }
}
