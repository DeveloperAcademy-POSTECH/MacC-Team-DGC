//
//  MyPageViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/09/29.
//

import UIKit

import SnapKit

// MARK: - 내 정보 탭 화면 뷰 컨트롤러
final class MyPageViewController: UIViewController {

    let dummyImage = ["coffee", "letter", "shoppingBag"]
    let dummydistance = [200, 200, 200]
    let dummyName = ["커피 한 잔", "주유상품권", "차량세척용품"]

    private let myPageView = MyPageView()
    private lazy var crewInfoNoCrewView = CrewInfoNoCrewView()
    private lazy var crewInfoDriverView = CrewInfoDriverView()
    private lazy var crewInfoPassengerView = CrewInfoPassengerView()

    private let firebaseManager = FirebaseManager()

    var crewData: Crew? // 불러온 유저의 크루 데이터
    var selectedProfileImageColor: ProfileImageColor = .blue // 프로필 이미지를 표시해주기 위한 ProfileImageColor 값
    var selectedProfileImageColorIdx: Int {
        // 컬렉션 뷰 셀의 인덱스에 대응하도록 ProfileImageColor 값의 인덱스를 반환하는 프로퍼티
        return ProfileImageColor.allCases.firstIndex(of: selectedProfileImageColor) ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundSecond

        // 내비게이션 바 appearance 설정 (배경색)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.semantic.backgroundDefault
        appearance.shadowColor = UIColor.semantic.backgroundSecond
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        // 백버튼 텍스트 제거
        navigationController?.navigationBar.topItem?.title = ""
        // 설정 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )

        updateUserInfo()

        view.addSubview(myPageView)
        view.addSubview(crewInfoNoCrewView)
        view.addSubview(crewInfoDriverView)
        view.addSubview(crewInfoPassengerView)
        myPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 크루 유무, 운전자 여부에 따른 화면 처리
        setupCrewInfoView()

        addTargetToButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "My Page"
    }

    // 버튼에 Target 추가
    private func addTargetToButtons() {
        myPageView.nicknameEditButton.addTarget(
            self,
            action: #selector(showNicknameEditView),
            for: .touchUpInside
        )
        myPageView.profileImageEditButton.addTarget(
            self,
            action: #selector(showProfileChangeView),
            for: .touchUpInside
        )
        crewInfoPassengerView.exitCrewButton.addTarget(
            self,
            action: #selector(exitCrewButtonTapped),
            for: .touchUpInside
        )
    }

    // 변경된 닉네임을 업데이트해주는 메서드
    func updateNickname(newNickname: String) {
        print("닉네임 업데이트!!!")
        myPageView.nicknameLabel.text = newNickname
    }

    // 프로필 이미지뷰를 업데이트해주는 메서드
    func updateProfileImageView(profileImageColor: ProfileImageColor) {
        print("프로필 이미지 뷰 업데이트!!!")
        myPageView.profileImageView.image = UIImage(myPageImageColor: profileImageColor)
    }

    // 유저 정보를 불러와서 닉네임, 프로필 표시
    private func updateUserInfo() {
        Task {
            guard let databasePath = User.databasePathWithUID else {
                return
            }
            let user = try await firebaseManager.readUser(databasePath: databasePath)
            guard let user = user else {
                return
            }
            updateNickname(newNickname: user.nickname)
            selectedProfileImageColor = user.profileImageColor
            updateProfileImageView(profileImageColor: selectedProfileImageColor)
        }
    }
}

// MARK: - @objc 메서드
extension MyPageViewController {

    // 설정 페이지 이동 메소드
    @objc private func showSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // 닉네임 편집 버튼을 누르면 닉네임 편집 화면으로 전환
    @objc private func showNicknameEditView() {
        let nicknameEditVC = NameEditViewController(
            nowName: myPageView.nicknameLabel.text ?? "",
            isCrewNameEditView: false
        )
        nicknameEditVC.delegate = self
        nicknameEditVC.modalPresentationStyle = .overCurrentContext
        present(nicknameEditVC, animated: false)
    }

    // 프로필 설정 버튼 클릭 시 호출
    @objc private func showProfileChangeView() {
        let profileChangeVC = ProfileChangeViewController()
        profileChangeVC.delegate = self
        profileChangeVC.selectedProfileImageColorIdx = selectedProfileImageColorIdx
        profileChangeVC.modalPresentationStyle = .formSheet
        present(profileChangeVC, animated: true)
    }

