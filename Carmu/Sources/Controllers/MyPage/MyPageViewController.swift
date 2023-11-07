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

    private let myPageView = MyPageView()
    private lazy var crewInfoNoCrewView = CrewInfoNoCrewView()
    private lazy var crewInfoDriverView = CrewInfoDriverView()

    private let firebaseManager = FirebaseManager()

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

        // 유저 정보 불러와서 닉네임, 프로필 표시
        guard let databasePath = User.databasePathWithUID else {
            return
        }
        firebaseManager.readUser(databasePath: databasePath) { userData in
            guard let userData = userData else {
                return
            }
            self.updateNickname(newNickname: userData.nickname)
            self.selectedProfileImageColor = userData.profileImageColor
            self.updateProfileImageView(profileImageColor: self.selectedProfileImageColor)
        }

        view.addSubview(myPageView)
        view.addSubview(crewInfoNoCrewView)
        view.addSubview(crewInfoDriverView)
        myPageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 버튼에 Target 추가
        myPageView.nicknameEditButton.addTarget(self, action: #selector(showTextField), for: .touchUpInside)
        myPageView.profileImageEditButton.addTarget(self, action: #selector(showProfileChangeView), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "My Page"
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

    // 크루 없을 때의 화면 오토 레이아웃
    func setupNoCrewView() {
        crewInfoNoCrewView.snp.makeConstraints { make in
            make.top.equalTo(myPageView.userInfoView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(136)
        }
    }
    // 크루 있을 때의 화면 (운전자)
    func setupDriverView() {
        crewInfoDriverView.snp.makeConstraints { make in
            make.top.equalTo(myPageView.userInfoView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(136)
        }

        crewInfoDriverView.crewManageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        crewInfoDriverView.crewManageTableView.dataSource = self
        crewInfoDriverView.crewManageTableView.delegate = self
    }
}

// MARK: - @objc 메서드
extension MyPageViewController {

    // 설정 페이지 이동 메소드
    @objc private func showSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // 닉네임 편집 버튼을 누르면 텍스트 필드를 포함하고 있는 darkOverlayView 활성화
    @objc private func showTextField() {
        let nicknameEditVC = NicknameEditViewController(nickname: myPageView.nicknameLabel.text ?? "")
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

// MARK: - NicknameEditViewControllerDelegate 델리게이트 구현
/**
 NicknameEditViewController에서 닉네임 데이터가 수정되었을 때 호출
 */
extension MyPageViewController: NicknameEditViewControllerDelegate {

    func sendNewNickname(newNickname: String) {
        updateNickname(newNickname: newNickname)
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
            // TODO: - 크루 정보 수정하기로 이동
            print("크루 정보 수정하기")
        }
        // 클릭 후에는 셀의 선택이 해제된다.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct MyPageViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyPageViewController
    func makeUIViewController(context: Context) -> MyPageViewController {
        return MyPageViewController()
    }
    func updateUIViewController(_ uiViewController: MyPageViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct MyPageViewPreview: PreviewProvider {
    static var previews: some View {
        MyPageViewControllerRepresentable()
    }
}
