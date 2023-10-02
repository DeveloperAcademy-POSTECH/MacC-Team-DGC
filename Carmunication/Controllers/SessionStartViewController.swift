//
//  SessionStartViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/23.
//

import UIKit

import SnapKit

final class SessionStartViewController: UIViewController {

    // 더미 데이터
        private let groupData = [
            GroupData(
                image: UIImage(systemName: "heart")!,
                groupName: "group1",
                start: "양덕",
                end: "C5",
                startTime: "08:30",
                endTime: "9:00",
                date: "주중(월 - 금)",
                total: 4),
            GroupData(
                image: UIImage(systemName: "circle")!,
                groupName: "group2",
                start: "포항",
                end: "부산",
                startTime: "08:30",
                endTime: "9:00",
                date: "주중(월 - 금)",
                total: 4),
            GroupData(
                image: UIImage(systemName: "heart.fill")!,
                groupName: "group3",
                start: "인천",
                end: "서울",
                startTime: "08:30",
                endTime: "9:00",
                date: "주중(월 - 금)",
                total: 4),
            GroupData(
                image: UIImage(systemName: "circle.fill")!,
                groupName: "group4",
                start: "부평",
                end: "일산",
                startTime: "08:30",
                endTime: "9:00",
                date: "주중(월 - 금)",
                total: 4),
            GroupData(
                image: UIImage(systemName: "square")!,
                groupName: "group5",
                start: "서울",
                end: "포항",
                startTime: "08:30",
                endTime: "9:00",
                date: "주중(월 - 금)",
                total: 4)
        ]

    // 데이터 없을 때
//    let groupData = [GroupData]()

    private let journeyTogetherButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("여정 함께하기", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = 30
        return btn
    }()

    // 상단 그룹에 대한 컬렉션뷰입니다.
    private let groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal    // 좌우로 스크롤
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 여백 조정

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: "groupCell")
        collectionView.showsHorizontalScrollIndicator = false   // 스크롤바 숨기기
        return collectionView
    }()

    // 그룹이 없을 때 보여주는 뷰입니다.
    private let viewWithoutCrew: UIView = {
        let view = UIView()
        view.backgroundColor = .black   // TODO: - 색상 변경하기
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    // 그룸 이름을 알려주는 뷰와 여정을 요약해주는 뷰의 상위 뷰입니다.
    private let summaryView: UIView = {
        let view = UIView()
        return view
    }()

    // 그룹 이름을 알려주는 뷰입니다.
    private let groupNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink  // TODO: - 색상 변경하기
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    // 여정을 요약해주는 뷰입니다.
    private let journeySummaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    // 점선
    private let dottedLineLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setCollectionView()
        setJourneyTogetherButton()
        countGroupData()
        setSummaryView()
        setJourneySummaryView()

    }

    override func viewDidLayoutSubviews() {

        summaryView.layoutIfNeeded()

        // 점선 그리기
        journeySummaryView.layer.addSublayer(dottedLineLayer)
        dottedLineLayer.position = CGPoint(x: 0, y: journeySummaryView.frame.maxY - 100)
    }
}

extension SessionStartViewController {

