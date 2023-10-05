//
//  GroupDetailView.swift
//  Carmunication
//
//  Created by 허준혁 on 10/5/23.
//

import UIKit

final class GroupDetailView: UIView {

    var selectedGroup: DummyGroup?

    /**
     Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
     */
    lazy var mainStack = {
        let stackView = selectedGroup?.isDriver ?? false ? driverBottomButtonStack : crewBottomButtonStack
        let mainStackView = UIStackView(arrangedSubviews: [distanceLabel, stackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        return mainStackView
    }()

    /**
     운전자일 경우 표시되는 Button Stack
     */
    lazy var editButton = {
        buttonComponent("수정 하기", 130, 40, .blue, .cyan)
    }()

    lazy var driverBottomButtonStack = {
        let button1 = buttonComponent("그만 두기", 130, 40, .blue, .cyan)

        let stackView = UIStackView(arrangedSubviews: [button1, spacer(), editButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill

        return stackView
    }()

    /**
     크루일 경우 표시되는 Button Stack
     */
    lazy var quitButton = {
        buttonComponent("그만 두기", .greatestFiniteMagnitude, 60, .blue, .cyan)
    }()

    lazy var crewBottomButtonStack = {
        let stackView = UIStackView(arrangedSubviews: [quitButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    /**
     주행거리 표시 라벨
     */
    lazy var distanceLabel = {
        let label1 = UILabel()
        let label2 = UILabel()
        label1.text = "크루가 함께한 주행거리"
        label2.text = "\("0000") km"

        let stackView = UIStackView(arrangedSubviews: [label1, spacer(), label2])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview().inset(50)
        }
    }

    /**
     이 뷰에서 사용되는 buttonComponent
     */
    private func buttonComponent(
        _ title: String,
        _ width: CGFloat,
        _ height: CGFloat,
        _ fontColor: UIColor,
        _ backgroundColor: UIColor
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(fontColor, for: .normal)
        button.setBackgroundImage(.pixel(ofColor: backgroundColor), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true

        button.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }

        return button
    }

    private func spacer() -> UIView {
        let spacerView = UIView()
        return spacerView
    }
}
