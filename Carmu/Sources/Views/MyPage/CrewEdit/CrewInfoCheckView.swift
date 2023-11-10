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
    private let containerStack: UIStackView = {
        let containerStack = UIStackView()
        containerStack.axis = .horizontal
        containerStack.spacing = 12
        return containerStack
    }()

    // 왼쪽 경로 표시 줄
    private let colorLine = CrewMakeUtil.createColorLineView()

    // 경로를 쌓을 스택
    private var locationCellStack: UIStackView = {
        let locationCellStack = UIStackView()
        locationCellStack.axis = .vertical
        locationCellStack.distribution = .equalSpacing
        return locationCellStack
    }()

    // 각 경로 셀
    lazy var locationCellArray: [StopoverSelectButton] = {
        var buttons: [StopoverSelectButton] = []

        // TODO: - 크루의 경유지 데이터로 바꿔줘야 함
        for (index, address) in ["출발지 주소", "경유지1 주소", "경유지2 주소", "도착지 주소"].enumerated() {
            // TODO: 들어오는 데이터에 맞춰 변형될 수 있도록 변경해야 함.
            let isStart = (index==3) ? false : true
            let button = StopoverSelectButton(address: address, isStart, time: Date())
            button.layer.shadowColor = UIColor.clear.cgColor
            button.tag = index
            button.isEnabled = false
            buttons.append(button)
        }
        return buttons
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
        for locationCell in locationCellArray {
            locationCellStack.addArrangedSubview(locationCell)
        }
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(crewNameEditButton.snp.bottom).offset(70) // TODO: - 카풀 요일 라벨에 맞추기
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
