//
//  TimeSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class TimeSelectViewController: UIViewController {

    private let timeSelectView = TimeSelectView()
    var crewData: Crew

    // TODO: 추후 시간 입력 여부와 값 업데이트를 위한 프로퍼티
    private var startPointTime: Date? {
        didSet {
            if endPointTime != nil {
                timeSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                timeSelectView.nextButton.isEnabled = true
            }
        }
    }
    private var endPointTime: Date? {
        didSet {
            if startPointTime != nil {
                timeSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
                timeSelectView.nextButton.isEnabled = true
            }
        }
    }

    init(crewData: Crew) {
        self.crewData = crewData
        self.timeSelectView.customTableVieWCell = {
            var cells: [TimeSelectCellView] = []
            var timeAddressTuple: [(String?, Date)] = []
            var arrivalTime = Date()

            timeAddressTuple.append((crewData.startingPoint?.name, arrivalTime))
            if let stopover1 = crewData.stopover1 {
                arrivalTime += 600
                timeAddressTuple.append((stopover1.name, arrivalTime))
            }
            if let stopover2 = crewData.stopover2 {
                arrivalTime += 600
                timeAddressTuple.append((stopover2.name, arrivalTime))
            }
            if let stopover3 = crewData.stopover3 {
                arrivalTime += 600
                timeAddressTuple.append((stopover3.name, arrivalTime))
            }
            arrivalTime += 600
            timeAddressTuple.append((crewData.destination?.name, arrivalTime))

            for (index, (address, time)) in timeAddressTuple.enumerated() {
                let isStart = index == timeAddressTuple.count - 1 ? false : true
                let cellView = TimeSelectCellView(address: address ?? "주소", isStart, time: time)
                cellView.detailTimeButton.setTitle(Date.formattedDate(from: time, dateFormat: "aa hh:mm"), for: .normal)
                cellView.detailTimeButton.tag = index
                cells.append(cellView)
            }
            return cells
        }()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        timeSelectView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        for element in timeSelectView.customTableVieWCell {
            element.detailTimeButton.addTarget(self, action: #selector(setTimeButtonTapped), for: .touchUpInside)
        }
        view.addSubview(timeSelectView)
        timeSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Custom Method
extension TimeSelectViewController {

    private func updateDetailTime(at index: Int, with time: Date) {
        timeSelectView.customTableVieWCell[index].detailTimeButton.setTitle(
            Date.formattedDate(from: time, dateFormat: "aa hh:mm"),
            for: .normal
        )
    }

    /**
     crewData에 각 포인트별로 시간을 설정해주는 메서드
     */
    private func loadTimeData() {
        for (index, element) in timeSelectView.customTableVieWCell.enumerated() {
            guard let time = element.detailTimeButton.titleLabel?.text else { return }
            if index == 0 {
                crewData.startingPoint?.arrivalTime =  Date.formattedDate(
                    string: time,
                    dateFormat: "aa hh:mm"
                )
            } else if index == timeSelectView.customTableVieWCell.count - 1 {
                crewData.destination?.arrivalTime =  Date.formattedDate(
                    string: time,
                    dateFormat: "aa hh:mm"
                )
            } else {
                switch index {
                case 1:
                    crewData.stopover1?.arrivalTime = Date.formattedDate(
                        string: time,
                        dateFormat: "aa hh:mm"
                    )
                case 2:
                    crewData.stopover2?.arrivalTime = Date.formattedDate(
                        string: time,
                        dateFormat: "aa hh:mm"
                    )
                default:
                    crewData.stopover3?.arrivalTime = Date.formattedDate(
                        string: time,
                        dateFormat: "aa hh:mm"
                    )
                }
            }
        }
    }
}

// MARK: - @objc Method
extension TimeSelectViewController {

    @objc private func setTimeButtonTapped(_ sender: UIButton) {
        let detailViewController = TimeSelectModalViewController()

        // 출발지가 아닌 경우, 타임 피커의 최소 시간을 설정하는 조건문
        if sender.tag > 0 {
            let lastTime = Date.formattedDate(
                string: timeSelectView.customTableVieWCell[sender.tag - 1].detailTimeButton.titleLabel?.text ?? "오전 12:00",
                dateFormat: "aa hh:mm"
            ) ?? Date()
            detailViewController.timeSelectModalView.timePicker.minimumDate = lastTime
            detailViewController.timeSelectModalView.saveButton.isEnabled = false
            detailViewController.timeSelectModalView.saveButton.backgroundColor = UIColor.semantic.backgroundThird
        }

        detailViewController.timeSelectModalView.timePicker.date = Date.formattedDate(
            string: timeSelectView.customTableVieWCell[sender.tag].detailTimeButton.titleLabel?.text ?? "오전 12:00",
            dateFormat: "aa hh:mm"
        ) ?? Date()

        // 클로저를 통해 선택한 시간을 받음
        detailViewController.timeSelectionHandler = { [weak self] selectedTime in
            self?.updateDetailTime(at: sender.tag, with: selectedTime)
        }
        present(detailViewController, animated: true)
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        loadTimeData()
        let viewController = RepeatDaySelectViewController(crewData: crewData)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct TSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = TimeSelectViewController
    func makeUIViewController(context: Context) -> TimeSelectViewController {
        return TimeSelectViewController(
            crewData: Crew(
                memberStatus: [MemberStatus]()
            )
        )
    }
    func updateUIViewController(_ uiViewController: TimeSelectViewController, context: Context) {}
}
