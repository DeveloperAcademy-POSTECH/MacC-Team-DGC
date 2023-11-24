//
//  PrivacyViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/01.
//

import SafariServices
import UIKit

final class PrivacyViewController: UIViewController {

    private let privacyView = PrivacyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        navigationController?.navigationBar.topItem?.title = "" // 백버튼 텍스트 제거

        view.addSubview(privacyView)
        privacyView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        privacyView.privacyButton.addTarget(self, action: #selector(setPrivacyURLLink), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "개인정보 처리방침"
    }

    // 개인정보 처리방침 링크 연결
    @objc private func setPrivacyURLLink() {
        let privacyUrl = NSURL(string: "https://www.notion.so/dfab0cb08b5a49f2b740ebea31443c45?pvs=4")
        guard let privacyUrl = privacyUrl else { return }
        let privacySafariView: SFSafariViewController? = SFSafariViewController(url: privacyUrl as URL)
        guard let privacySafariView = privacySafariView else { return }
        present(privacySafariView, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct PrivacyViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PrivacyViewController
    func makeUIViewController(context: Context) -> PrivacyViewController {
        return PrivacyViewController()
    }
    func updateUIViewController(_ uiViewController: PrivacyViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct PrivacyViewPreview: PreviewProvider {
    static var previews: some View {
        PrivacyViewControllerRepresentable()
    }
}
