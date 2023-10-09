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

    // Add 셀 레이아웃
    private let cellBackground = UIView()
    private let stopPointImage = UIImageView(image: UIImage(named: "AddViewSidebarDot"))
    lazy var gradiantLine = GradientLineView(
        index: index,
        cellCount: cellCount,
        cornerRadius: 6.0
    )

    // Detail 셀 내부 레이블
    let pointNameLabel = UILabel()
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

    let timeLabel = UILabel()
    let startTime: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.backgroundTouchable!), for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("00:00 AM", for: .normal)
        button.isSpringLoaded = true

        return button
    }()

    // 탑승 크루 이미지 스택 변수
    private let boardingCrewLabel = UILabel()
    private let crewImageBackground = UIView()
    let crewImage = UIStackView()
    let crewImageButton = UIButton()
    var crewCount: Int = 0 {
        didSet {
            updateCrewImages()
        }
    }

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
        setupConstraints()
        setupCrewImageConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup function
    /**
     스택에 이미지를 추가하는 메서드
     */
    private func updateCrewImages() {

        // 스택뷰의 모든 서브뷰를 제거하여 이미지를 다시 추가
        for subview in crewImage.arrangedSubviews {
            crewImage.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        // TODO: - 3인 이상일 경우 외 2명 레이블 추가 표시
        // crewCount 값에 따라 이미지를 반복해서 추가
        for index in 0..<crewCount {
            let imageView = UIImageView(image: UIImage(named: "crewImageDefalut")) // 사용자 이미지로 이름 바꿔 사용
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true // 너비를 30으로 설정
            imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true // 높이를 30으로 설정
            crewImage.addArrangedSubview(imageView)

            if index > 2 { break }
        }
    }

    private func setupUI() {

        cellBackground.backgroundColor = UIColor.semantic.backgroundDefault
        cellBackground.layer.cornerRadius = 20
        cellBackground.layer.shadowOpacity = 0.2
        cellBackground.layer.shadowColor = UIColor.theme.blue6?.cgColor
        cellBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellBackground.layer.shadowRadius = 6
        cellBackground.layer.masksToBounds = false

        stopPointImage.contentMode = .scaleAspectFill
        gradiantLine.draw(CGRect(x: 0, y: 0, width: 12, height: 114))

        // Crew Image 스택 관련 설정
        crewImage.axis = .horizontal
        crewImage.alignment = .center
        crewImage.distribution = .equalCentering

        crewImageBackground.layer.cornerRadius = 18
        crewImageBackground.backgroundColor = UIColor.semantic.backgroundTouchable

        pointNameLabel.text = "출발지"
        timeLabel.text = "도착시간"
        boardingCrewLabel.text = "탑승자"

        // Font, TextColor 설정
        pointNameLabel.font = UIFont.carmuFont.subhead3
        pointNameLabel.textColor = UIColor.semantic.textPrimary
        boardingCrewLabel.font = UIFont.carmuFont.body1
        boardingCrewLabel.textColor = UIColor.theme.blue8
        timeLabel.font = UIFont.carmuFont.body1
        timeLabel.textColor = UIColor.theme.blue8

        // 뷰 추가
        contentView.addSubview(cellBackground)
        contentView.addSubview(gradiantLine)
        contentView.addSubview(stopPointImage)
        contentView.addSubview(pointNameLabel)
        contentView.addSubview(addressSearchButton)
        contentView.addSubview(stopoverPointRemoveButton)
        contentView.addSubview(boardingCrewLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(startTime)
        contentView.addSubview(crewImageBackground)
        contentView.addSubview(crewImage)
        contentView.addSubview(crewImageButton)
    }

    private func setupConstraints() {
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
        startTime.snp.makeConstraints { make in
            make.centerY.equalTo(boardingCrewLabel.snp.centerY) // 원하는 상단 여백 설정
            make.trailing.equalToSuperview().inset(20) // 원하는 오른쪽 여백 설정
            make.width.equalTo(92) // 너비 설정
            make.height.equalTo(30) // 높이 설정
        }

        boardingCrewLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(45)
        }

        timeLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(crewImage.snp.trailing).offset(2)
            make.trailing.lessThanOrEqualTo(startTime.snp.leading).offset(-4)
            make.centerY.equalTo(boardingCrewLabel.snp.centerY)
        }
    }

    private func setupCrewImageConstraint() {
        crewImage.snp.makeConstraints { make in
            make.centerY.equalTo(boardingCrewLabel.snp.centerY)
            make.leading.equalTo(boardingCrewLabel.snp.trailing).offset(12)
            make.width.equalTo(80)
            make.height.equalTo(32)
        }

        crewImageBackground.snp.makeConstraints { make in
            make.centerY.equalTo(boardingCrewLabel.snp.centerY)
            make.leading.equalTo(boardingCrewLabel.snp.trailing).offset(4)
            make.width.equalTo(96)
            make.height.equalTo(32)
        }

        crewImageButton.snp.makeConstraints { make in
            make.centerY.equalTo(boardingCrewLabel.snp.centerY)
            make.leading.equalTo(boardingCrewLabel.snp.trailing).offset(4)
            make.width.equalTo(96)
            make.height.equalTo(32)
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
