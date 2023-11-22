//
//  CrewInfoCheckView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/10.
//

import UIKit

import SnapKit

// MARK: - 마이페이지(운전자) 크루 정보 확인 뷰
final class CrewInfoCheckView: UIView {

    // 상단 크루 이름
    let crewNameLabel: UILabel = {
        let crewNameLabel = CrewMakeUtil.carmuCustomLabel(
            text: "운좋은 카풀팟",
            font: UIFont.carmuFont.display1,
            textColor: UIColor.semantic.textPrimary ?? .black
        )
        return crewNameLabel
    }()

    // 크루명 편집하기 버튼
    // TODO: - MyPageView와 중복 -> 재사용 컴포넌트로 분리하기
    // TODO: - 동작 구현 필요
    let crewNameEditButton: UIButton = {
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
    let daySelectButton: UIButton = {
        let daySelectButton = UIButton()

        let buttonFont = UIFont.carmuFont.subhead3
        var titleAttr = AttributedString("")
        titleAttr.font = buttonFont
        titleAttr.foregroundColor = UIColor.semantic.textBody

        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttr
        config.background.cornerRadius = 15
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 4,
            leading: 12,
            bottom: 4,
            trailing: 12
        )
        config.baseBackgroundColor = UIColor.semantic.backgroundSecond
        daySelectButton.configuration = config

        return daySelectButton
    }()

    // 크루 정보 확인 화면 중앙 컨테이너 스택
    private let containerStack: UIStackView = {
        let containerStack = UIStackView()
        containerStack.axis = .horizontal
        containerStack.spacing = 12
        return containerStack
    }()

    // 왼쪽 경로 표시 줄
    private let colorLine = CrewMakeUtil.createColorLineView()

    // 경로를 쌓을 스택
    var locationCellStack: UIStackView = {
        let locationCellStack = UIStackView()
        locationCellStack.axis = .vertical
        locationCellStack.distribution = .equalSpacing
        return locationCellStack
    }()

    // 크루 나가기 버튼
    // TODO: - CrewInfoPassengerView와 중복 -> 재사용 컴포넌트로 분리하기
    // TODO: - 동작 구현 필요
    let exitCrewButton: UIButton = {
        let exitCrewButton = UIButton()
        let buttonFont = UIFont.carmuFont.subhead1
        var titleAttr = AttributedString(" 크루 나가기")
        titleAttr.font = buttonFont
        let symbolConfiguration = UIImage.SymbolConfiguration(font: buttonFont)
        let symbolImage = UIImage(systemName: "x.circle.fill", withConfiguration: symbolConfiguration)

        // 버튼 Configuration 설정
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttr
        config.image = symbolImage
        config.imagePlacement = .leading
        config.background.cornerRadius = 16
        config.baseBackgroundColor = UIColor.semantic.backgroundDefault
        config.baseForegroundColor = UIColor.semantic.negative
        let verticalPad: CGFloat = 8.0
        let horizontalPad: CGFloat = 12.0
        config.contentInsets = NSDirectionalEdgeInsets(
            top: verticalPad,
            leading: horizontalPad,
            bottom: verticalPad,
            trailing: horizontalPad
        )
        exitCrewButton.configuration = config
        // 그림자 설정
        exitCrewButton.layer.shadowColor = UIColor.theme.blue6?.cgColor
        exitCrewButton.layer.shadowOpacity = 0.2
        exitCrewButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        exitCrewButton.layer.shadowRadius = 8
        return exitCrewButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.semantic.backgroundDefault
        setupUI()
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
            make.top.equalTo(safeAreaLayoutGuide).inset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        addSubview(crewNameEditButton)
        crewNameEditButton.snp.makeConstraints { make in
            make.top.equalTo(crewNameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
        }

        addSubview(daySelectButton)
        daySelectButton.snp.makeConstraints { make in
            make.top.equalTo(crewNameEditButton.snp.bottom).offset(24)
            make.trailing.equalToSuperview().inset(20)
        }

        addSubview(exitCrewButton)
        exitCrewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(52)
        }

        addSubview(containerStack)
        containerStack.addArrangedSubview(colorLine)
        containerStack.addArrangedSubview(locationCellStack)
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(daySelectButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(exitCrewButton.snp.top).offset(-40)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct CrewInfoCheckViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CrewInfoCheckViewController
    func makeUIViewController(context: Context) -> CrewInfoCheckViewController {
        return CrewInfoCheckViewController(crewData: dummyCrewData!)
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
