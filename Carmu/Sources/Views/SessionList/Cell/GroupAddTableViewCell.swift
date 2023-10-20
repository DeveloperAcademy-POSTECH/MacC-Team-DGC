//
//  GroupAddTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

final class GroupAddTableViewCell: UITableViewCell {

    private let index: CGFloat
    private let cellCount: CGFloat
    lazy var gradiantLine = GradientLineView(
        index: index,
        cellCount: cellCount,
        cornerRadius: 6.0
    )

    // Add 셀 레이아웃
    private let cellBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundDefault
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.theme.blue6?.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 6
        view.layer.masksToBounds = false

        return view
    }()

    private let stopPointImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AddViewSidebarDot")
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    let pointNameLabel: UILabel = {
        let label = UILabel()
        label.text = "출발지"
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.textPrimary

        return label
    }()

    let addressSearchButton = {
        let button = UIButton(type: .system)
        button.setTitle("     주소를 검색하세요", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.body2Long
        button.setTitleColor(UIColor.semantic.textPrimary, for: .normal)
        button.layer.borderColor = UIColor.theme.blue3?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.contentHorizontalAlignment = .left
        button.isSpringLoaded = true

        return button
    }()

    let stopoverPointRemoveButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(named: "stopoverRemove")
        button.setBackgroundImage(buttonImage, for: .normal)
        return button
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "도착시간"
        label.font = UIFont.carmuFont.body1
        label.textColor = UIColor.theme.blue8

        return label
    }()

    let startTime: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.backgroundTouchable!), for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("오후 12:00 ", for: .normal)
        button.isSpringLoaded = true

        return button
    }()

    // 탑승 크루 이미지 스택 변수
    let boardingCrewLabel: UILabel = {
        let label = UILabel()
        label.text = "탑승자"
        label.font = UIFont.carmuFont.body1
        label.textColor = UIColor.theme.blue8

        return label
    }()

    let crewImageButton = CrewImageButton()

    init(
        index: CGFloat,
        cellCount: CGFloat,
        style: UITableViewCell.CellStyle = .default,
        reuseIdentifier: String? = nil
    ) {
        self.index = index
        self.cellCount = cellCount
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTopComponentConstraints()
        setupBottomComponentConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup function
extension GroupAddTableViewCell {

    private func setupUI() {
        gradiantLine.draw(CGRect(x: 0, y: 0, width: 12, height: 114))

        contentView.addSubview(cellBackground)
        contentView.addSubview(gradiantLine)
        contentView.addSubview(stopPointImage)
        contentView.addSubview(pointNameLabel)
        contentView.addSubview(addressSearchButton)
        contentView.addSubview(stopoverPointRemoveButton)
        contentView.addSubview(boardingCrewLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(startTime)
        contentView.addSubview(crewImageButton)
    }

    private func setupTopComponentConstraints() {
        cellBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 0, bottom: 14, right: 6))
            make.height.equalTo(114)
        }

        gradiantLine.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.bottom.equalToSuperview().inset(14)
            make.leading.equalToSuperview()
            make.width.lessThanOrEqualTo(12)
        }

        stopPointImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(3)
            make.width.height.lessThanOrEqualTo(6)
        }

        pointNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cellBackground.snp.top).inset(20)
            make.leading.equalToSuperview().inset(24)
        }

        addressSearchButton.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(200)
            make.leading.equalTo(pointNameLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(pointNameLabel.snp.centerY)
        }

        stopoverPointRemoveButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(25)
        }
    }

    private func setupBottomComponentConstraints() {
        boardingCrewLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(45)
        }

        crewImageButton.snp.makeConstraints { make in
            make.centerY.equalTo(boardingCrewLabel.snp.centerY)
            make.leading.equalTo(boardingCrewLabel.snp.trailing).offset(4)
            make.width.equalTo(96)
            make.height.equalTo(32)
        }

        startTime.snp.makeConstraints { make in
            make.centerY.equalTo(boardingCrewLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(92)
            make.height.equalTo(30)
        }

        timeLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(crewImageButton.snp.trailing).offset(2)
            make.trailing.lessThanOrEqualTo(startTime.snp.leading).offset(-4)
            make.centerY.equalTo(boardingCrewLabel.snp.centerY)
        }
    }
}

import SwiftUI

@available(iOS 13.0.0, *)
struct GroupAddTableViewCellPreview: PreviewProvider {

    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }
}
