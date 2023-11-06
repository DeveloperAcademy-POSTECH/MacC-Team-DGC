//
//  TimeSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/3/23.
//

import UIKit

final class TimeSelectViewController: UIViewController {

    private let timeSelectView = TimeSelectView()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        timeSelectView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
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
}

// MARK: - @objc Method
extension TimeSelectViewController {

    @objc private func setTimeButtonTapped(_ sender: UIButton) {
        let detailViewController = TimeSelectModalViewController()

        // TODO: - Crew에 정보 입력하는 방식 이후, 타임 피커에 이전 경유지보다 늦은 시간부터 설정하는 로직 구현예정
        if sender.tag > 0 {

        }
        detailViewController.timeSelectModalView.timePicker.date = Date.formattedDate(
            string: timeSelectView.customTableVieWCell[sender.tag].detailTimeButton.titleLabel?.text ?? "오전 12:00",
            dateFormat: "aa hh:mm"
        ) ?? Date()

        // 클로저를 통해 선택한 시간을 받음
        detailViewController.timeSelectionHandler = { [weak self] selectedTime in
            self?.updateDetailTime(at: sender.tag, with: selectedTime)

            // 현재 선택지 이후의 시간을 자동으로 10분 간격으로 미뤄주는 부분
            var index = 1
            for element in sender.tag + 1..<(self?.timeSelectView.customTableVieWCell.count ?? 0) {
                self?.updateDetailTime(at: element, with: selectedTime + TimeInterval(600 * index))
                index += 1
            }
        }
        present(detailViewController, animated: true)
    }

    @objc private func nextButtonTapped() {
        // TODO: 다음화면 이동 구현 필요
        let viewController = RepeatDaySelectViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct TSViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = TimeSelectViewController
    func makeUIViewController(context: Context) -> TimeSelectViewController {
        return TimeSelectViewController()
    }
    func updateUIViewController(_ uiViewController: TimeSelectViewController, context: Context) {}
}
