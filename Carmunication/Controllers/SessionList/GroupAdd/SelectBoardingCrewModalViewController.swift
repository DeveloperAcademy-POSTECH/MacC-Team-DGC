//
//  SelectBoardingCrewModalViewController.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/08.
//

import UIKit

class SelectBoardingCrewModalViewController: UIViewController {

    let selectBoardingCrewModalView = SelectBoardingCrewModalView()

    var selectedFriends: [User]?
    var friendsList: [User]?
    var userImage: [String: UIImage]?
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
extension SelectBoardingCrewModalViewController: UISheetPresentationControllerDelegate { }

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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // friendList의 셀을 선택했을 경우(selectedList에 추가)
        if collectionView == selectBoardingCrewModalView.friendsListCollectionView {
            guard let friendElement = friendsList?[indexPath.row] else {
                return
            }
            if selectedFriends == nil { selectedFriends = [User]() }
            selectedFriends?.append(friendElement)
            friendsList?.remove(at: indexPath.row)
        } else { // selectedList의 셀을 선택했을 경우(friendList에 다시 추가)
            guard let selectedElement = selectedFriends?[indexPath.row] else {
                return
            }
            if friendsList == nil { friendsList = [User]() }
            friendsList?.append(selectedElement)
            selectedFriends?.remove(at: indexPath.row)
        }
        selectBoardingCrewModalView.friendsListCollectionView.reloadData()
        selectBoardingCrewModalView.selectedCrewCollectionView.reloadData()
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
                guard let nickname = self.selectedFriends?[indexPath.row].nickname else {
                    return UICollectionViewCell()
                }
                cell.personImage.image = userImage?[nickname]
                cell.personNameLabel.text = nickname
                return cell
            }
        } else {
            if let cell = selectBoardingCrewModalView.friendsListCollectionView.dequeueReusableCell(
                withReuseIdentifier: "friendListCell",
                for: indexPath
            ) as? GroupAddModalCollectionViewCell {
                guard let nickname = self.friendsList?[indexPath.row].nickname else {
                    return UICollectionViewCell()
                }
                cell.personImage.image = userImage?[nickname]
                cell.personNameLabel.text = nickname
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
