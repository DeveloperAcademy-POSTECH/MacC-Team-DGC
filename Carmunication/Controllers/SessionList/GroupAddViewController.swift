//
//  GroupAddViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/09/24.
//

import UIKit

import SnapKit

struct AddressAndTime {
    var address: String = "포항시 남구 지곡로 80"
    var time: String = "09:30"
}

final class GroupAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var cellData: [AddressAndTime] = [
        AddressAndTime(address: "C5", time: "08:30"),
        AddressAndTime(address: "가속기", time: "09:30"),
        AddressAndTime(address: "울산", time: "10:30"),
        AddressAndTime(address: "서울", time: "14:30")
    ]

    private let groupAddView = GroupAddView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(groupAddView)
        groupAddView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        groupAddView.tableViewComponent.dataSource = self
        groupAddView.tableViewComponent.delegate = self

        groupAddView.addButton.addTarget(self, action: #selector(addGroupButtonAction), for: .touchUpInside)
    }
}

// MARK: - tableView protocol Method
extension GroupAddViewController {

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
                height: dummyViewHeight
            )
        )
        tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = numberOfSections(in: tableView) <= 3 ? false : true

        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GroupAddTableViewCell {
            // 셀에 Title, Subtitle, chevron 마크 설정
            cell.titleLabel.text = "주소 : \(cellData[indexPath.section].address)"
            cell.subtitleLabel.text = "탑승 시간 : \(cellData[indexPath.section].time)"
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.theme.blue8
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
                height: 44
            )
        )

        // 헤더 레이블 생성
        let headerLabel = UILabel()
        headerLabel.text = section == 0 ? "출발지" : section == tableView.numberOfSections - 1 ? "도착지" : "경유지 \(section)"
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
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.distribution = .fill
        headerView.addSubview(headerStackView) // 헤더 뷰에 StackView 추가
        tableView.sectionHeaderTopPadding = 0

        // StackView 레이아웃 설정
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.top.bottom.equalToSuperview()
        }

        return headerView
    }

    /**
     셀 선택 시 화면 전환 로직 구현
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detailViewController = SelectPointMapViewController()
        detailViewController.title = "장소 선택"
        detailViewController.modalPresentationStyle = .fullScreen

        present(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - @objc Method
extension GroupAddViewController {

    /**
     버튼이 눌린 section을 식별하거나 다른 작업 수행
     */
    @objc private func buttonTapped(_ sender: UIButton) {

        let section = sender.tag
        cellData.remove(at: section)
        groupAddView.tableViewComponent.reloadData()
    }
}

// MARK: - Component
extension GroupAddViewController {

    @objc private func addGroupButtonAction() {

        cellData.insert(AddressAndTime(address: "새로 들어온 데이터", time: "12:30"), at: cellData.count - 1)
        groupAddView.tableViewComponent.reloadData()
    }

    private func spacer() -> UIView {
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

    func updateUIViewController(_ uiViewController: GroupAddViewController, context: Context) {}
}

@available(iOS 13.0.0, *)
struct GroupAddViewControllerPreview: PreviewProvider {

    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }

}
