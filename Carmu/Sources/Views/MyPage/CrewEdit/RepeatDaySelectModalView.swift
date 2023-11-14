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
    // TODO: - 색 커스텀 방법 찾아보거나 이미지로 바꾸기
    let closeButton: UIButton = {
        let closeButton = UIButton(type: .close)
        closeButton.tintColor = .blue
        closeButton.setTitleColor(.red, for: .normal)
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
        setupConstraints()
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
            make.size.equalTo(24)
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

    private func setupConstraints() {
    }
}

// MARK: - 요일 버튼 셀
final class DayButtonCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "dayButtonCollectionViewCell"

    let dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.textColor = UIColor.semantic.textBody
        dayLabel.font = UIFont.carmuFont.headline2
        dayLabel.textAlignment = .center
        return dayLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        backgroundColor = UIColor.semantic.backgroundSecond
        setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.center.equalToSuperview()
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
