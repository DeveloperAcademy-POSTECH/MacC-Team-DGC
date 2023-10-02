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
        btn.translatesAutoresizingMaskIntoConstraints = false
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: "groupCell")
        collectionView.showsHorizontalScrollIndicator = false   // 스크롤바 숨기기
        return collectionView
    }()

    // 그룹이 없을 때 보여주는 뷰입니다.
    private let viewWithoutCrew: UIView = {
        let view = UIView()
        view.backgroundColor = .black   // TODO: - 색상 변경하기
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    // 그룸 이름을 알려주는 뷰와 여정을 요약해주는 뷰의 상위 뷰입니다.
    private let summaryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // 그룹 이름을 알려주는 뷰입니다.
    private let groupNameView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemPink  // TODO: - 색상 변경하기
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    // 여정을 요약해주는 뷰입니다.
    private let journeySummaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setCollectionView()
        setJourneyTogetherButton()
        setSummaryView()
        setJourneySummaryView()
    }
}

extension SessionStartViewController {

    private func setCollectionView() {
        view.addSubview(groupCollectionView)
        groupCollectionView.backgroundColor = .white
        groupCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)    // TODO: - 크기 조정
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
        let safeArea = view.safeAreaLayoutGuide

        // TODO: - 스냅킷 적용하기
        NSLayoutConstraint.activate([
            viewWithoutCrew.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            viewWithoutCrew.topAnchor.constraint(equalTo: safeArea.topAnchor),
            viewWithoutCrew.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            // 작은 화면 버전도 나타나면 height 수정
            viewWithoutCrew.heightAnchor.constraint(equalToConstant: 110)
        ])

        // 해당 뷰 안에 있는 라벨 추가
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아직 만들어진 여정이 없어요...\n친구와 함께 여정을 시작해보세요!"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0  // 0으로 설정하면 자동으로 줄 바꿈이 됩니다.
        label.font = UIFont.systemFont(ofSize: 14)  // 폰트 크기 14로 설정
        // label.font = UIFont(name: "YourCustomFontName", size: 14)    // 폰트 설정

        // UILabel을 viewWithoutCrew의 서브뷰로 추가
        viewWithoutCrew.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewWithoutCrew.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewWithoutCrew.centerYAnchor)
        ])
    }

    private func setSummaryView() {
        view.addSubview(summaryView)

        // TODO: - 여기부터 하기!

        NSLayoutConstraint.activate([
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            summaryView.topAnchor.constraint(equalTo: groupCollectionView.bottomAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            summaryView.bottomAnchor.constraint(equalTo: journeyTogetherButton.topAnchor, constant: -36)
        ])

        setGroupNameView()
    }

    private func setGroupNameView() {

        let groupNameLabel: UILabel = {
           let lbl = UILabel()
            lbl.textColor = UIColor.black
            lbl.font = UIFont.systemFont(ofSize: 14)
            lbl.translatesAutoresizingMaskIntoConstraints = false

            if groupData.count == 0 {
                lbl.text = "------"
            } else {
                lbl.text = "1개 이상"
            }

            return lbl
        }()

        let whiteCircleImageViewLeft: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "circle.fill")  // 시스템 이미지 중 하나를 사용합니다.
            imageView.tintColor = .white
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        let whiteCircleImageViewRight: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "circle.fill")
            imageView.tintColor = .white
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

        summaryView.addSubview(groupNameView)
        groupNameView.addSubview(groupNameLabel)
        groupNameView.addSubview(whiteCircleImageViewLeft)
        groupNameView.addSubview(whiteCircleImageViewRight)
        NSLayoutConstraint.activate([
            groupNameView.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor),
            groupNameView.topAnchor.constraint(equalTo: summaryView.topAnchor),
            groupNameView.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor),
            groupNameView.heightAnchor.constraint(equalToConstant: 48),  // 크기 고정 시킬지 의논해보기

            groupNameLabel.centerXAnchor.constraint(equalTo: groupNameView.centerXAnchor),
            groupNameLabel.centerYAnchor.constraint(equalTo: groupNameView.centerYAnchor),

            whiteCircleImageViewLeft.leadingAnchor.constraint(equalTo: groupNameView.leadingAnchor, constant: 20),
            whiteCircleImageViewLeft.centerYAnchor.constraint(equalTo: groupNameView.centerYAnchor),
            whiteCircleImageViewLeft.widthAnchor.constraint(equalToConstant: 10),
            whiteCircleImageViewLeft.heightAnchor.constraint(equalToConstant: 10),

            whiteCircleImageViewRight.trailingAnchor.constraint(equalTo: groupNameView.trailingAnchor, constant: -20),
            whiteCircleImageViewRight.centerYAnchor.constraint(equalTo: groupNameView.centerYAnchor),
            whiteCircleImageViewRight.widthAnchor.constraint(equalToConstant: 10),
            whiteCircleImageViewRight.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    private func setJourneySummaryView() {
            summaryView.addSubview(journeySummaryView)
            NSLayoutConstraint.activate([
                journeySummaryView.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor),
                journeySummaryView.topAnchor.constraint(equalTo: groupNameView.bottomAnchor),
                journeySummaryView.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor),
                journeySummaryView.bottomAnchor.constraint(equalTo: summaryView.bottomAnchor)
            ])

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
                lbl.translatesAutoresizingMaskIntoConstraints = false
                return lbl
            }()
            journeySummaryView.addSubview(dateLabel)

            NSLayoutConstraint.activate([
                dateLabel.leadingAnchor.constraint(equalTo: journeySummaryView.leadingAnchor, constant: 20),
                dateLabel.topAnchor.constraint(equalTo: journeySummaryView.topAnchor, constant: 20)
            ])
        }

        private func setSentence() {
            // 점선을 그리기 위한 CALayer 생성
            let dottedLineLayer = CAShapeLayer()
            dottedLineLayer.strokeColor = UIColor.gray.cgColor
            dottedLineLayer.lineWidth = 1
            dottedLineLayer.lineDashPattern = [10, 10]  // 점선의 패턴을 설정

            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: view.bounds.width - 40, y: 0)])
            // CAShapeLayer의 path 설정
            dottedLineLayer.path = path

            // CAShapeLayer를 journeySummaryView의 layer에 추가
            journeySummaryView.layer.addSublayer(dottedLineLayer)

            // Auto Layout을 이용해 점선의 위치와 하단 패딩을 설정
            dottedLineLayer.anchorPoint = CGPoint(x: 0, y: 0)
            dottedLineLayer.position = CGPoint(x: 0, y: 300)    // constraint 잡기 (가장 큰 난제,,)

            // 문구
            let bottomLabel: UILabel = {
                let lbl = UILabel()
                lbl.translatesAutoresizingMaskIntoConstraints = false
                lbl.textColor = UIColor.black
                lbl.font = UIFont.systemFont(ofSize: 14)
                lbl.textAlignment = .center
                return lbl
            }()

            journeySummaryView.addSubview(bottomLabel)
            NSLayoutConstraint.activate([
                bottomLabel.centerXAnchor.constraint(equalTo: journeySummaryView.centerXAnchor),
                bottomLabel.bottomAnchor.constraint(equalTo: journeySummaryView.bottomAnchor, constant: -20)
            ])

            if groupData.count == 0 {   // 데이터 없다면
                bottomLabel.text = "세션관리에서 여정을 만들어 보세요."
            } else {
                bottomLabel.text = "오늘도 즐거운 여정을 시작해 보세요!"
            }
        }

        private func countGroupData() {
            if groupData.count == 0 {
                setViewWithoutGroup()
            } else { }
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

        countGroupData()

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
