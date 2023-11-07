//
//  RepeatDaySelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

import SnapKit

final class RepeatDaySelectViewController: UIViewController {

    private let repeatDaySelectView = RepeatDaySelectView()
    private var selectedButton: DaySelectButton?
    private var selectedRows = Set<DayOfWeek>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        repeatDaySelectView.dayTableView.delegate = self
        repeatDaySelectView.dayTableView.dataSource = self
        repeatDaySelectView.dayTableView.allowsMultipleSelection = true
        repeatDaySelectView.dayTableView.register(
            UITableViewCell.self,
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
        selectedRows = Set<DayOfWeek>([.mon, .tue, .wed, .thu, .fri])
        repeatDaySelectView.dayTableView.reloadData()
    }

    @objc private func weekendButtonTapped(_ sender: DaySelectButton) {
        selectedRows = Set<DayOfWeek>([.sat, .sun])
        repeatDaySelectView.dayTableView.reloadData()
    }

    @objc private func everydayButtonTapped(_ sender: DaySelectButton) {
        selectedRows = Set<DayOfWeek>([.mon, .tue, .wed, .thu, .fri, .sat, .sun])
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
        let weekday: Set<DayOfWeek> = Set([.mon, .tue, .wed, .thu, .fri])
        let weekend: Set<DayOfWeek> = Set([.sat, .sun])
        let everyday: Set<DayOfWeek> = Set([.mon, .tue, .wed, .thu, .fri, .sat, .sun])

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
        let dayOfWeek: [DayOfWeek] = [.mon, .tue, .wed, .thu, .fri, .sat, .sun]
        let cell = tableView.dequeueReusableCell(withIdentifier: "repeatDayCell", for: indexPath)
        cell.textLabel?.text = "\(dayOfWeek[indexPath.row].dayString)요일 마다"
        cell.accessoryType = selectedRows.contains(dayOfWeek[indexPath.row]) ? .checkmark : .none
        return cell
    }
}

// MARK: - TableViewDelegate Method
extension RepeatDaySelectViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if let selectedDay = DayOfWeek(rawValue: indexPath.row) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                selectedRows.remove(selectedDay)
            } else {
                cell.accessoryType = .checkmark
                selectedRows.insert(selectedDay)
            }
            checkDefaultDay()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let deselectedDay = DayOfWeek(rawValue: indexPath.row), selectedRows.contains(deselectedDay) {
            selectedRows.remove(deselectedDay)
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
