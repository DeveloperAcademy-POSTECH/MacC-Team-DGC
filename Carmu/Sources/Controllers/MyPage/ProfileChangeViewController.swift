//
//  ProfileChangeViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/02.
//

import UIKit

// 수정된 프로필 이미지 값을 이전 화면(MyPageView)에 전달하기 위한 델리게이트 프로토콜
protocol ProfileChangeViewControllerDelegate: AnyObject {

    func sendProfileImageColor(profileImageColor: ProfileImageColor)
}

// MARK: - 프로필 변경 화면 뷰 컨트롤러
final class ProfileChangeViewController: UIViewController {

    // 델리게이트 선언
    weak var delegate: ProfileChangeViewControllerDelegate?

    var selectedProfileImageColorIdx: Int = 0 // 선택한 프로필 이미지의 인덱스
    var selectedProfileImageColor: ProfileImageColor {
        // 선택한 프로필 이미지의 ProfileImageColor 값을 반환해주는 프로퍼티
        return ProfileImageColor.allCases[selectedProfileImageColorIdx]
    }

    private let profileChangeView = ProfileChangeView()
    private let firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        view.addSubview(profileChangeView)
        profileChangeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        profileChangeView.profileCollectionView.register(
            ProfileImageColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileImageColorCollectionViewCell.cellIdentifier
        )
        profileChangeView.profileCollectionView.delegate = self
        profileChangeView.profileCollectionView.dataSource = self

        profileChangeView.closeButton.addTarget(self, action: #selector(closeProfileChangeView), for: .touchUpInside)
        profileChangeView.saveButton.addTarget(self, action: #selector(performProfileUpdate), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 현재 설정되어 있는 프로필 값이 선택돼있도록 체크
        let indexPath = IndexPath(item: selectedProfileImageColorIdx, section: 0)
        profileChangeView.profileCollectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }
}

// MARK: - @objc 메서드
extension ProfileChangeViewController {

    // 상단 닫기 버튼 클릭 시 동작
    @objc private func closeProfileChangeView() {
        dismiss(animated: true)
    }

    // [저장] 버튼을 눌렀을 때 동작
    @objc private func performProfileUpdate() {
        // 델리게이트를 통해 MyPageViewController로 수정된 프로필 이미지 값을 전달
        delegate?.sendProfileImageColor(profileImageColor: selectedProfileImageColor)
        // 파이어베이스 DB에 수정된 프로필 이미지 값 저장
        firebaseManager.updateUserProfileImageColor(profileImageColor: ProfileImageColor.allCases[selectedProfileImageColorIdx])
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource 델리게이트 구현
extension ProfileChangeViewController: UICollectionViewDataSource {

    // 컬렉션 뷰의 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ProfileImageColor.allCases.count
    }

    // 컬렉션 뷰 셀 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileImageColorCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? ProfileImageColorCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.profileImageColor = ProfileImageColor.allCases[indexPath.row]
        cell.profileImageView.image = UIImage(profileImageColor: ProfileImageColor.allCases[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout 델리게이트 구현 (UICollectionViewDelegate는 해당 프로토콜에서 채택 중)
extension ProfileChangeViewController: UICollectionViewDelegateFlowLayout {

    // 위 아래 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 28
    }

    // 좌우 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10.335
    }

    // 컬렉션 뷰의 사이즈
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 컬렉션 뷰의 프레임을 기준으로 셀의 크기를 잡아준다.
        let cellSize: CGFloat = profileChangeView.profileCollectionView.frame.width / 4.86
        return CGSize(width: cellSize, height: cellSize)
    }

    // 컬렉션 뷰 선택 시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProfileImageColorIdx = indexPath.row // 선택한 인덱스 값을 저장한다.
        print("선택한 인덱스: \(selectedProfileImageColorIdx)")
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct ProfileChangeViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ProfileChangeViewController
    func makeUIViewController(context: Context) -> ProfileChangeViewController {
        return ProfileChangeViewController()
    }
    func updateUIViewController(_ uiViewController: ProfileChangeViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct ProfileChangeViewPreview: PreviewProvider {
    static var previews: some View {
        ProfileChangeViewControllerRepresentable()
    }
}
