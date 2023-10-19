//
//  GroupAddViewController+Extension.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/19.
//

import UIKit

// MARK: - UITableViewDataSource Method
extension GroupAddViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointsDataModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCellForRow(at: indexPath)
        configureCellActions(for: cell, at: indexPath)
        configureCellContent(for: cell, at: indexPath)
        return cell
    }

    private func configureCellForRow(at indexPath: IndexPath) -> GroupAddTableViewCell {
        let cell = GroupAddTableViewCell(
            index: CGFloat(indexPath.row),
            cellCount: CGFloat(pointsDataModel.count)
        )
        return cell
    }

    private func configureCellActions(for cell: GroupAddTableViewCell, at indexPath: IndexPath) {
        cell.addressSearchButton.addTarget(self, action: #selector(findAddressButtonTapped), for: .touchUpInside)
        cell.crewImageButton.addTarget(self, action: #selector(addBoardingCrewButtonTapped), for: .touchUpInside)
        cell.startTime.addTarget(self, action: #selector(setStartTimeButtonTapped), for: .touchUpInside)
        cell.stopoverPointRemoveButton.addTarget(
            self,
            action: #selector(stopoverRemoveButtonTapped),
            for: .touchUpInside)
    }

    private func configureCellContent(for cell: GroupAddTableViewCell, at indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == pointsDataModel.count - 1 {
            configureStartEndCellContent(for: cell, at: indexPath)
        } else {
            configureIntermediateCellContent(for: cell, at: indexPath)
        }

        if indexPath.row == pointsDataModel.count - 1 {
            configureLastCellContent(for: cell)
        }

        if let pointName = pointsDataModel[indexPath.row].pointName {
            cell.addressSearchButton.setTitle("    \(pointName)", for: .normal)
        }
        if let startTime = pointsDataModel[indexPath.row].pointArrivalTime {
            let formattedTime = Date.formattedDate(from: startTime, dateFormat: "a hh:mm")
            cell.startTime.setTitle(formattedTime, for: .normal)
        }
        if let boardingCrew = pointsDataModel[indexPath.row].boardingCrew {
            configureBoardingCrewContent(for: cell, with: boardingCrew)
        }
    }

    private func configureStartEndCellContent(for cell: GroupAddTableViewCell, at indexPath: IndexPath) {
        cell.stopoverPointRemoveButton.isEnabled = false
        cell.stopoverPointRemoveButton.isHidden = true
        cell.pointNameLabel.text = indexPath.row == 0 ? "출발지" : "도착지"
        cell.timeLabel.text = indexPath.row == 0 ? "출발시간" : "도착시간"
    }

    private func configureIntermediateCellContent(for cell: GroupAddTableViewCell, at indexPath: IndexPath) {
        cell.pointNameLabel.text = "경유지 \(indexPath.row)"
    }

    private func configureLastCellContent(for cell: GroupAddTableViewCell) {
        cell.crewImageButton.isHidden = true
        cell.crewImageButton.isEnabled = false
        cell.boardingCrewLabel.isHidden = true
    }

    private func configureBoardingCrewContent(for cell: GroupAddTableViewCell, with boardingCrew: [String]) {
        let maxCrewMembers = min(boardingCrew.count, 3)

        for index in 0..<maxCrewMembers {
            switch index {
            case 0:
                cell.crewImageButton.crewImage1.image = userImage?[boardingCrew[index]]
            case 1:
                cell.crewImageButton.crewImage2.image = userImage?[boardingCrew[index]]
            case 2:
                cell.crewImageButton.crewImage3.image = userImage?[boardingCrew[index]]
            default:
                break
            }
        }

        // If there are fewer than 3 crew members, hide the remaining image views.
        for index in maxCrewMembers..<3 {
            switch index {
            case 0:
                cell.crewImageButton.crewImage1.image = UIImage(named: "CrewPlusImage")
            case 1:
                cell.crewImageButton.crewImage2.image = UIImage(named: "CrewPlusImage")
            case 2:
                cell.crewImageButton.crewImage3.image = UIImage(named: "CrewPlusImage")
            default:
                break
            }
        }
    }
}

// MARK: - UITableViewDelegate Method
extension GroupAddViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - UITextFieldDelegate Method
extension GroupAddViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return true
    }

    // 텍스트 필드에서 리턴 키를 누를 때 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // 화면의 다른 곳을 탭할 때 호출되는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
