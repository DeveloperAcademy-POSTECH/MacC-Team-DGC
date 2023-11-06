//
//  CrewInfoNoCrewView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/06.
//

import UIKit

final class CrewInfoNoCrewView: UIView {

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.semantic.backgroundDefault
        return contentView
    }()

    private let noCrewStackView: UIStackView = {
        let noCrewStackView = UIStackView()
        noCrewStackView.axis = .vertical
        noCrewStackView.spacing = 20
//        noCrewStackView.alignment = .center
        return noCrewStackView
    }()

    // 캐릭터 이미지 뷰
    private let characterImageView: UIImageView = {
        let characterImageView = UIImageView()
        characterImageView.image = UIImage(named: "LoadingCharacterRed")
        characterImageView.contentMode = .scaleAspectFit
        return characterImageView
    }()

    // 크루 없음 라벨
    private let noCrewLabel: UILabel = {
        let noCrewLabel = UILabel()
        noCrewLabel.text = "아직 참여중인\n크루가 없어요"
        noCrewLabel.font = UIFont.carmuFont.headline1
        noCrewLabel.textColor = UIColor.semantic.textPrimary
        return noCrewLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
//        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }

    private func setupUI() {
        addSubview(contentView)
        contentView.addSubview(noCrewStackView)
        noCrewStackView.addArrangedSubview(characterImageView)
        noCrewStackView.addArrangedSubview(noCrewLabel)
    }

    func setupConstraints() {
        noCrewStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
        characterImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(67)
        }
        noCrewLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
}
