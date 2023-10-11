//
//  FriendDetailView.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/11.
//

import UIKit

final class FriendDetailView: UIView {

    // MARK: - 상단 유저 정보 뷰
    lazy var conicGradientView: UIView = {
        let conicGradientView = UIView()
        return conicGradientView
    }()
    // TODO: - 그라데이션 정확한 값 알아내서 표현하기
    lazy var conicGradientLayer: CAGradientLayer = {
        let conicGradientLayer = CAGradientLayer()
        conicGradientLayer.type = .conic
        conicGradientLayer.colors = [
            UIColor.semantic.accSecondary?.cgColor ?? UIColor.green.cgColor,
            UIColor.semantic.accPrimary?.cgColor ?? UIColor.blue.cgColor
        ]
        conicGradientLayer.locations = [0.2, 1.0]
        conicGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        conicGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        return conicGradientLayer
    }()
    lazy var blurView: CustomIntensityVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = CustomIntensityVisualEffectView(effect: blurEffect, intensity: 0.4)
        return blurView
    }()

    // MARK: - 친구 정보 스택
    lazy var friendInfoStack: UIStackView = {
        let friendInfoStack = UIStackView()
        friendInfoStack.axis = .vertical
        friendInfoStack.alignment = .leading
        return friendInfoStack
    }()
    // MARK: - 친구 닉네임
    lazy var friendNickname: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "홍길동"
        nicknameLabel.font = UIFont.carmuFont.display1
        nicknameLabel.textColor = UIColor.semantic.textSecondary
        return nicknameLabel
    }()
    // MARK: - 친구 칭호
    lazy var friendTitle: UILabel = {
        let friendTitle = UILabel()
        friendTitle.text = "제법 동고동락한 크루"
        friendTitle.font = UIFont.carmuFont.body3
        friendTitle.textColor = UIColor.semantic.textSecondary
        return friendTitle
    }()
    // MARK: - 함께한 여정 배지
    lazy var distanceBadge: UIView = {
        let distanceBadge = UIView()
        distanceBadge.backgroundColor = UIColor.theme.white
        distanceBadge.layer.cornerRadius = 16.56
        return distanceBadge
    }()
    lazy var distanceLabelStack: UIStackView = {
        let distanceLabelStack = UIStackView()
        distanceLabelStack.axis = .horizontal
        distanceLabelStack.alignment = .center
        return distanceLabelStack
    }()
    lazy var distanceLabel1: UILabel = {
        let distanceLabel1 = UILabel()
        distanceLabel1.text = "함께한 여정"
        distanceLabel1.font = UIFont.carmuFont.body1
        distanceLabel1.textColor = UIColor.semantic.accPrimary
        return distanceLabel1
    }()
    lazy var distanceLabel2: UILabel = {
        let distanceLabel2 = UILabel()
        distanceLabel2.text = "2000km"
        distanceLabel2.font = UIFont.carmuFont.subhead2
        distanceLabel2.textColor = UIColor.semantic.accPrimary
        return distanceLabel2
    }()

    // MARK: - 친구 프로필 이미지
    lazy var friendImage: UIImageView = {
        let friendImage = UIImageView()
        let image = UIImage(named: "profile")
        friendImage.contentMode = .scaleAspectFit
        friendImage.image = image
        return friendImage
    }()

    // MARK: - 하단 마음 표현 추천 뷰
    lazy var recommendGiftView: UIView = {
        let recommendGiftView = UIView()
        recommendGiftView.backgroundColor = UIColor.semantic.backgroundDefault
        recommendGiftView.layer.cornerRadius = 16
        return recommendGiftView
    }()
    lazy var recommendDescription: UILabel = {
        let recommendDescription = UILabel()
        recommendDescription.text = "아래와 같이 마음 표현을 추천해드려요"
        recommendDescription.font = UIFont.carmuFont.headline1
        recommendDescription.textColor = UIColor.semantic.textPrimary
        return recommendDescription
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

    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = conicGradientView.bounds
        conicGradientLayer.frame = conicGradientView.bounds
    }

    func setupViews() {
        addSubview(conicGradientView)
        addSubview(blurView)
        addSubview(friendInfoStack)
        addSubview(recommendGiftView)
        addSubview(friendImage)

        conicGradientView.layer.addSublayer(conicGradientLayer)

        friendInfoStack.addArrangedSubview(friendNickname)
        friendInfoStack.addArrangedSubview(friendTitle)
        friendInfoStack.addArrangedSubview(distanceBadge)

        distanceBadge.addSubview(distanceLabelStack)
        distanceLabelStack.addArrangedSubview(distanceLabel1)
        distanceLabelStack.addArrangedSubview(distanceLabel2)

        recommendGiftView.addSubview(recommendDescription)
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
        conicGradientView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(303)
        }
        friendInfoStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().inset(36)
            make.trailing.equalToSuperview()
            make.height.equalTo(114)
        }
        friendNickname.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(friendTitle.snp.top).offset(-4)
        }
        friendTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(distanceBadge.snp.top).offset(-20)
        }
        distanceBadge.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(141)
            make.height.equalTo(30)
        }
        distanceLabelStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        friendImage.snp.makeConstraints { make in
            make.width.height.equalTo(137)
            make.trailing.equalToSuperview().inset(36)
            make.top.equalTo(recommendGiftView.snp.top).offset(-74)
        }
        recommendGiftView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(conicGradientView.snp.bottom).offset(-20)
        }
        recommendDescription.snp.makeConstraints { make in
            make.top.equalTo(friendImage.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FriendDetailViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FriendDetailViewController
    func makeUIViewController(context: Context) -> FriendDetailViewController {
        return FriendDetailViewController()
    }
    func updateUIViewController(_ uiViewController: FriendDetailViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct FriendDetailViewPreview: PreviewProvider {
    static var previews: some View {
        FriendDetailViewControllerRepresentable()
    }
}

class CustomIntensityVisualEffectView: UIVisualEffectView {

    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
        animator.fractionComplete = intensity
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: Private
    private var animator: UIViewPropertyAnimator!

}

//class GiftCardView: UIView {
//
//    private let giftImageView: UIImageView = {
//        let giftImageView = UIImageView()
//        giftImageView.contentMode = .scaleAspectFit
//        return giftImageView
//    }()
//
//    private let distanceLabel: UILabel = {
//        let distanceLabel = UILabel()
//        distanceLabel.textColor = .red
//        return distanceLabel
//    }()
//
//    private let giftNameLabel: UILabel = {
//        let giftNameLabel = UILabel()
//        giftNameLabel.textColor = .green
//        return giftNameLabel
//    }()
//
//    init(img: String, distance: Int, giftName: String) {
//        super.init(frame: .zero)
//        setupViews()
//        setAutoLayout()
//
//        if let giftImage = UIImage(named: img) {
//            giftImageView.image = giftImage
//        }
//
//        distanceLabel.text = "\(distance)km"
//        giftNameLabel.text = giftName
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    func setupViews() {
//        self.backgroundColor = .gray
//
//        addSubview(giftImageView)
//        addSubview(distanceLabel)
//        addSubview(giftNameLabel)
//    }
//
//    func setAutoLayout() {
//        giftImageView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().inset(28.5)
//            make.width.equalTo(72)
//            make.height.equalTo(68)
//        }
//        distanceLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(giftImageView.snp.bottom).offset(8)
//        }
//        giftNameLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(distanceLabel.snp.bottom).offset(4)
//        }
//    }
//}
