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
        settingsTableView.backgroundColor = .clear
        settingsTableView.separatorColor = UIColor.semantic.stoke
        return settingsTableView
    }()

    // 앱 이름 라벨
    lazy var appLogoView: UIImageView = {
        let appLogoView = UIImageView()
        if let appLogo = UIImage(named: "appLogo") {
            appLogoView.contentMode = .scaleAspectFit
            appLogoView.image = appLogo
        }
        return appLogoView
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
        appVersionLabel.textColor = UIColor.theme.blue3
        appVersionLabel.font = UIFont.carmuFont.subhead1
        return appVersionLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
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

        addSubview(appLogoView)
        appLogoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appVersionLabel.snp.top).offset(-12)
            make.height.equalTo(18)
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
