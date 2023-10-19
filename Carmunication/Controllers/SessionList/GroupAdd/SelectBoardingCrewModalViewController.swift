//
//  SelectBoardingCrewModalViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

class SelectBoardingCrewModalViewController: UIViewController {

    let selectBoardingCrewModalView = SelectBoardingCrewModalView()

    var selectedFriends: [String]?
    var friendsList: [User]?
    var friendSelectionHandler: (([String]) -> Void)?
    private let firebaseManager = FirebaseManager()

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
        selectBoardingCrewModalView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)

        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]

        print("모달 컨트롤러 friendsList : ", friendsList)
    }
}

// MARK: - @objc Method
extension SelectBoardingCrewModalViewController {

    @objc private func backButtonAction() {
        dismiss(animated: true)
    }

    @objc private func saveButtonAction() {
        dismiss(animated: true)
    }
}

// 모달 높이 조절을 위한 델리게이트
extension SelectBoardingCrewModalViewController: UISheetPresentationControllerDelegate {}

extension SelectBoardingCrewModalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == selectBoardingCrewModalView.selectedCrewCollectionView {
            return selectedFriends?.count ?? 0
        } else {
            return friendsList?.count ?? 0
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
        if collectionView == selectBoardingCrewModalView.selectedCrewCollectionView {
            if let cell = selectBoardingCrewModalView.selectedCrewCollectionView.dequeueReusableCell(
                withReuseIdentifier: "selectedCrewCell",
                for: indexPath
            ) as? GroupAddModalCollectionViewCell {
                cell.personImage.image = UIImage(named: "crewImageDefalut")
                cell.personNameLabel.text = "홍길동"
                self.selectBoardingCrewModalView.selectedCrewCollectionView.reloadData()
                return cell
            }
        } else {
            if let cell = selectBoardingCrewModalView.friendsListCollectionView.dequeueReusableCell(
                withReuseIdentifier: "friendCell",
                for: indexPath
            ) as? GroupAddModalCollectionViewCell {
                firebaseManager.loadProfileImage(
                    urlString: self.friendsList?[indexPath.row].imageURL ?? ""
                ) { friendImage in
                    if let friendImage = friendImage {
                        cell.personImage.image = friendImage
                    } else {
                        cell.personImage.image = UIImage(named: "profile")
                    }
                }
                cell.personNameLabel.text = self.friendsList?[indexPath.row].nickname ?? "홍길동"
                self.selectBoardingCrewModalView.friendsListCollectionView.reloadData()
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

// MARK: - Previewer
import SwiftUI

@available(iOS 13.0.0, *)
struct GroupModalControllerPreview: PreviewProvider {

    static var previews: some View {
        GroupAddViewControllerRepresentable()
    }
}
