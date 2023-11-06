//
//  RepeatDaySelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class RepeatDaySelectViewController: UIViewController {

    private let repeatDaySelectView = RepeatDaySelectView()
    private var selectedButton: DaySelectButton?
    private var selectedRows = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        repeatDaySelectView.dayTableView.delegate = self
        repeatDaySelectView.dayTableView.dataSource = self
        repeatDaySelectView.dayTableView.allowsMultipleSelection = true
        repeatDaySelectView.dayTableView.register(
            RepeatDaySelectTableViewCell.self,
            forCellReuseIdentifier: "repeatDayCell"
        )

        setupAddTarget()
        view.addSubview(repeatDaySelectView)
        repeatDaySelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Method
extension RepeatDaySelectViewController {

    @objc private func weekdayButtonTapped(_ sender: DaySelectButton) {
        selectedRows.removeAll()
        if sender == selectedButton {
            for index in 0...4 {
                selectedRows.insert(index)
            }
        }
        repeatDaySelectView.dayTableView.reloadData()
    }

    @objc private func weekendButtonTapped(_ sender: DaySelectButton) {
        selectedRows.removeAll()
        if sender == selectedButton {
            selectedRows.insert(5)
            selectedRows.insert(6)
        }
        repeatDaySelectView.dayTableView.reloadData()
    }

    @objc private func everydayButtonTapped(_ sender: DaySelectButton) {
        selectedRows.removeAll()
        if sender == selectedButton {
            for index in 0...6 {
                selectedRows.insert(index)
            }
        }
        repeatDaySelectView.dayTableView.reloadData()
    }

    @objc private func daySettingButtonTapped(_ sender: DaySelectButton) {
        if selectedButton == sender {
            selectedButton?.resetButtonAppearance()
            selectedButton = nil
            selectedRows.removeAll()
            repeatDaySelectView.dayTableView.reloadData()
            return
        }
        selectedButton?.resetButtonAppearance()
        selectedButton = sender
        sender.setSelectedButtonAppearance()
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        let viewController = FinalConfirmViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Custom Method
extension RepeatDaySelectViewController {

    private func setupAddTarget() {
        repeatDaySelectView.weekdayButton.addTarget(
            self,
            action: #selector(daySettingButtonTapped),
            for: .touchUpInside
        )
        repeatDaySelectView.weekendButton.addTarget(
            self,
            action: #selector(daySettingButtonTapped),
            for: .touchUpInside
        )
        repeatDaySelectView.everydayButton.addTarget(
            self,
            action: #selector(daySettingButtonTapped),
            for: .touchUpInside
        )

        repeatDaySelectView.weekdayButton.addTarget(
            self,
            action: #selector(weekdayButtonTapped),
            for: .touchUpInside
        )
        repeatDaySelectView.weekendButton.addTarget(
            self,
            action: #selector(weekendButtonTapped),
            for: .touchUpInside
        )
        repeatDaySelectView.everydayButton.addTarget(
            self,
            action: #selector(everydayButtonTapped),
            for: .touchUpInside
        )

        repeatDaySelectView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }

    /**
     테이블뷰의 셀을 탭했을 때, 선택된 셀들이 주중, 주말, 매일에 해당하는지 체크하는 메서드
     해당하면, 그 버튼이 강조처리 된다.
     해당하지 않으면, 어떤 버튼이든 강조처리가 없어진다.
     */
    private func checkDefaultDay() {
        let weekday = Set([0, 1, 2, 3, 4])
        let weekend = Set([5, 6])
        let everyday = Set([0, 1, 2, 3, 4, 5, 6])

        switch selectedRows {
        case weekday:
            selectedButton = repeatDaySelectView.weekdayButton
            selectedButton?.setSelectedButtonAppearance()
        case weekend:
            selectedButton = repeatDaySelectView.weekendButton
            selectedButton?.setSelectedButtonAppearance()
        case everyday:
            selectedButton = repeatDaySelectView.everydayButton
            selectedButton?.setSelectedButtonAppearance()
        default:
            selectedButton?.resetButtonAppearance()
            selectedButton = nil
        }
    }
}

// MARK: - TableViewDataSource Method
extension RepeatDaySelectViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dayOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "repeatDayCell", for: indexPath)
        cell.textLabel?.text = "\(dayOfWeek[indexPath.row])요일 마다"
        cell.accessoryType = selectedRows.contains(indexPath.row) ? .checkmark : .none
        return cell
    }
}

// MARK: - TableViewDelegate Method
extension RepeatDaySelectViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            if let index = selectedRows.firstIndex(of: indexPath.row) {
                selectedRows.remove(at: index)
            }
        } else {
            cell.accessoryType = .checkmark
            selectedRows.insert(indexPath.row)
        }

        checkDefaultDay()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectedRows.contains(indexPath.row) {
            selectedRows.remove(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct RDSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RepeatDaySelectViewController
    func makeUIViewController(context: Context) -> RepeatDaySelectViewController {
        return RepeatDaySelectViewController()
    }
    func updateUIViewController(_ uiViewController: RepeatDaySelectViewController, context: Context) {}
}
