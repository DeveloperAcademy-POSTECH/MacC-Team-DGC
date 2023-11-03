//
//  CodeShareView.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class CodeShareView: UIView {

    private lazy var secondLineTitleStack = UIStackView()

    private lazy var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "카풀을 같이 하는 사람들에게")
    private lazy var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "초대코드를 공유")
    private lazy var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "해주세요")

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("카풀 시작하기", for: .normal)
        button.backgroundColor = UIColor.semantic.accPrimary
        button.titleLabel?.font = UIFont.carmuFont.headline2
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.setBackgroundImage(
            UIImage(color: UIColor.semantic.textSecondary ?? .white),
            for: .highlighted
        )
        button.layer.cornerRadius = 30

        return button
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

    private func setupViews() {
        secondLineTitleStack.axis = .horizontal

        secondLineTitleStack.addArrangedSubview(titleLabel2)
        secondLineTitleStack.addArrangedSubview(titleLabel3)

        addSubview(titleLabel1)
        addSubview(secondLineTitleStack)
        addSubview(nextButton)
    }

    private func setAutoLayout() {
        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(36)
            make.leading.equalToSuperview().inset(20)
        }

        secondLineTitleStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.leading.equalToSuperview().inset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
}

// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct CodeShareViewPreview: PreviewProvider {
    static var previews: some View {
        CSViewControllerRepresentable()
    }
}
