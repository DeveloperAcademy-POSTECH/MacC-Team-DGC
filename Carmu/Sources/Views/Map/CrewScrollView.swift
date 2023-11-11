//
//  CrewScrollView.swift
//  Carmu
//
//  Created by 허준혁 on 11/11/23.
//

import UIKit

final class CrewScrollView: UIScrollView {

    var dataSource: [UserIdentifier]? {
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

    func configure() {
        showsHorizontalScrollIndicator = false
        bounces = false

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bind() {
        // TODO: - 실제 데이터 받아서 처리
        for time in 0..<8 {
            let view = UIView()
            view.snp.makeConstraints { make in
                make.width.equalTo(48)
            }

            let timeLabel = UILabel()
            timeLabel.text = "+\(time)분"
            timeLabel.font = UIFont.carmuFont.subhead3
            timeLabel.textColor = UIColor.semantic.negative
            view.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
            }

            let crewImage = UIImageView(image: UIImage(profileImageColor: .blue))
            view.addSubview(crewImage)
            crewImage.snp.makeConstraints { make in
                make.top.equalTo(timeLabel.snp.bottom).offset(4)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(crewImage.snp.width)
            }

            let crewName = UILabel()
            crewName.text = "홍길동"
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
}
