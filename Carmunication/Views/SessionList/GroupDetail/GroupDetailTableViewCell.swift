//
//  GroupDetailTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/05.
//

import UIKit

class GroupDetailTableViewCell: UITableViewCell {

    var index: CGFloat
    var cellCount: CGFloat

    // Detail 셀 레이아웃
    let stopPointImage = UIImageView(image: UIImage(named: "StopPoint"))
    lazy var gradiantLine = GradientLineView(index: index, cellCount: cellCount)
    let cellBackground = UIView()

    // Detail 셀 내부 레이블
    let pointNameLabel = UILabel()
    let pointName = UILabel()
    let detailAddress = UILabel()
    let boardingCrewLabel = UILabel()
    let timeLabel = UILabel()

    // 탑승 크루 이미지 스택 변수
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

    required init?(coder aDecoder: NSCoder) {
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

        stopPointImage.contentMode = .scaleAspectFill
        gradiantLine.draw(CGRect(x: 0, y: 0, width: 2, height: 150))

        cellBackground.backgroundColor = UIColor.semantic.backgroundDefault
        cellBackground.layer.cornerRadius = 20
        cellBackground.layer.shadowOpacity = 0.2
        cellBackground.layer.shadowColor = UIColor.theme.blue6?.cgColor
        cellBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellBackground.layer.shadowRadius = 6
        cellBackground.layer.masksToBounds = false

        // Crew Image 스택 관련 설정
        crewImage.axis = .horizontal
        crewImage.alignment = .leading
        crewImage.distribution = .fillEqually

        // Font, TextColor 설정
        pointNameLabel.font = UIFont.carmuFont.subhead3
        pointNameLabel.textColor = UIColor.theme.blue8
        pointName.font = UIFont.carmuFont.subhead3
        pointName.textColor = UIColor.semantic.textPrimary
        detailAddress.font = UIFont.carmuFont.body1Long
        detailAddress.textColor = UIColor.semantic.textBody
        boardingCrewLabel.font = UIFont.carmuFont.subhead1
        boardingCrewLabel.textColor = UIColor.theme.blue8
        timeLabel.font = UIFont.carmuFont.subhead2
        timeLabel.textColor = UIColor.semantic.accPrimary

        // 뷰 추가
        contentView.addSubview(gradiantLine)
        contentView.addSubview(stopPointImage)
        contentView.addSubview(cellBackground)
        contentView.addSubview(pointNameLabel)
        contentView.addSubview(pointName)
        contentView.addSubview(detailAddress)
        contentView.addSubview(boardingCrewLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(crewImage)
    }

    private func setupConstraints() {

        gradiantLine.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
        }

        stopPointImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(1)
            make.width.height.lessThanOrEqualTo(16)
        }

        cellBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 28, bottom: 16, right: 6))
            make.height.equalTo(134)
        }

        pointNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.equalToSuperview().inset(48)
        }

        pointName.snp.makeConstraints { make in
            make.leading.equalTo(pointNameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(pointNameLabel.snp.centerY)
        }

        detailAddress.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(48)
            make.top.equalTo(pointName.snp.bottom).offset(4)
            make.width.lessThanOrEqualTo(282)
        }

        boardingCrewLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(48)
            make.bottom.equalToSuperview().inset(45)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(26)
            make.centerY.equalTo(pointNameLabel.snp.centerY)
        }

        crewImage.snp.makeConstraints { make in
            make.centerY.equalTo(boardingCrewLabel.snp.centerY)
            make.leading.equalTo(boardingCrewLabel.snp.trailing).offset(12)
            make.width.equalTo(105)
            make.height.equalTo(30)
        }
    }
}
