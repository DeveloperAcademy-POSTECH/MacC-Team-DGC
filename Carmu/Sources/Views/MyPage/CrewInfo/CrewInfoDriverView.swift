//
//  CrewInfoDriverView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/06.
//

import UIKit

// MARK: - 마이페이지 하단 크루 정보 뷰 (운전자)
final class CrewInfoDriverView: UIView {

    // 크루 관리 테이블 뷰 제목
    private let crewManageTitleLabel: UILabel = {
        let crewManageTitleLabel = UILabel()
        crewManageTitleLabel.text = "크루 관리"
        crewManageTitleLabel.font = UIFont.carmuFont.headline1
        crewManageTitleLabel.textColor = UIColor.semantic.textPrimary
        crewManageTitleLabel.textAlignment = .left
        return crewManageTitleLabel
    }()

    // 크루 관리 테이블 뷰
    lazy var crewManageTableView: UITableView = {
        let crewManageTableView = UITableView(frame: self.bounds, style: .grouped)
        return crewManageTableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(crewManageTitleLabel)
        crewManageTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8.78)
            make.top.trailing.equalToSuperview()
        }

        addSubview(crewManageTableView)
        crewManageTableView.snp.makeConstraints { make in
            make.top.equalTo(crewManageTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
