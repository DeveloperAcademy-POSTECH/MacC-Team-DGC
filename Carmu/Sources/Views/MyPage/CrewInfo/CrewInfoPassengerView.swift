//
//  CrewInfoPassengerView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/07.
//

import UIKit

// MARK: - 마이페이지 하단 크루 정보 뷰 (동승자)
final class CrewInfoPassengerView: UIView {

    // TODO: 크루와 함께한 거리 실제 데이터 반영 필요
    private let label1 = CrewMakeUtil.carmuCustomLabel(
        text: "내 크루와 함께한 여정은 ",
        font: UIFont.carmuFont.headline1,
        textColor: UIColor.semantic.textPrimary ?? .black
    )
    private let distanceLabel = CrewMakeUtil.carmuCustomLabel(
        text: "1234km",
        font: UIFont.carmuFont.headline1,
        textColor: UIColor.semantic.accPrimary ?? .blue
    )
    private let label2 = CrewMakeUtil.carmuCustomLabel(
        text: " 입니다",
        font: UIFont.carmuFont.headline1,
        textColor: UIColor.semantic.textPrimary ?? .black
    )
    private lazy var crewInfoHeaderLabelStack: UIStackView = {
        let crewInfoHeaderStackView = UIStackView()
        crewInfoHeaderStackView.axis = .horizontal
        return crewInfoHeaderStackView
    }()

    private let crewInfoBodyLabel = CrewMakeUtil.carmuCustomLabel(
        text: "감사의 마음을 아래와 같이 표현해 보면 어떨까요?",
        font: UIFont.carmuFont.body3Long,
        textColor: UIColor.semantic.textBody ?? .gray
    )

    // 선물 추천 뷰
    private let recommendGiftView: UIView = {
        let recommendGiftView = UIView()
        recommendGiftView.backgroundColor = .clear
        recommendGiftView.layer.cornerRadius = 16
        recommendGiftView.layer.borderColor = UIColor.semantic.stoke?.cgColor
        recommendGiftView.layer.borderWidth = 1
        return recommendGiftView
    }()

    let giftCollectionView: UICollectionView = {
        let giftCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        giftCollectionView.backgroundColor = .clear
        return giftCollectionView
    }()

    // 크루 나가기 버튼
    private let exitCrewButton: UIButton = {
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
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(crewInfoHeaderLabelStack)
        crewInfoHeaderLabelStack.addArrangedSubview(label1)
        crewInfoHeaderLabelStack.addArrangedSubview(distanceLabel)
        crewInfoHeaderLabelStack.addArrangedSubview(label2)

        addSubview(crewInfoBodyLabel)
        addSubview(recommendGiftView)
        recommendGiftView.addSubview(giftCollectionView)

        addSubview(exitCrewButton)
    }

    private func setupConstraints() {
        crewInfoHeaderLabelStack.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(28)
        }
        crewInfoBodyLabel.snp.makeConstraints { make in
            make.top.equalTo(crewInfoHeaderLabelStack.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
        }
        recommendGiftView.snp.makeConstraints { make in
            make.top.equalTo(crewInfoBodyLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(146)
        }
        giftCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(146)
        }
        exitCrewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
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
