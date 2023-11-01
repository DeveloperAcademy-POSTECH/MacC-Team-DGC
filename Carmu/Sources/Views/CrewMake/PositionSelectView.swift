//
//  PositionSelectView.swift
//  Carmu
//
//  Created by 김동현 on 11/1/23.
//

import UIKit

import SnapKit

final class PositionSelectView: UIView {

    private var skipButton: UIButton = {
        let skipButton = UIButton()
        skipButton.setTitle("건너뛰기", for: .normal)
        skipButton.setTitleColor(UIColor.semantic.accPrimary, for: .normal)
        skipButton.setTitleColor(UIColor.theme.gray4, for: .highlighted)
        return skipButton
    }()

    private var titleLabel1 = CrewMakeUtil.defalutTitle(titleText: "함께하는 ")
    private var titleLabel2 = CrewMakeUtil.accPrimaryTitle(titleText: "카풀")
    private var titleLabel3 = CrewMakeUtil.defalutTitle(titleText: "에서의")
    private var titleLabel4 = CrewMakeUtil.accPrimaryTitle(titleText: "포지션")
    private var titleLabel5 = CrewMakeUtil.defalutTitle(titleText: "을 설정해주세요")

    var selectDriverButton: UIButton = {

    }()

    var selectDriverButton: UIButton = {

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

    func setupViews() {
        addSubview(skipButton)
        addSubview(titleLabel1)
        addSubview(titleLabel2)
        addSubview(titleLabel3)
        addSubview(titleLabel4)
        addSubview(titleLabel5)
    }

    func setAutoLayout() {
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            make.right.equalToSuperview().offset(-20)
        }

        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(78)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(titleLabel5.snp.top)
        }

        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1)
            make.left.equalTo(titleLabel1.snp.right)
            make.bottom.equalTo(titleLabel5.snp.top)
        }

        titleLabel3.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2)
            make.left.equalTo(titleLabel2.snp.right)
            make.bottom.equalTo(titleLabel5.snp.top)
        }

        titleLabel4.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom)
            make.left.equalToSuperview().offset(20)
        }

        titleLabel5.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom)
            make.left.equalTo(titleLabel4.snp.right)
        }
    }
}

extension PositionSelectView {
    private func 
}
// Preview
import SwiftUI

@available(iOS 13.0.0, *)
struct PositionSelectViewPreview: PreviewProvider {
    static var previews: some View {
        PositionSelectViewControllerRepresentable()
    }
}
