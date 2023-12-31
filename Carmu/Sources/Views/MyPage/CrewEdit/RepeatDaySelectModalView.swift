//
//  RepeatDaySelectModalView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/14.
//

import UIKit

import SnapKit

// MARK: - 반복 요일 설정 모달 뷰
final class RepeatDaySelectModalView: UIView {

    private let headerStack: UIStackView = {
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        return headerStack
    }()

    // 상단 헤더 라벨
    private let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "반복되는 요일을 선택해주세요"
        headerLabel.font = UIFont.carmuFont.headline2
        headerLabel.textColor = UIColor.semantic.textPrimary
        return headerLabel
    }()

    // 모달 닫기 버튼
    let closeButton: UIButton = {
        let closeButton = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .medium, scale: .large)
        let symbolImgae = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
        closeButton.setImage(symbolImgae, for: .normal)
        closeButton.backgroundColor = UIColor.theme.gray5
        closeButton.tintColor = UIColor.theme.gray8
        closeButton.layer.cornerRadius = 14
        closeButton.clipsToBounds = true
        return closeButton
    }()

    // 반복 요일 버튼 컬렉션 뷰
    let dayButtonCollectionView: UICollectionView = {
        let dayButtonCollectionVoew = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        dayButtonCollectionVoew.isScrollEnabled = false
        dayButtonCollectionVoew.backgroundColor = .clear
        return dayButtonCollectionVoew
    }()

    // 설정 저장 버튼
    let saveButton = NextButton(buttonTitle: "요일 설정하기")

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.semantic.backgroundDefault
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(headerStack)
        headerStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        headerStack.addArrangedSubview(headerLabel)
        headerStack.addArrangedSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(28)
        }

        addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(48)
        }

        addSubview(dayButtonCollectionView)
        dayButtonCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerStack.snp.bottom).offset(63)
            make.bottom.equalTo(saveButton.snp.top).offset(-63)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct RDSModalViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RepeatDaySelectModalViewController
    func makeUIViewController(context: Context) -> RepeatDaySelectModalViewController {
        return RepeatDaySelectModalViewController()
    }
    func updateUIViewController(_ uiViewController: RepeatDaySelectModalViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct RepeatDaySelectModalViewPreview: PreviewProvider {
    static var previews: some View {
        RDSModalViewControllerRepresentable()
    }
}
