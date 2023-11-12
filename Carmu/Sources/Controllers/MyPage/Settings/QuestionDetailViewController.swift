//
//  QuestionDetailViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import UIKit

final class QuestionDetailViewController: UIViewController {

    private let questionDetailView = QuestionDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        navigationController?.navigationBar.topItem?.title = "" // 백버튼 텍스트 제거

        view.addSubview(questionDetailView)
        questionDetailView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "자주 묻는 질문"
    }
}
