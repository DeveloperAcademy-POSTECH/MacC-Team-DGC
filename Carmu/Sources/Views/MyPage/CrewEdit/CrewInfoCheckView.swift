//
//  CrewInfoCheckView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/10.
//

import UIKit

// MARK: - 마이페이지(운전자) 크루 정보 확인 뷰
final class CrewInfoCheckView: UIView {

    // 상단 크루 이름
    private let crewNameLabel: UILabel = {
        let crewNameLabel = CrewMakeUtil.carmuCustomLabel(
            text: "크루 이름",
            font: UIFont.carmuFont.display1,
            textColor: UIColor.semantic.textPrimary ?? .black
        )
        return crewNameLabel
    }()

    // 크루명 편집하기 버튼

    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }

    func setupConstraints() {
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CrewInfoCheckViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CrewInfoCheckViewController
    func makeUIViewController(context: Context) -> CrewInfoCheckViewController {
        return CrewInfoCheckViewController()
    }
    func updateUIViewController(_ uiViewController: CrewInfoCheckViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct CrewInfoCheckViewPreview: PreviewProvider {
    static var previews: some View {
        CrewInfoCheckViewControllerRepresentable()
    }
}
