//
//  NotFoundCrewTableViewCell.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/03.
//

import UIKit

final class NotFoundCrewTableViewCell: UITableViewCell {

    let firstLineLabel = UILabel()
    let secondLineLabel = UILabel()
    let labelStack = UIStackView()
    let borderLayer = CAShapeLayer()

    // MARK: - 기본 override function
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupDashLine()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
        setupDashLine()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        borderLayer.frame = self.bounds
        borderLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20).cgPath
    }

    // MARK: - UI Setup function
    private func setupUI() {
        firstLineLabel.text = "아직 속해 있는 크루가 없습니다."
        secondLineLabel.text = "새 크루를 만들어보세요!"
        firstLineLabel.font = UIFont.carmuFont.headline1
        firstLineLabel.textColor = UIColor.semantic.textBody
        secondLineLabel.font = UIFont.carmuFont.headline1
        secondLineLabel.textColor = UIColor.semantic.textBody

        labelStack.axis = .vertical
        labelStack.addArrangedSubview(firstLineLabel)
        labelStack.addArrangedSubview(secondLineLabel)
        labelStack.alignment = .center
        contentView.addSubview(labelStack)
    }

    private func setupConstraints() {
        labelStack.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    private func setupDashLine() {
        borderLayer.strokeColor = UIColor.theme.blue3?.cgColor
        borderLayer.lineDashPattern = [4, 4] // 점선 설정
        borderLayer.frame = self.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(borderLayer)
    }
}
