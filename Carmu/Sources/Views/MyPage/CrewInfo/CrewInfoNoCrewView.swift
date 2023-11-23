//
//  CrewInfoNoCrewView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/06.
//

import UIKit

// MARK: - 마이페이지 하단 크루 정보 뷰 (크루가 없을 때)
final class CrewInfoNoCrewView: UIView {

    private let noCrewStackView: UIStackView = {
        let noCrewStackView = UIStackView()
        noCrewStackView.axis = .vertical
        noCrewStackView.spacing = 20
        noCrewStackView.alignment = .center
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
        noCrewLabel.numberOfLines = 0
        noCrewLabel.font = UIFont.carmuFont.headline1
        noCrewLabel.textColor = UIColor.semantic.textPrimary
        noCrewLabel.textAlignment = .center
        return noCrewLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setupUI() {
        addSubview(noCrewStackView)
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
