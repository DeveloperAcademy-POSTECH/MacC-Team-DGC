//
//  ProfileChangeViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/02.
//

import UIKit

// MARK: - 프로필 변경 화면 뷰 컨트롤러
final class ProfileChangeViewController: UIViewController {

    var selectedProfileTypeIdx: Int = 0 // 선택한 프로필 타입
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
            ProfileTypeCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileTypeCollectionViewCell.cellIdentifier
        )
        profileChangeView.profileCollectionView.delegate = self
        profileChangeView.profileCollectionView.dataSource = self

        profileChangeView.closeButton.addTarget(self, action: #selector(closeProfileChangeView), for: .touchUpInside)
        profileChangeView.saveButton.addTarget(self, action: #selector(performProfileUpdate), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        // 마이페이지에서는 내비게이션 바가 보이지 않도록 한다.
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        // 마이페이지에서는 탭 바가 보이도록 한다.
//        tabBarController?.tabBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        // 마이페이지에서 설정 화면으로 넘어갈 때는 내비게이션 바가 보이도록 해준다.
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - @objc 메서드
extension ProfileChangeViewController {

    // 상단 닫기 버튼 클릭 시 동작
    @objc private func closeProfileChangeView() {
        self.dismiss(animated: true)
    }

    // [저장] 버튼을 눌렀을 때 동작
    @objc private func performProfileUpdate() {
        // TODO: - 구현 필요
        print("프로필 변경!!!")
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource 델리게이트 구현
extension ProfileChangeViewController: UICollectionViewDataSource {

    // 컬렉션 뷰의 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ProfileType.allCases.count
    }

    // 컬렉션 뷰 셀 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileTypeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? ProfileTypeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.profileType = ProfileType.allCases[indexPath.row]
        cell.profileImageView.image = UIImage(profileType: ProfileType.allCases[indexPath.row])
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
//        return 20.67
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
        selectedProfileTypeIdx = indexPath.row // 선택한 인덱스 값을 저장한다.
        print("선택한 인덱스: \(selectedProfileTypeIdx)")
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
