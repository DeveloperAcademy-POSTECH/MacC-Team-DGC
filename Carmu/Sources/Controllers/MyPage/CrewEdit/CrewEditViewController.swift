//
//  CrewEditViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import UIKit

import SnapKit

// MARK: - 크루 편집 뷰 컨트롤러
final class CrewEditViewController: UIViewController {

    private let crewEditView = CrewEditView()
    private let firebaseManager = FirebaseManager()
    var userCrewData: Crew? // 불러온 유저의 크루 데이터

    init(userCrewData: Crew) {
        // TODO: - 실제 DB 데이터 받아오도록 수정
        self.userCrewData = userCrewData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        // 백버튼 텍스트 제거
        navigationController?.navigationBar.topItem?.title = ""
        // 설정 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(completeCrewEdit)
        )

        view.addSubview(crewEditView)
        crewEditView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = userCrewData?.name // 내비게이션 제목 크루 이름으로 설정
    }
}

// MARK: - @objc 메서드
extension CrewEditViewController {

    // [완료] 버튼 클릭 시 호출
    @objc private func completeCrewEdit() {
        // TODO: - 구현하기
        print("크루 편집 완료")
    }
}