    private func setCollectionView() {
        view.addSubview(groupCollectionView)
        groupCollectionView.backgroundColor = .white
        groupCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(110)    // TODO: - 크기 조정
        }
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
    }

    private func setJourneyTogetherButton() {
        view.addSubview(journeyTogetherButton)
        journeyTogetherButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(120)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60) // TODO: - 크기 조정
        }
        journeyTogetherButton.addTarget(self, action: #selector(presentModalQueue), for: .touchUpInside)
    }

    private func setViewWithoutGroup() {
        view.addSubview(viewWithoutCrew)

        viewWithoutCrew.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(110)
        }

        // 해당 뷰 안에 있는 라벨 추가
        let label = UILabel()
        label.text = "아직 만들어진 여정이 없어요...\n친구와 함께 여정을 시작해보세요!"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0  // 0으로 설정하면 자동으로 줄 바꿈이 됩니다.
        label.font = UIFont.systemFont(ofSize: 14)  // TODO: - 폰트 크기 및 폰트 설정하기

        // UILabel을 viewWithoutCrew의 서브뷰로 추가
        viewWithoutCrew.addSubview(label)

        label.snp.makeConstraints { make in
            make.centerX.equalTo(viewWithoutCrew)
            make.centerY.equalTo(viewWithoutCrew)
        }
    }

    private func setSummaryView() {
        view.addSubview(summaryView)

        summaryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            if groupData.count == 0 {
                // 데이터가 없을 때
                make.top.equalTo(viewWithoutCrew.snp.bottom).inset(-16)
            } else {
                // 데이터가 있을 때
                make.top.equalTo(groupCollectionView.snp.bottom).inset(-16)
            }
            make.bottom.equalTo(journeyTogetherButton.snp.top).inset(-36)
        }

        setGroupNameView()
    }

    private func setGroupNameView() {

        let groupNameLabel: UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.black
            lbl.font = UIFont.systemFont(ofSize: 14)

            if groupData.count == 0 {
                lbl.text = "------"
            } else {
                lbl.text = "1개 이상"
            }
            return lbl
        }()

        let whiteCircleImageViewLeft: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "circle.fill")
            imageView.tintColor = .white
            return imageView
        }()
        let whiteCircleImageViewRight: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "circle.fill")
            imageView.tintColor = .white
            return imageView
        }()

        summaryView.addSubview(groupNameView)
        groupNameView.addSubview(groupNameLabel)
        groupNameView.addSubview(whiteCircleImageViewLeft)
        groupNameView.addSubview(whiteCircleImageViewRight)

        groupNameView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(summaryView)
            make.height.equalTo(48)
        }

        groupNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(groupNameView)
            make.centerY.equalTo(groupNameView)
        }

        whiteCircleImageViewLeft.snp.makeConstraints { make in
            make.leading.equalTo(groupNameView).inset(20)
            make.centerY.equalTo(groupNameView)
            make.width.height.equalTo(10)
        }
        whiteCircleImageViewRight.snp.makeConstraints { make in
            make.trailing.equalTo(groupNameView).inset(20)
            make.centerY.equalTo(groupNameView)
            make.width.height.equalTo(10)
        }
    }

    private func setJourneySummaryView() {

        summaryView.addSubview(journeySummaryView)

        journeySummaryView.snp.makeConstraints { make in
            make.top.equalTo(groupNameView.snp.bottom)
            make.leading.trailing.bottom.equalTo(summaryView)
        }

        // 오늘의 날짜를 보여주는 메서드
        setTodayDate()

        // 문구를 관리하는 메서드
        setSentence()
    }

    private func setTodayDate() {
        // 현재 날짜를 표시할 DateFormatter 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd EEEE"  // 원하는 날짜 형식으로 설정
        dateFormatter.locale = Locale(identifier: "ko_KR")  // 한글 요일로 설정

        // 현재 날짜를 가져와서 원하는 형식으로 변환
        let today = Date()
        let formattedDate = dateFormatter.string(from: today)

        // 변환된 날짜를 UILabel에 표시
        let dateLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = formattedDate
            lbl.textColor = UIColor.black
            lbl.font = UIFont.systemFont(ofSize: 14)
            return lbl
        }()

        journeySummaryView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(journeySummaryView).inset(20)
        }
    }

    private func setSentence() {
        // 점선을 그리기 위한 CALayer 생성
        dottedLineLayer.strokeColor = UIColor.gray.cgColor
        dottedLineLayer.lineWidth = 1
        dottedLineLayer.lineDashPattern = [10, 10]  // 점선의 패턴을 설정

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: view.bounds.width - 40, y: 0)])
        dottedLineLayer.path = path
        dottedLineLayer.anchorPoint = CGPoint(x: 0, y: 0)

        // 문구
        let bottomLabel: UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.black
            lbl.font = UIFont.systemFont(ofSize: 14)
            lbl.textAlignment = .center
            return lbl
        }()

        journeySummaryView.addSubview(bottomLabel)

        bottomLabel.snp.makeConstraints { make in
            make.centerX.equalTo(journeySummaryView)
            make.bottom.equalTo(journeySummaryView).inset(20)
        }

        if groupData.count == 0 {   // 데이터 없다면
            bottomLabel.text = "세션관리에서 여정을 만들어 보세요."
        } else {
            bottomLabel.text = "오늘도 즐거운 여정을 시작해 보세요!"
        }
    }

    private func countGroupData() {
        if groupData.count == 0 {
            setViewWithoutGroup()
        }
    }

    @objc private func presentModalQueue() {
        let modalQueueViewController = ModalQueueViewController()
        self.present(modalQueueViewController, animated: true)
    }
}

extension SessionStartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return groupData.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 80, height: 106)
    }
}

extension SessionStartViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = groupCollectionView.dequeueReusableCell(
            withReuseIdentifier: "groupCell",
            for: indexPath
        ) as? GroupCollectionViewCell
        cell?.groupData = self.groupData[indexPath.row]
        return cell!
    }
}
