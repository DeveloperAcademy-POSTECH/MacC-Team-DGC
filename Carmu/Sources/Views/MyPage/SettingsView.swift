//
//  SettingsView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/08.
//

import UIKit

final class SettingsView: UIView {

    // MARK: - 설정 화면 테이블 뷰
    lazy var settingsTableView: UITableView = {
        let settingsTableView = UITableView(frame: self.bounds, style: .insetGrouped)
        return settingsTableView
    }()

    // 앱 이름 라벨
    lazy var appNameLabel: UILabel = {
        let appNameLabel = UILabel()
        appNameLabel.text = "Carmu"
        appNameLabel.textAlignment = .center
        appNameLabel.textColor = .gray
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return appNameLabel
    }()

    // 앱 버전 라벨
    lazy var appVersionLabel: UILabel = {
        let appVersionLabel = UILabel()
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = "앱 버전 \(appVersion)"
        } else {
            appVersionLabel.text = "앱 버전 정보를 찾을 수 없습니다."
        }
        appVersionLabel.textAlignment = .center
        appVersionLabel.textColor = .lightGray
        appVersionLabel.font = UIFont.systemFont(ofSize: 14)
        return appVersionLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        setupUI()
    }

    func setupUI() {
        addSubview(settingsTableView)
        settingsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(appVersionLabel)
        appVersionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(48)
        }

        addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(appVersionLabel.snp.top).offset(-8)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct SettingsViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = SettingsViewController
    func makeUIViewController(context: Context) -> SettingsViewController {
        return SettingsViewController()
    }
    func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct SettingsViewPreview: PreviewProvider {

    static var previews: some View {
        SettingsViewControllerRepresentable()
    }
}
