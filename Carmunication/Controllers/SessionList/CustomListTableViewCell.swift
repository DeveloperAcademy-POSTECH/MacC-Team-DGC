//
//  CustomListTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

// MARK: - Preview canvas 세팅
import SwiftUI

final class CustomListTableViewCell: UITableViewCell {

    // CustomListTableViewCell의 상단 레이블, 이미지
    let isCaptainBadge = UIImageView(image: UIImage(named: "ImCaptainButton"))
    let groupName = UILabel()
    let chevronLabel = UIImageView(image: UIImage(systemName: "chevron.right"))

    // CustomListTableViewCell의 왼쪽 하단 레이블
    let startPointLabel = UILabel()
    let directionLabel = UILabel()
    let endPointLabel = UILabel()
    let startTimeTextLabel = UILabel()
    let startTimeLabel = UILabel()

    // CustomListTableViewCell의 오른쪽 하단 이미지 스택
    let elipseImage = UIImageView(image: UIImage(named: "elipse"))
    let crewImage = UIStackView()
    var crewCount: Int = 0 {
        didSet {
            updateCrewImages()
        }
    }

    // MARK: - Override Function
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        self.backgroundColor = UIColor.semantic.backgroundSecond
        self.layer.cornerRadius = 16
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
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
            let imageView = UIImageView(image: UIImage(named: "CrewImageDefalut")) // 사용자 이미지로 이름 바꿔 사용
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            crewImage.addArrangedSubview(imageView)

            if index > 2 { break }
        }
    }

    private func setupUI() {
        // 기본 레이블 텍스트 세팅
        startTimeTextLabel.text = "출발 시간: "
        directionLabel.text = "→"

        // image ContentMode 설정
        isCaptainBadge.contentMode = .scaleAspectFill

        // Crew Image 스택 관련 설정
        crewImage.axis = .horizontal
        crewImage.spacing = -12 // 이미지 간격 조절
        crewImage.alignment = .leading
        crewImage.distribution = .fillEqually

        // Font, TextColor 설정
        groupName.font = UIFont.carmuFont.subhead3
        groupName.textColor = UIColor.semantic.textPrimary
        chevronLabel.tintColor = UIColor.semantic.accPrimary
        startPointLabel.font = UIFont.carmuFont.subhead2
        startPointLabel.textColor = UIColor.semantic.accPrimary
        endPointLabel.font = UIFont.carmuFont.subhead2
        endPointLabel.textColor = UIColor.semantic.accPrimary
        startTimeTextLabel.textColor = UIColor.theme.darkblue6
        startTimeTextLabel.font = UIFont.carmuFont.body2
        startTimeLabel.font = UIFont.carmuFont.subhead2
        startTimeLabel.textColor = UIColor.semantic.accPrimary
        directionLabel.font = UIFont.carmuFont.body2
        directionLabel.textColor = UIColor.theme.darkblue6

        contentView.addSubview(isCaptainBadge)
        contentView.addSubview(groupName)
        contentView.addSubview(chevronLabel)
        contentView.addSubview(startPointLabel)
        contentView.addSubview(directionLabel)
        contentView.addSubview(endPointLabel)
        contentView.addSubview(startTimeTextLabel)
        contentView.addSubview(startTimeLabel)
        contentView.addSubview(crewImage)
    }

    private func setupConstraints() {
        let padding: CGFloat = 20
        let imageLabelSpacing: CGFloat = 8

        isCaptainBadge.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(16)
            make.width.equalTo(45)
        }

        groupName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(isCaptainBadge.snp.trailing).offset(imageLabelSpacing)
            make.centerY.equalTo(isCaptainBadge.snp.centerY)
        }

        chevronLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }

        startTimeTextLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(padding)
            make.leading.equalToSuperview().inset(padding)
        }

        startTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(isCaptainBadge.snp.trailing).offset(15)
            make.centerY.equalTo(startTimeTextLabel.snp.centerY)
        }

        startPointLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.bottom.equalTo(startTimeTextLabel.snp.top).offset(-4)
            make.width.lessThanOrEqualTo(100)
        }

        directionLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(startPointLabel.snp.trailing).offset(4)
            make.centerY.equalTo(startPointLabel.snp.centerY)
        }

        endPointLabel.snp.makeConstraints { make in
            make.leading.equalTo(directionLabel.snp.trailing).offset(4)
            make.centerY.equalTo(startPointLabel.snp.centerY)
            make.width.lessThanOrEqualTo(100)
        }

        crewImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(30)
            make.width.equalTo(84)
        }
    }
}
