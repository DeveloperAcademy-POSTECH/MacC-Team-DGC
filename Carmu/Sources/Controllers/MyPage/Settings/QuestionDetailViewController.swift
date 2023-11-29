//
//  QuestionDetailViewController.swift
//  Carmu
//
//  Created by 김영빈 on 2023/11/12.
//

import UIKit

final class QuestionDetailViewController: UIViewController {

    var questionNum = 1

    let question1Contents: [String: Any] = [
        "question": "새로운 셔틀에 동참하려 해요\n셔틀은 하나 이상 만들 수는 없나요?",
        "highlighted": ["하나 이상"],
        "answerTitle": "한 개의 셔틀에만 참여할 수 있어요",
        "answerDescription": "새로운 셔틀에 동참하고 싶으시면 현재 참여중인 셔틀을 탈퇴한 후, 새로운 셔틀을 생성 또는 새로운 셔틀에 초대코드 입력 후 참여할 수 있습니다."
    ]
    let question2Contents: [String: Any] = [
        "question": "참여/운행 가능여부 응답에 대한\n시간 규칙을 변경 할 수 있나요?",
        "highlighted": ["시간 규칙"],
        "answerTitle": "아쉽게도 변경할 수 없어요",
        "answerDescription":
        """
        카뮤의 참여/운행 가능여부 응답에 대한 시간 규칙은 초기 설정되어 있는 다음 설정을 따릅니다.

        ◦ 기사님의 경우: 출발 30분 전까지 오늘의 셔틀 운행 여부를 응답해주지 않으면 자동으로 셔틀이 없음 처리가 됩니다.
        ◦ 탑승자의 경우: 출발 20분 전까지 오늘의 셔틀 탑승 여부를 응답해주지 않으면 자동으로 따로가요 처리가 됩니다.

        ✓모든 응답은 날이 바뀌는 자정에 초기화됩니다.
        """
    ]
    let question3Contents: [String: Any] = [
        "question": "앱을 사용하다 지각했어요\n카뮤에서 보상 가능한가요?",
        "highlighted": ["지각", "보상 가능"],
        "answerTitle": "카뮤는 근태 또는 기타 지연 상황에 대한\n법적 책임을 지지 않습니다",
        "answerDescription":
        """
        카뮤는 셔틀에서의 불편한 상황과 소통의 어려움을 도와주는 앱입니다.

        카뮤를 이용하다 발생한 근태 또는 기타 지연 상황에 대해서 카뮤는 법적 책임을 지거나 소명 자료를 배부해 주지 않습니다.
        """
    ]

    private let questionDetailView = QuestionDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        navigationController?.navigationBar.topItem?.title = "" // 백버튼 텍스트 제거

        view.addSubview(questionDetailView)
        questionDetailView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        switch questionNum {
        case 1:
            questionDetailView.questionLabel.attributedText = makeHighlightedAttributedText(
                text: question1Contents["question"] as? String ?? "",
                highlightedArr: question1Contents["highlighted"] as? [String] ?? [],
                highlightColor: UIColor.semantic.accPrimary ?? .systemBlue
            )
            questionDetailView.answerTitle.text = question1Contents["answerTitle"] as? String ?? ""
            questionDetailView.answerDescription.text = question1Contents["answerDescription"] as? String ?? ""
            questionDetailView.answerTitle.snp.updateConstraints { make in
                make.height.equalTo(22)
            }
        case 2:
            questionDetailView.questionLabel.attributedText = makeHighlightedAttributedText(
                text: question2Contents["question"] as? String ?? "질문 불러오기 실패",
                highlightedArr: question2Contents["highlighted"] as? [String] ?? [],
                highlightColor: UIColor.semantic.accPrimary ?? .systemBlue
            )
            questionDetailView.answerTitle.text = question2Contents["answerTitle"] as? String ?? ""
            questionDetailView.answerDescription.text = question2Contents["answerDescription"] as? String ?? ""
            questionDetailView.answerTitle.snp.updateConstraints { make in
                make.height.equalTo(22)
            }
        case 3:
            questionDetailView.questionLabel.attributedText = makeHighlightedAttributedText(
                text: question3Contents["question"] as? String ?? "질문 불러오기 실패",
                highlightedArr: question3Contents["highlighted"] as? [String] ?? [],
                highlightColor: UIColor.semantic.accPrimary ?? .systemBlue
            )
            questionDetailView.answerTitle.text = question3Contents["answerTitle"] as? String ?? ""
            questionDetailView.answerDescription.text = question3Contents["answerDescription"] as? String ?? ""
            questionDetailView.answerTitle.snp.updateConstraints { make in
                make.height.equalTo(44)
            }
        default:
            break
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "자주 묻는 질문"
    }

    // 특정 텍스트 구간이 강조된 AttributedText를 만들어주는 메서드
    /**
     text: 전체 텍스트
     highlightedArr: 강조하고자 하는 텍스트 구간들의 배열
     highlightColor: 강조색상
     */
    private func makeHighlightedAttributedText(text: String, highlightedArr: [String], highlightColor: UIColor) -> NSMutableAttributedString {
        let totalText = text
        let attributedText = NSMutableAttributedString(string: totalText)
        for highlighted in highlightedArr {
            if let range = totalText.range(of: highlighted) {
                let nsRange = NSRange(range, in: totalText)
                attributedText.addAttribute(
                    NSAttributedString.Key.foregroundColor,
                    value: highlightColor,
                    range: nsRange
                )
            }
        }
        return attributedText
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct QuestionDetailVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = QuestionDetailViewController
    func makeUIViewController(context: Context) -> QuestionDetailViewController {
        return QuestionDetailViewController()
    }
    func updateUIViewController(_ uiViewController: QuestionDetailViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct QuestionDetailViewPreview: PreviewProvider {
    static var previews: some View {
        QuestionDetailVCRepresentable()
    }
}
