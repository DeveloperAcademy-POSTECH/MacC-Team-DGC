//
//  CrewInfoPassengerView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/07.
//

import UIKit

// MARK: - 마이페이지 하단 크루 정보 뷰 (동승자)
final class CrewInfoPassengerView: UIView {

    // 헤더라벨
    private let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "내가 탑승하는 셔틀 현황"
        headerLabel.font = UIFont.carmuFont.headline1
        headerLabel.textColor = UIColor.semantic.textPrimary
        headerLabel.textAlignment = .left
        return headerLabel
    }()

    private let container: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.semantic.backgroundDefault
        container.layer.cornerRadius = 16
        return container
    }()

    private let mainContentStackView: UIStackView = {
        let mainContentView = UIStackView()
        mainContentView.axis = .vertical
        mainContentView.alignment = .center
        mainContentView.spacing = 20
//        mainContentView.backgroundColor = .blue
        return mainContentView
    }()

    // 캐릭터 이미지
    private let characterImageView: UIImageView = {
        let characterImageView = UIImageView()
        characterImageView.image = UIImage(named: "VariantGradientStroke")
        characterImageView.contentMode = .scaleAspectFit
//        characterImageView.backgroundColor = .yellow
        return characterImageView
    }()

    // 셔틀 정보 스택
    private let shuttleInfoStackView: UIStackView = {
        let shuttleInfoStackView = UIStackView()
        shuttleInfoStackView.axis = .vertical
        shuttleInfoStackView.spacing = 8
        shuttleInfoStackView.alignment = .center
//        shuttleInfoStackView.backgroundColor = .red
        return shuttleInfoStackView
    }()

    // 셔틀 이름
    let shuttleNameLabel: UILabel = {
        let shuttleNameLabel = UILabel()
        shuttleNameLabel.text = "셔틀 이름"
        shuttleNameLabel.font = UIFont.carmuFont.headline1
        shuttleNameLabel.textColor = UIColor.semantic.accPrimary
        return shuttleNameLabel
    }()

    // 셔틀 상세정보
    let shuttleDetailLabel: UILabel = {
        let shuttleDetailLabel = UILabel()
        shuttleDetailLabel.text = "출발지 ~ 도착지"
        shuttleDetailLabel.font = UIFont.carmuFont.subhead1
        shuttleDetailLabel.textColor = UIColor.semantic.textTertiary
        return shuttleDetailLabel
    }()

    // 셔틀 나가기 버튼
    let exitCrewButton: UIButton = {
        let exitCrewButton = UIButton()
        let buttonFont = UIFont.carmuFont.subhead1
        var titleAttr = AttributedString(" 셔틀 나가기")
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
        self.backgroundColor = .clear
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
        }

        container.addSubview(mainContentStackView)
        mainContentStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(139)
        }

        mainContentStackView.addArrangedSubview(characterImageView)
        mainContentStackView.addArrangedSubview(shuttleInfoStackView)
        characterImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(67)
        }
        shuttleInfoStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }

        shuttleInfoStackView.addArrangedSubview(shuttleNameLabel)
        shuttleInfoStackView.addArrangedSubview(shuttleDetailLabel)

        addSubview(exitCrewButton)
        exitCrewButton.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct MyPageViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyPageViewController
    func makeUIViewController(context: Context) -> MyPageViewController {
        return MyPageViewController()
    }
    func updateUIViewController(_ uiViewController: MyPageViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct MyPageViewPreview: PreviewProvider {
    static var previews: some View {
        MyPageViewControllerRepresentable()
    }
}
