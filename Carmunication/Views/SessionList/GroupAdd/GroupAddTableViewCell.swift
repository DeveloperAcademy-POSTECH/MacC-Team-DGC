//
//  GroupAddTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

final class GroupAddTableViewCell: UITableViewCell {

    var index: CGFloat
    var cellCount: CGFloat

    // Add 셀 레이아웃
    let cellBackground = UIView()
    let stopPointImage = UIImageView(image: UIImage(named: "AddViewSidebarDot"))
    lazy var gradiantLine = GradientLineView(
        index: index,
        cellCount: cellCount,
        cornerRadius: 6.0
    )

    // Detail 셀 내부 레이블
    private let pointNameLabel = UILabel()
    let addressSearchButton = UIButton()
    let timeLabel = UILabel()
    let startTime: UIButton = {
        let startTime = UIButton()
        startTime.backgroundColor = UIColor(red: 0.877, green: 0.896, blue: 0.991, alpha: 1)
        startTime.layer.cornerRadius = 4
        startTime.setTitleColor(UIColor.black, for: .normal)
        startTime.setTitle("StartTime", for: .normal)

        return startTime
    }()

    // 탑승 크루 이미지 스택 변수
    private let boardingCrewLabel = UILabel()
    let crewImage = UIStackView()
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
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true // 너비를 30으로 설정
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true // 높이를 30으로 설정
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
        crewImage.alignment = .leading
        crewImage.distribution = .fillEqually

        pointNameLabel.text = "출발지"
        timeLabel.text = "출발 시간"
        boardingCrewLabel.text = "탑승 크루"
        // Font, TextColor 설정
        pointNameLabel.font = UIFont.carmuFont.subhead3
        pointNameLabel.textColor = UIColor.semantic.textPrimary
//        addressSearchButton.font = UIFont.carmuFont.subhead3
//        addressSearchButton.textColor = UIColor.semantic.textPrimary
//        detailAddress.font = UIFont.carmuFont.body1Long
//        detailAddress.textColor = UIColor.semantic.textBody
        boardingCrewLabel.font = UIFont.carmuFont.body1
        boardingCrewLabel.textColor = UIColor.theme.blue8
        timeLabel.font = UIFont.carmuFont.body1
        timeLabel.textColor = UIColor.theme.blue8
//        startTime.font = UIFont.carmuFont.subhead2
//        startTime.textColor = UIColor.semantic.accPrimary
        crewImage.backgroundColor = .blue
        // 뷰 추가
        contentView.addSubview(cellBackground)
        contentView.addSubview(gradiantLine)
        contentView.addSubview(stopPointImage)
        contentView.addSubview(pointNameLabel)
//        contentView.addSubview(pointName)
//        contentView.addSubview(detailAddress)
        contentView.addSubview(boardingCrewLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(startTime)
        contentView.addSubview(crewImage)
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

//        addressSearchButton.snp.makeConstraints { make in
//            make.leading.equalTo(pointNameLabel.snp.trailing).offset(8)
//            make.centerY.equalTo(pointNameLabel.snp.centerY)
//        }

//        detailAddress.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(48)
//            make.top.equalTo(pointName.snp.bottom).offset(4)
//            make.width.lessThanOrEqualTo(282)
//        }
//

        startTime.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20) // 원하는 상단 여백 설정
            make.trailing.equalToSuperview().inset(24) // 원하는 오른쪽 여백 설정
            make.width.equalTo(92) // 너비 설정
            make.height.equalTo(30) // 높이 설정
        }

        boardingCrewLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(45)
        }
//
        timeLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(crewImage.snp.trailing).offset(20)
            make.centerY.equalTo(boardingCrewLabel.snp.centerY)
        }
//
        crewImage.snp.makeConstraints { make in
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
