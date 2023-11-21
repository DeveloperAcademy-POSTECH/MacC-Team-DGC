//
//  CrewScrollView.swift
//  Carmu
//
//  Created by 허준혁 on 11/11/23.
//

import UIKit

final class CrewScrollView: UIScrollView {

    private var dataSource: [MemberStatus]? {
        didSet { bind() }
    }

    private lazy var stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        showsHorizontalScrollIndicator = false
        bounces = false

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bind() {
        guard let members = dataSource else { return }

        // 모든 탑승자 제거한 후 다시 세팅
        stackView.removeAllArrangedSubviews()

        for member in members {
            let view = UIView()
            view.snp.makeConstraints { make in
                make.width.equalTo(48)
            }

            let timeLabel = UILabel()
            switch member.status {
            case .decline, .waiting, .sessionStart, .none:
                timeLabel.text = "포기"
                timeLabel.textColor = UIColor.semantic.textEnabled
            case .accept:
                timeLabel.text = "+\(member.lateTime)분"
                timeLabel.textColor = member.lateTime > 0 ? UIColor.semantic.negative : UIColor.semantic.accPrimary
            }
            timeLabel.font = UIFont.carmuFont.subhead3
            view.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
            }

            let crewImage = UIImageView(image: UIImage(profileImageColor: ProfileImageColor(rawValue: member.profileColor ?? "") ?? .blue))
            view.addSubview(crewImage)
            crewImage.snp.makeConstraints { make in
                make.top.equalTo(timeLabel.snp.bottom).offset(4)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(crewImage.snp.width)
            }

            let crewName = UILabel()
            crewName.text = member.nickname
            crewName.font = UIFont.carmuFont.body3
            crewName.textColor = UIColor.semantic.textTertiary
            view.addSubview(crewName)
            crewName.snp.makeConstraints { make in
                make.top.equalTo(crewImage.snp.bottom).offset(4)
                make.centerX.equalToSuperview()
            }

            stackView.addArrangedSubview(view)
        }
    }

    func setDataSource(dataSource: [MemberStatus]) {
        self.dataSource = dataSource
    }
}
