//
//  GroupDetailViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//
import SnapKit
import UIKit

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

extension GroupDetailViewController: UITableViewDataSource, UITableViewDelegate {

    private func tableViewComponent() -> UITableView {
        let tableView = UITableView()
        // UITableView 설정
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
//        // cellData가 비어있지 않을 때 기존의 CustomListTableViewCell을 반환
//        if let cell = tableView.dequeueReusableCell(
//            withIdentifier: "cell",
//            for: indexPath
//        ) as? GroupDetailTableViewCell {
//
//            cell.cellCount = CGFloat((selectedGroup?.stopoverPoint.count ?? 0) + 2)
//            cell.index = CGFloat(indexPath.row)
//            print("delegate 내부 cell.cellCount : ", cell.cellCount)
//            print("delegate 내부 cell.index : ", cell.index)
//            return cell
//        }
        let cell = GroupDetailTableViewCell(
            index: CGFloat(indexPath.row),
            cellCount: CGFloat((selectedGroup?.stopoverPoint.count ?? 0) + 2)
        )
//        cell.cellCount = CGFloat((selectedGroup?.stopoverPoint.count ?? 0) + 2)
//        cell.index = CGFloat(indexPath.row)
        return cell

//        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

class GroupDetailTableViewCell: UITableViewCell {

    init(index:CGFloat, cellCount:CGFloat, style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
        self.index = index
        self.cellCount = cellCount
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    var index: CGFloat
    var cellCount: CGFloat
    // CustomListTableViewCell의 상단 레이블, 이미지
    let stopPointImage = UIImageView(image: UIImage(named: "StopPoint"))
    lazy var gradiantLine = GradientLineView(index: index, cellCount: cellCount)
    let groupName = UILabel()
    let chevronLabel = UIImageView(image: UIImage(systemName: "chevron.right"))

    // CustomListTableViewCell의 왼쪽 하단 레이블
    let startPointLabel = UILabel()
    let directionLabel = UILabel()
    let endPointLabel = UILabel()
    let startTimeTextLabel = UILabel()
    let startTimeLabel = UILabel()

    // CustomListTableViewCell의 오른쪽 하단 이미지 스택
    let elipseImage = UIImageView(image: UIImage(named: "elipse"))
    let crewImage = UIStackView()
    var crewCount: Int = 0 {
        didSet {
            updateCrewImages()
        }
    }

    // MARK: - Override Function
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//        setupConstraints()
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)
//        setupUI()
//        setupConstraints()
    }

    // MARK: - UI Setup function
    /**
     스택에 이미지를 추가하는 메서드
     */
    private func updateCrewImages() {
        // 스택뷰의 모든 서브뷰를 제거하여 이미지를 다시 추가
        for subview in crewImage.arrangedSubviews {
            crewImage.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        // TODO: - 3인 이상일 경우 외 2명 레이블 추가 표시
        // crewCount 값에 따라 이미지를 반복해서 추가
        for index in 0..<crewCount {
            let imageView = UIImageView(image: UIImage(named: "CrewImageDefalut")) // 사용자 이미지로 이름 바꿔 사용
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            crewImage.addArrangedSubview(imageView)

            if index > 2 { break }
        }
    }

    private func setupUI() {

        stopPointImage.contentMode = .scaleAspectFill
        gradiantLine.draw(CGRect(x: 0, y: 0, width: 2, height: 150))
        gradiantLine.backgroundColor = .gray
        // Crew Image 스택 관련 설정
        crewImage.axis = .horizontal
        crewImage.alignment = .leading
        crewImage.distribution = .fillEqually

        // Font, TextColor 설정
        groupName.font = UIFont.carmuFont.subhead3
        groupName.textColor = UIColor.semantic.textPrimary
        chevronLabel.tintColor = UIColor.semantic.accPrimary
        startPointLabel.font = UIFont.carmuFont.subhead2
        startPointLabel.textColor = UIColor.semantic.accPrimary
        endPointLabel.font = UIFont.carmuFont.subhead2
        endPointLabel.textColor = UIColor.semantic.accPrimary
        startTimeTextLabel.textColor = UIColor.theme.darkblue6
        startTimeTextLabel.font = UIFont.carmuFont.body2
        startTimeLabel.font = UIFont.carmuFont.subhead2
        startTimeLabel.textColor = UIColor.semantic.accPrimary
        directionLabel.font = UIFont.carmuFont.body2
        directionLabel.textColor = UIColor.theme.darkblue6

        contentView.addSubview(gradiantLine)
        contentView.addSubview(stopPointImage)
        contentView.addSubview(groupName)
        contentView.addSubview(chevronLabel)
        contentView.addSubview(startPointLabel)
        contentView.addSubview(directionLabel)
        contentView.addSubview(endPointLabel)
        contentView.addSubview(startTimeTextLabel)
        contentView.addSubview(startTimeLabel)
        contentView.addSubview(crewImage)
    }

    private func setupConstraints() {
        let padding: CGFloat = 20

        gradiantLine.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
        }

        stopPointImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(1)
            make.width.lessThanOrEqualTo(16)
            make.height.lessThanOrEqualTo(16)
        }

        chevronLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }

        startTimeTextLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(padding)
            make.leading.equalToSuperview().inset(padding)
        }

        startPointLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.bottom.equalTo(startTimeTextLabel.snp.top).offset(-4)
            make.width.lessThanOrEqualTo(100)
        }

        directionLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(startPointLabel.snp.trailing).offset(4)
            make.centerY.equalTo(startPointLabel.snp.centerY)
        }

        endPointLabel.snp.makeConstraints { make in
            make.leading.equalTo(directionLabel.snp.trailing).offset(4)
            make.centerY.equalTo(startPointLabel.snp.centerY)
            make.width.lessThanOrEqualTo(100)
        }

        crewImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(30)
            make.width.equalTo(84)
        }
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

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
