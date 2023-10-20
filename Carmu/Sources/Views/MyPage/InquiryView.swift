//
//  InquiryView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/09.
//

import UIKit

final class InquiryView: UIView {

    // MARK: - 문의하기 화면 테이블 뷰
    lazy var inquiryTableView: UITableView = {
        let inquiryTableView = UITableView(frame: self.bounds, style: .insetGrouped)
        return inquiryTableView
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
        addSubview(inquiryTableView)
        inquiryTableView.snp.makeConstraints { make in
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

struct InquiryViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = InquiryViewController
    func makeUIViewController(context: Context) -> InquiryViewController {
        return InquiryViewController()
    }
    func updateUIViewController(_ uiViewController: InquiryViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct InquiryViewPreview: PreviewProvider {
    static var previews: some View {
        InquiryViewControllerRepresentable()
    }
}