    // [셔틀 나가기] 버튼 클릭 시 호출 (동승자)
    @objc private func exitCrewButtonTapped() {
        // 크루 나가기 알럿
        let alert = UIAlertController(title: "셔틀을 나가시겠습니까?", message: "셔틀에 대한 모든 정보가 삭제됩니다.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "돌아가기", style: .cancel)
        let exitAction = UIAlertAction(title: "셔틀 나가기", style: .destructive) { _ in
            Task {
                print("셔틀 나가기 처리 중...")
                // TODO: - 동승자/운전자 구분 필요
                try await self.firebaseManager.deletePassengerInfoFromCrew()
                print("동승자 셔틀 나가기 처리 완료")
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(exitAction)
        present(alert, animated: true)
    }
}

// MARK: - 크루 정보 화면 구성 관련 메서드
extension MyPageViewController {

    private func setupCrewInfoView() {
        if !checkCrew() { // 그룹이 없을 때
            setupNoCrewView()
        } else { // 그룹이 있을 때
            if isCaptain() { // 운전자일 경우
                setupDriverView()
            } else { // 동승자일 경우
                setupPassengerView()
            }
        }
    }

    // 크루 유무 확인
    private func checkCrew() -> Bool {
        if crewData == nil {
            return false
        } else {
            return true
        }
    }

    // 운전자 여부 확인
    private func isCaptain() -> Bool {
        if crewData?.captainID == KeychainItem.currentUserIdentifier {
            return true
        } else {
            return false
        }
    }

    // 크루 없을 때의 화면 구성
    func setupNoCrewView() {
        crewInfoNoCrewView.isHidden = false
        crewInfoDriverView.isHidden = true
        crewInfoPassengerView.isHidden = true

        crewInfoNoCrewView.snp.makeConstraints { make in
            make.top.equalTo(myPageView.userInfoView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(136)
        }
    }

    // 크루 있을 때의 화면 구성 (운전자)
    func setupDriverView() {
        crewInfoNoCrewView.isHidden = true
        crewInfoDriverView.isHidden = false
        crewInfoPassengerView.isHidden = true

        crewInfoDriverView.snp.makeConstraints { make in
            make.top.equalTo(myPageView.userInfoView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(136)
        }

        crewInfoDriverView.crewManageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        crewInfoDriverView.crewManageTableView.dataSource = self
        crewInfoDriverView.crewManageTableView.delegate = self
    }

    // 크루 있을 때의 화면 구성 (동승자)
    func setupPassengerView() {
        crewInfoNoCrewView.isHidden = true
        crewInfoDriverView.isHidden = true
        crewInfoPassengerView.isHidden = false

        crewInfoPassengerView.snp.makeConstraints { make in
            make.top.equalTo(myPageView.userInfoView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }

        crewInfoPassengerView.giftCollectionView.register(
            GiftCardCollectionViewCell.self,
            forCellWithReuseIdentifier: GiftCardCollectionViewCell.cellIdentifier
        )
        crewInfoPassengerView.giftCollectionView.delegate = self
        crewInfoPassengerView.giftCollectionView.dataSource = self
    }
}

// MARK: - ProfileChangeViewControllerDelegate 델리게이트 구현
/**
 ProfileChangeViewController에서 프로필 이미지 데이터가 수정되었을 때 호출
 */
extension MyPageViewController: ProfileChangeViewControllerDelegate {

    func sendProfileImageColor(profileImageColor: ProfileImageColor) {
        selectedProfileImageColor = profileImageColor
        updateProfileImageView(profileImageColor: profileImageColor)
    }
}

// MARK: - NameEditViewControllerDelegate 델리게이트 구현
extension MyPageViewController: NameEditViewControllerDelegate {

    /**
     NameEditViewController에서 닉네임 데이터가 수정되었을 때 호출
     */
    func sendNewNameValue(newName: String) {
        updateNickname(newNickname: newName)
    }
}

// MARK: - UITableViewDataSource 프로토콜 구현
extension MyPageViewController: UITableViewDataSource {

    // 각 섹션의 row 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // 각 row에 대한 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "크루 정보 수정하기"
        cell.tintColor = UIColor.semantic.accPrimary // TODO: - 악세사리버튼 색 수정 안됨
        return cell
    }
}

// MARK: UITableViewDelegate 프로토콜 구현
extension MyPageViewController: UITableViewDelegate {

    // 테이블 뷰 섹션 헤더 뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    // 테이블 뷰 섹션 헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    // 테이블 뷰 셀을 눌렀을 때에 대한 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // [크루 정보 수정하기] 클릭
            let crewInfoCheckVC = CrewInfoCheckViewController()
            crewInfoCheckVC.crewData = crewData
            navigationController?.pushViewController(crewInfoCheckVC, animated: true)
        }
        // 클릭 후에는 셀의 선택이 해제된다.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDataSource 델리게이트 구현
extension MyPageViewController: UICollectionViewDataSource {

    // 컬렉션 뷰의 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    // 컬렉션 뷰 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GiftCardCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? GiftCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.giftImageView.image = UIImage(named: dummyImage[indexPath.row])
        cell.distanceLabel.text = "\(dummydistance[indexPath.row])km"
        cell.giftNameLabel.text = dummyName[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout 델리게이트 구현 (UICollectionViewDelegate는 해당 프로토콜에서 채택 중)
extension MyPageViewController: UICollectionViewDelegateFlowLayout {

    // 기준 행 또는 열 사이에 들어가는 아이템 사이의 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }

    // 컬렉션 뷰의 사이즈
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellHeight: CGFloat = crewInfoPassengerView.giftCollectionView.frame.height - 40
        let cellWidth: CGFloat = crewInfoPassengerView.giftCollectionView.frame.width * 19 / 70
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
