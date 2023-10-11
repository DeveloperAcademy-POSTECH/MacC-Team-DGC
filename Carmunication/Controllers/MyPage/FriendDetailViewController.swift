//
//  FriendDetailViewController.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/11.
//

import UIKit

final class FriendDetailViewController: UIViewController {

    let dummyImage = ["coffee", "box", "shoppingBag", "letter"]
    let dummydistance = [200, 400, 500, 1000]
    let dummyName = ["커피 한 잔", "1만원 이내의 선물", "3만원 이내의 선물", "주유상품권"]

    private let friendDetailView = FriendDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.tintColor = UIColor.semantic.textSecondary

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "친구삭제",
            style: .plain,
            target: self,
            action: #selector(showDeleteFriendAlert)
        )

        view.addSubview(friendDetailView)
        friendDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        friendDetailView.giftCollectionView.register(
            GiftCardCollectionViewCell.self,
            forCellWithReuseIdentifier: "giftCardCollectionViewCell"
        )
        friendDetailView.giftCollectionView.delegate = self
        friendDetailView.giftCollectionView.dataSource = self
    }
}

// MARK: - @objc 메서드
extension FriendDetailViewController {

    // [친구삭제] 버튼 클릭 시 알럿 띄우기
    @objc private func showDeleteFriendAlert() {
        let deleteAlertController = UIAlertController(
            title: "친구를 삭제하시겠어요?",
            message: nil,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let performDelete = UIAlertAction(title: "삭제", style: .destructive)
        deleteAlertController.addAction(cancel)
        deleteAlertController.addAction(performDelete)
        self.present(deleteAlertController, animated: true)
    }
}

// MARK: - 컬렉션 뷰 관련 델리게이트 구현
extension FriendDetailViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {

    // 컬렉션 뷰의 아이템이 몇개인지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    // 컬렉션 뷰 셀 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "giftCardCollectionViewCell",
            for: indexPath
        ) as? GiftCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.giftImageView.image = UIImage(named: dummyImage[indexPath.row])
        cell.distanceLabel.text = "\(dummydistance[indexPath.row])km"
        cell.giftNameLabel.text = dummyName[indexPath.row]
        return cell
    }

    // 위 아래 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }

    // 좌우 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }

    // 컬렉션 뷰의 사이즈
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 컬렉션 뷰의 프레임을 기준으로 셀의 크기를 잡아준다.
        let cellWidth: CGFloat = friendDetailView.giftCollectionView.frame.width / 2 - 5
        let cellHeight: CGFloat = friendDetailView.giftCollectionView.frame.height / 2 - 6

        return CGSize(width: cellWidth, height: cellHeight)
    }
}
