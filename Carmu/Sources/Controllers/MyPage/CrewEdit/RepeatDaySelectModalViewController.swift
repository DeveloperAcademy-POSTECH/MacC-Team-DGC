//
//  RepeatDaySelectModalViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/14.
//

import UIKit

// 수정된 값을 이전 화면에 전달하기 위한 델리게이트 프로토콜
protocol RDSModalViewControllerDelegate: AnyObject {

    func sendNewRepeatDayValue(newRepeatDay: [Int])
}

// MARK: - 반복 요일 설정 뷰 컨트롤러
final class RepeatDaySelectModalViewController: UIViewController {

    weak var delegate: RDSModalViewControllerDelegate?
    private let repeatDaySelectModalView = RepeatDaySelectModalView()

    var selectedRepeatDay = Set<Int>() // 유저가 선택한 요일 값

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.theme.white

        view.addSubview(repeatDaySelectModalView)
        repeatDaySelectModalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        repeatDaySelectModalView.closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        repeatDaySelectModalView.saveButton.addTarget(self, action: #selector(saveNewRepeatDay), for: .touchUpInside)

        repeatDaySelectModalView.dayButtonCollectionView.register(
            DayButtonCollectionViewCell.self,
            forCellWithReuseIdentifier: DayButtonCollectionViewCell.cellIdentifier
        )
        repeatDaySelectModalView.dayButtonCollectionView.delegate = self
        repeatDaySelectModalView.dayButtonCollectionView.dataSource = self
    }

    // 모달 닫기
    @objc func closeModal() {
        dismiss(animated: true)
    }

    // 요일 설정 저장 버튼
    @objc func saveNewRepeatDay() {
        // 델리게이트를 구현한 뷰 컨트롤러에 변경된 값 반영
        delegate?.sendNewRepeatDayValue(newRepeatDay: Array(selectedRepeatDay))
        closeModal()
    }
}

// MARK: - UICollectionViewDataSource 델리게이트 구현
extension RepeatDaySelectModalViewController: UICollectionViewDataSource {

    // 컬렉션 뷰 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 // 월화수목금토일
    }

    // 컬렉션 뷰 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DayButtonCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? DayButtonCollectionViewCell else {
            return UICollectionViewCell()
        }

        // 월~일 텍스트 지정
        cell.dayLabel.text = DayOfWeek(rawValue: indexPath.row)?.dayString
        // selectedRepeatDay에 값이 있는지에 따라 대응하는 셀의 색상 다르게 표시
        if selectedRepeatDay.contains(indexPath.row) {
            cell.dayLabel.textColor = UIColor.theme.white
            cell.backgroundColor = UIColor.semantic.accPrimary
        } else {
            cell.dayLabel.textColor = UIColor.semantic.textBody
            cell.backgroundColor = UIColor.semantic.backgroundSecond
        }
        return cell
    }

    // 셀 선택 시 동작
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("요일 버튼 클릭됨!!")
        print("현재 선택된 요일: \(selectedRepeatDay)")
        if selectedRepeatDay.contains(indexPath.row) {
            // 선택되어 있는 값이면 userTypeAnswer에서 제거
            selectedRepeatDay.remove(indexPath.row)
        } else {
            // 선택되어 있지 않다면 userTypeAnswer에 추가
            selectedRepeatDay.insert(indexPath.row)
        }
        // 컬렉션 뷰 새로고침
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout 델리게이트 구현
extension RepeatDaySelectModalViewController: UICollectionViewDelegateFlowLayout {

    // 기준 행 또는 열 사이에 들어가는 아이템 사이의 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 11
    }

    // 컬렉션 뷰 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 100) / 7
        return CGSize(width: size, height: size)
    }
}
