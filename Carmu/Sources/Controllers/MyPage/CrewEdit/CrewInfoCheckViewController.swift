//
//  CrewInfoCheckViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/10.
//

import UIKit

import SnapKit

// MARK: - 크루 정보 확인 뷰 컨트롤러
final class CrewInfoCheckViewController: UIViewController {

    private let crewInfoCheckView = CrewInfoCheckView()
    private let firebaseManager = FirebaseManager()

    var crewInfoData: Crew? // 크루 데이터

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        // TODO: - 크루 데이터 불러오기
        guard let crewData = crewData else {
            return
        }
        crewInfoData = crewData
        

//        // 내비게이션 바 appearance 설정 (배경색)
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor.semantic.backgroundDefault
//        appearance.shadowColor = UIColor.semantic.backgroundSecond
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
        // 백버튼 텍스트 제거
        navigationController?.navigationBar.topItem?.title = ""
        // 설정 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: self,
            action: #selector(startCrewEdit)
        )

        view.addSubview(crewInfoCheckView)
        crewInfoCheckView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "크루 정보"
    }

}

// MARK: - @objc 메서드
extension CrewInfoCheckViewController {

    // 크루 정보 편집 버튼 클릭 시 호출
    @objc private func startCrewEdit() {
        // TODO: - 구현하기
        print("크루 정보 편집 시작")
    }
}
