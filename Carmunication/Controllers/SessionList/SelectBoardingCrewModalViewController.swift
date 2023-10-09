//
//  SelectBoardingCrewModalViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

class SelectBoardingCrewModalViewController: UIViewController {

    let selectBoardingCrewModalView = SelectBoardingCrewModalView()

    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(selectBoardingCrewModalView)
        selectBoardingCrewModalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        selectBoardingCrewModalView.friendsListCollectionView.delegate = self
        selectBoardingCrewModalView.selectedCrewCollectionView.delegate = self
        selectBoardingCrewModalView.friendsListCollectionView.dataSource = self
        selectBoardingCrewModalView.selectedCrewCollectionView.dataSource = self

        selectBoardingCrewModalView.closeButton.addTarget(
            self,
            action: #selector(backButtonAction),
            for: .touchUpInside
        )

        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
    }
}

// MARK: - @objc Method
extension SelectBoardingCrewModalViewController {

    @objc private func backButtonAction() {
        dismiss(animated: true)
    }
}

extension SelectBoardingCrewModalViewController: UISheetPresentationControllerDelegate {}

extension SelectBoardingCrewModalViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == selectBoardingCrewModalView.selectedCrewCollectionView {
            return 25
        } else {
            return 28
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 45, height: 65)
    }

    // 셀 간 최소 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 20
    }
}

extension SelectBoardingCrewModalViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let cell = selectBoardingCrewModalView.selectedCrewCollectionView.dequeueReusableCell(
            withReuseIdentifier: "selectedCrewCell",
            for: indexPath
        ) as? GroupAddModalCollectionViewCell {
            cell.personImage.image = UIImage(named: "crewImageDefalut")
            cell.personNameLabel.text = "홍길동"
            return cell
        }

        if let cell = selectBoardingCrewModalView.friendsListCollectionView.dequeueReusableCell(
            withReuseIdentifier: "friendCell",
            for: indexPath
        ) as? GroupAddModalCollectionViewCell {
            cell.personImage.image = UIImage(named: "crewImageDefalut")
            cell.personNameLabel.text = "홍길동"
            return cell
        }

        return UICollectionViewCell()
    }
}
