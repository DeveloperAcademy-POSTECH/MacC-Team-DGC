//
//  GroupAddViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

struct AddressAndTime {
    var address: String = "포항시 남구 지곡로 80"
    var time: String = "09:30"
}

class GroupAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var cellData: [AddressAndTime] = [
        AddressAndTime(address: "C5", time: "08:30"),
        AddressAndTime(address: "가속기", time: "09:30"),
        AddressAndTime(address: "울산", time: "10:30"),
        AddressAndTime(address: "서울", time: "14:30")
    ]
    let tableViewComponent: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellData.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " "
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dummyViewHeight = CGFloat(40)
        tableView.tableHeaderView = UIView(
            frame: CGRect(
                x: 0, y: 0,
                width: tableView.bounds.size.width,
                height: dummyViewHeight)
            )
        tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = numberOfSections(in: tableView) <= 3 ? false : true
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GroupAddTableViewCell {
            // 셀에 Title, Subtitle, chevron 마크 설정
            cell.titleLabel.text = "주소 : \(cellData[indexPath.section].address)"
            cell.subtitleLabel.text = "탑승 시간 : \(cellData[indexPath.section].time)"
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor(hexCode: "F1F3FF")
            cell.layer.cornerRadius = 20
            return cell
        } else {
            // 셀을 생성하는 데 실패한 경우, 기본 UITableViewCell을 반환.
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 헤더 뷰 생성
        let headerView = UIView(
            frame: CGRect(
                x: 0, y: 0,
                width: tableView.frame.size.width,
                height: 44)
        )
        // 헤더 레이블 생성
        let headerLabel = UILabel()
        headerLabel.text = section == 0 ? "출발지" : section == tableView.numberOfSections - 1 ? "도착지" : "경유지"
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        // 버튼 생성
        let button = UIButton(type: .close)
        button.tag = section
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        // StackView 생성 및 구성
        let headerStackView = UIStackView(
            arrangedSubviews: [
                headerLabel, spacer(),
                button.tag > 0 && button.tag < cellData.count - 1 ? button : spacer()
            ]
        )
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.distribution = .fill
        // 헤더 뷰에 StackView 추가
        headerView.addSubview(headerStackView)
        tableView.sectionHeaderTopPadding = 0
        // StackView 레이아웃 설정
        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerStackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        return headerView
    }

    @objc func buttonTapped(_ sender: UIButton) {
        // 버튼이 눌린 section을 식별하거나 다른 작업 수행
        let section = sender.tag
        cellData.remove(at: section)
        tableViewComponent.reloadData()
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 선택 시 화면 전환 로직 구현
        let detailViewController = SelectPointMapViewController()
        detailViewController.title = "장소 선택"
        detailViewController.modalPresentationStyle = .popover
        present(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let mainStackView = mainStack()
        view.addSubview(mainStackView)
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        tableViewComponent.dataSource = self
        tableViewComponent.delegate = self
        tableViewComponent.register(GroupAddTableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewComponent.separatorStyle = .none
        tableViewComponent.showsVerticalScrollIndicator = false
    }
}

// MARK: - Component
extension GroupAddViewController {
    func mainTopButtonStack() -> UIStackView {
        let button1 = buttonComponent("추가하기", 110, 30, 20, .blue, .cyan)
        let stackView = UIStackView(arrangedSubviews: [spacer(), button1])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 배치
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }
    /**
     Main StackView 설정 (StackView와 TableView를 감싸는 StackView)
     */
    func mainStack() -> UIStackView {
        let stackView = mainTopButtonStack()
        let shareButton = buttonComponent("링크 공유하기", .greatestFiniteMagnitude, 60, 30, .black, .gray)
        let mainStackView = UIStackView(
            arrangedSubviews: [stackView, tableViewComponent, shareButton]
        )
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        return mainStackView
    }
    func buttonComponent(_ title: String, _ width: CGFloat, _ height: CGFloat,
                         _ cornerRadius: CGFloat, _ fontColor: UIColor, _ backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(fontColor, for: .normal)
        button.setBackgroundImage(.pixel(ofColor: backgroundColor), for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        return button
    }
    func spacer() -> UIView {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        return spacerView
    }

}

// MARK: - Previewer
import SwiftUI

struct GroupAddViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = GroupAddViewController
    func makeUIViewController(context: Context) -> GroupAddViewController {
        return GroupAddViewController()
    }
    func updateUIViewController(_ uiViewController: GroupAddViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct GroupAddViewControllerPreview: PreviewProvider {
    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }
}
