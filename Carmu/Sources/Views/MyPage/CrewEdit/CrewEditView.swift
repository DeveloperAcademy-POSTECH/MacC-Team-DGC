//
//  CrewEditView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import UIKit

// MARK: - 마이페이지(운전자) 크루 정보 확인 뷰
final class CrewEditView: UIView {

    // 반복 요일 설정 버튼
    private let repeatDayEditButton: UIButton = {
        let repeatDayEditButton = UIButton()
        // 폰트 및 텍스트 설정
        let textFont = UIFont.carmuFont.subhead2
        var titleAttr = AttributedString("  반복")
        titleAttr.font = textFont
        titleAttr.foregroundColor = UIColor.semantic.textBody
        // SF Symbol 설정
        let symbolFont = UIFont.boldSystemFont(ofSize: 20) // TODO: - 정확한 폰트 확인 필요
        let symbolConfiguration = UIImage.SymbolConfiguration(font: symbolFont)
        let symbolImage = UIImage(systemName: "calendar", withConfiguration: symbolConfiguration)

        // 버튼 Configuration 설정
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttr
        config.image = symbolImage
        config.imagePlacement = .leading
        config.background.cornerRadius = 17
        config.baseBackgroundColor = UIColor.semantic.backgroundSecond
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 12,
            bottom: 5,
            trailing: 12
        )
        config.baseForegroundColor = UIColor.semantic.accPrimary
        repeatDayEditButton.configuration = config
        return repeatDayEditButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.semantic.backgroundDefault
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(repeatDayEditButton)
        repeatDayEditButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CrewEditViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CrewEditViewController
    func makeUIViewController(context: Context) -> CrewEditViewController {
        return CrewEditViewController(userCrewData: crewData!) // 프리뷰라서 강제 바인딩 했습니다.
    }
    func updateUIViewController(_ uiViewController: CrewEditViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct CrewEditViewPreview: PreviewProvider {
    static var previews: some View {
        CrewEditViewControllerRepresentable()
    }
}
