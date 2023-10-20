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

    // MARK: - 하단 앱 정보 스택 뷰
    lazy var appInfoStackView: UIStackView = {
        let appInfoStackView = UIStackView()
        appInfoStackView.axis = .vertical
        appInfoStackView.alignment = .center
        return appInfoStackView
    }()

    // 앱 이름 라벨
    lazy var appNamneLabel: UILabel = {
        let appNameLabel = UILabel()
        appNameLabel.text = "Carmu"
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
        setupViews()
        setAutoLayout()
    }

    func setupViews() {
        addSubview(inquiryTableView)
        addSubview(appInfoStackView)

        appInfoStackView.addArrangedSubview(appNamneLabel)
        appInfoStackView.addArrangedSubview(appVersionLabel)
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
        inquiryTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        appInfoStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(48)
        }
        appNamneLabel.snp.makeConstraints { make in
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
