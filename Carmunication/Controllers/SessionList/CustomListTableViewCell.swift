//
//  CustomListTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//
import SnapKit
import UIKit

// MARK: - Preview canvas 세팅
import SwiftUI

final class CustomListTableViewCell: UITableViewCell {

    let leftImageView = UIImageView(image: UIImage(named: "ImCaptainButton"))
    let titleLabel = UILabel()
    let rightImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    let startPointLabel = UILabel()
    let directionLabel = UILabel()
    let endPointLabel = UILabel()
    let startTimeTextLabel = UILabel()
    let startTimeLabel = UILabel()
    let crewImage = UIStackView()
    let elipseImage = UIImageView(image: UIImage(named: "elipse"))
    var crewCount: Int = 0 {
        didSet {
            updateCrewImages()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
    }

    private func updateCrewImages() {
        // 스택뷰의 모든 서브뷰를 제거하여 이미지를 다시 추가합니다.
        for subview in crewImage.arrangedSubviews {
            crewImage.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        // crewCount 값에 따라 이미지를 반복해서 추가합니다.
        for index in 0..<crewCount {
            let imageView = UIImageView(image: UIImage(named: "CrewImageDefalut")) // crewImage 대신 사용할 이미지 이름을 넣으세요.
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            crewImage.addArrangedSubview(imageView)

            if index > 2 { break }
        }
    }

    private func setupUI() {
        startTimeTextLabel.text = "출발 시간: "
        directionLabel.text = "→"

        // Customize crewImage (UIStackView)
        crewImage.axis = .horizontal
        crewImage.spacing = -12 // 이미지 간격 조절
        crewImage.alignment = .leading
        crewImage.distribution = .fillEqually

        contentView.addSubview(leftImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightImageView)
        contentView.addSubview(startPointLabel)
        contentView.addSubview(directionLabel)
        contentView.addSubview(endPointLabel)
        contentView.addSubview(startTimeTextLabel)
        contentView.addSubview(startTimeLabel)
        contentView.addSubview(crewImage)
        leftImageView.contentMode = .scaleAspectFill
        titleLabel.font = UIFont.carmuFont.subhead3
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
        rightImageView.tintColor = UIColor.semantic.accPrimary
        // Add any additional setup for your labels and image views here
        // For example, you can set font, text color, content mode, etc.
    }

    private func setupConstraints() {
        let padding: CGFloat = 20
        let imageLabelSpacing: CGFloat = 8

        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(16)
            make.width.equalTo(45)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(leftImageView.snp.trailing).offset(imageLabelSpacing)
            make.centerY.equalTo(leftImageView.snp.centerY)
        }

        rightImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }

        startTimeTextLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(padding)
            make.leading.equalToSuperview().inset(padding)
        }

        startTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(15)
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

struct CustomListTableViewCellRepresentable: UIViewControllerRepresentable {

    // Create a UIViewController that contains your UITableViewCell
    class UIViewControllerType: UIViewController {
        let tableViewCell = CustomListTableViewCell() // Initialize your custom cell
        override func viewDidLoad() {
            super.viewDidLoad()
            tableViewCell.titleLabel.text = "타이틀"
            view.addSubview(tableViewCell)
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            tableViewCell.frame = view.bounds
        }
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        return UIViewControllerType()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

@available(iOS 13.0.0, *)
struct CustomListTableViewCellPreview: PreviewProvider {

    static var previews: some View {
        CustomListTableViewCellRepresentable()
            .previewLayout(.fixed(width: 320, height: 134)) // Set an appropriate size
    }
}
