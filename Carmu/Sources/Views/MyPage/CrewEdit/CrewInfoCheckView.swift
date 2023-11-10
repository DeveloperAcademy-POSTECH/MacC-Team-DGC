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
    // TODO: - MyPageView와 중복 -> 재사용 컴포넌트로 분리하기
    // TODO: - 동작 구현 필요
    private let crewNameEditButton: UIButton = {
        let crewNameEditButton = UIButton()
        // 폰트 설정
        let buttonFont = UIFont.systemFont(ofSize: 12)
        // 버튼 텍스트 설정
        var titleAttr = AttributedString("크루명 편집하기 ")
        titleAttr.font = buttonFont
        // SF Symbol 설정
        let symbolConfiguration = UIImage.SymbolConfiguration(font: buttonFont)
        let symbolImage = UIImage(systemName: "pencil", withConfiguration: symbolConfiguration)

        // 버튼 Configuration 설정
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttr
        config.image = symbolImage
        config.imagePlacement = .trailing
        config.background.cornerRadius = 12
        config.baseBackgroundColor = UIColor.theme.blueTrans20
        config.baseForegroundColor = UIColor.semantic.textTertiary
        let verticalPad: CGFloat = 4.0
        let horizontalPad: CGFloat = 8.0
        config.contentInsets = NSDirectionalEdgeInsets(
            top: verticalPad,
            leading: horizontalPad,
            bottom: verticalPad,
            trailing: horizontalPad
        )
        crewNameEditButton.configuration = config

        return crewNameEditButton
    }()

    // 요일 확인 라벨
    let daySelectButton: DaySelectButton = {
        let button = DaySelectButton(buttonTitle: "")
        button.backgroundColor = UIColor.semantic.backgroundSecond
        button.setTitleColor(UIColor.semantic.textBody, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.contentHorizontalAlignment = .center
        return button
    }()

    // 크루 정보 확인 화면 중앙 컨테이너 스택
    private let containerStack = UIStackView()
    // 왼쪽 경로 표시 줄
    private let colorLine = CrewMakeUtil.createColorLineView()
    // 경로를 쌓을 스택
    private var customTableStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.semantic.backgroundDefault
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
        addSubview(crewNameLabel)
        crewNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        addSubview(crewNameEditButton)
        crewNameEditButton.snp.makeConstraints { make in
            make.top.equalTo(crewNameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
        }

        addSubview(daySelectButton)
        daySelectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
        }
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
