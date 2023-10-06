//
//  GroupDetailViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

final class GroupDetailViewController: UIViewController {

    var selectedGroup: DummyGroup?

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainStackView = topLabelStack()
        let pointTableView = tableViewComponent()
        let crewExitButton = buttonComponent(
            buttonWidth: .greatestFiniteMagnitude,
            buttonHeight: 60
        )

        navigationBarSetting()
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        view.addSubview(pointTableView)
        view.addSubview(crewExitButton)

        mainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }

        pointTableView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(20) // mainStackView 바로 아래에 20 포인트 간격으로 배치
            make.leading.trailing.equalToSuperview().inset(20)
        }

        crewExitButton.snp.makeConstraints { make in
            make.top.equalTo(pointTableView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
        }
    }
}

// MARK: - TableView 관련 Delegate 메서드
extension GroupDetailViewController: UITableViewDataSource, UITableViewDelegate {

    private func tableViewComponent() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupDetailTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedGroup?.stopoverPoint.count == 0 ? 2 : (2 + (selectedGroup?.stopoverPoint.count ?? 0))
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GroupDetailTableViewCell(
            index: CGFloat(indexPath.row),
            cellCount: CGFloat((selectedGroup?.stopoverPoint.count ?? 0) + 2)
        )
        // TODO: - 셀 데이터 입력 부분. 리팩토링 필요
        cell.crewCount = 3
        cell.pointNameLabel.text = {
            switch indexPath.row {
            case 0:
                return "출발지"
            case (selectedGroup?.stopoverPoint.count ?? 0) + 1:
                return "도착지"
            default:
                return "경유지 \(indexPath.row)"
            }
        }()
        cell.pointName.text = {
            switch indexPath.row {
            case 0:
                return "출발지의 대표 명칭"
            case (selectedGroup?.stopoverPoint.count ?? 0) + 1:
                return "도착지의 대표 명칭"
            default:
                return "경유지 \(indexPath.row)의 대표명칭"
            }
        }()
        cell.timeLabel.text = "00:00 AM"
        cell.detailAddress.text = {
            switch indexPath.row {
            case 0:
                return selectedGroup?.startPointDetailAddress
            case (selectedGroup?.stopoverPoint.count ?? 0) + 1:
                return selectedGroup?.endPointDetailAddress
            default:
                return selectedGroup?.stopoverPoint["경유지\(indexPath.row)"]
            }
        }()
        cell.boardingCrewLabel.text = "탑승 크루"

        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

// MARK: - Component & Stacks
extension GroupDetailViewController {

    private func backButton() -> UIBarButtonItem {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        return backButton
    }

    private func navigationBarSetting() {
        navigationController?.navigationBar.tintColor = UIColor.semantic.accPrimary
        navigationItem.leftBarButtonItem = backButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(moveToAddGroup)
        )

    }

    /**
     Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
     */
    private func topLabelStack() -> UIStackView {
        let crewNameStack = crewNameLabel(selectedGroup?.groupTitle ?? "배찌의 행복여행")
        let distanceLabelStack = distanceLabel(selectedGroup?.accumulateDistance ?? 20)

        let mainStackView = UIStackView(
             arrangedSubviews: [crewNameStack, distanceLabelStack]
        )
        mainStackView.axis = .vertical

        crewNameStack.snp.makeConstraints { make in
            make.bottom.equalTo(distanceLabelStack.snp.top).offset(-8)
        }
        return mainStackView
    }

    /**
     크루의 이름을 표시하는 라벨 스택
     */
    private func crewNameLabel(_ crewName: String) -> UIStackView {
        let stackView = UIStackView()
        let crewNameLabel = UILabel()
        crewNameLabel.text = crewName
        crewNameLabel.font = UIFont.carmuFont.headline2
        crewNameLabel.textColor = UIColor.semantic.textPrimary
        stackView.addArrangedSubview(crewNameLabel)

        return stackView
    }

    /**
     주행거리 표시 라벨 스택
     */
    private func distanceLabel(_ distance: Int) -> UIStackView {
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let stackView = UIStackView(arrangedSubviews: [label1, label2, label3, spacer()])

        label1.text = "이 크루와 함께한 여정은 "
        label2.text = "\(distance)km "
        label3.text = "입니다."

        label1.font = UIFont.carmuFont.subhead3
        label2.font = UIFont.carmuFont.subhead3
        label3.font = UIFont.carmuFont.subhead3
        label1.textColor = UIColor.semantic.textBody
        label2.textColor = UIColor.semantic.accPrimary
        label3.textColor = UIColor.semantic.textBody

        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .leading
        stackView.distribution = .fill

        return stackView
    }

    /**
     이 뷰에서 사용되는 buttonComponent
     */
    private func buttonComponent(
        buttonWidth width: CGFloat,
        buttonHeight height: CGFloat
    ) -> UIButton {
        let button = UIButton(type: .system)

        button.setTitle("크루 나가기", for: .normal)
        button.setTitleColor(UIColor.theme.white, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.subhead3
        button.setBackgroundImage(.pixel(ofColor: UIColor.semantic.negative!), for: .normal)
        button.layer.cornerRadius = 30
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

// MARK: - @objc Method
extension GroupDetailViewController {

    /**
     추후 그룹 해체 기능으로 사용될 액션 메서드
     */
    @objc private func dummyButtonAction() {}

    /**
     크루 편집 화면으로 들어가는 메서드
     */
    @objc private func moveToAddGroup() {
        let groudAddViewController = GroupAddViewController() // 추후 EditView 따로 만들어서 관리해야 함.
        present(groudAddViewController, animated: true)
    }

    /**
     backButton을 누를 때 적용되는 액션 메서드
     */
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Preview canvas 세팅
import SwiftUI

struct GroupDetailViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = GroupDetailViewController

    func makeUIViewController(context: Context) -> GroupDetailViewController {
        return GroupDetailViewController()
    }

    func updateUIViewController(_ uiViewController: GroupDetailViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct GroupDetailViewPreview: PreviewProvider {

    static var previews: some View {
        GroupDetailViewControllerRepresentable()
    }
}
