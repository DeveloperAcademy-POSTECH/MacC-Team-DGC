import UIKit

final class SessionStartView: UIView {

    // 더미 데이터
    //    let groupData: [GroupData]? = [
    //        GroupData(image: UIImage(systemName: "heart"), groupName: "group1", start: "양덕", end: "C5",
    //                  startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
    //        GroupData(image: UIImage(systemName: "circle"), groupName: "group2", start: "포항", end: "부산",
    //                  startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
    //        GroupData(image: UIImage(systemName: "heart.fill"), groupName: "group3", start: "인천", end: "서울",
    //                  startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
    //        GroupData(image: UIImage(systemName: "circle.fill"), groupName: "group4", start: "부평", end: "일산",
    //                  startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
    //        GroupData(image: UIImage(systemName: "square"), groupName: "group5", start: "서울", end: "포항",
    //                  startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4)
    //    ]

    // 데이터가 없을 때
    let groupData: [GroupData]? = nil

    // 상단 그룹에 대한 컬렉션뷰입니다.
    let groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal    // 좌우로 스크롤
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 여백 조정

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: "groupCell")
        collectionView.showsHorizontalScrollIndicator = false   // 스크롤바 숨기기
        return collectionView
    }()

    let journeyTogetherButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("여정 함께하기", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = 30
        return btn
    }()

    // 그룹이 없을 때 보여주는 뷰입니다.
    let sessionStartBorderLayer = CAShapeLayer()
    lazy var viewWithoutCrew: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true

        return view
    }()

    // 그룹 이름을 알려주는 뷰와 여정을 요약해주는 뷰의 상위 뷰입니다.
    let summaryView: UIView = {
        let view = UIView()
        return view
    }()

    // 그룹 이름을 알려주는 뷰입니다.
    let groupNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink  // TODO: - 색상 변경하기
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    // 여정을 요약해주는 뷰입니다.
    let journeySummaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    // 해당 그룹의 여정 요일에 대한 뷰입니다.
    let dayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // 배경색을 설정할 수 있습니다.
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.cornerRadius = 20 // 원하는 모양으로 뷰를 꾸밀 수 있습니다.
        return view
    }()

    // 해당 그룹의 인원 수에 대한 뷰입니다.
    let personCountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // 배경색을 설정할 수 있습니다.
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.cornerRadius = 20 // 원하는 모양으로 뷰를 꾸밀 수 있습니다.
        return view
    }()

    // 점선
    let dottedLineLayer = CAShapeLayer()

    let startView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemMint
        view.layer.cornerRadius = 16

        return view
    }()
    let startLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "출발"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    let arrowLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "->"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.textColor = .black
        return lbl
    }()
    let endView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemMint
        view.layer.cornerRadius = 16

        return view
    }()
    let endLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "도착"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        setCollectionView()
        setJourneyTogetherButton()
        countGroupData()
        setSummaryView()
        setJourneySummaryView()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        sessionStartBorderLayer.frame = viewWithoutCrew.bounds
        sessionStartBorderLayer.path = UIBezierPath(roundedRect: viewWithoutCrew.bounds, cornerRadius: 20).cgPath
    }

    private func setCollectionView() {
        addSubview(groupCollectionView)
        groupCollectionView.backgroundColor = .white
        groupCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(110)    // TODO: - 크기 조정
        }
    }

    private func setJourneyTogetherButton() {
        addSubview(journeyTogetherButton)
        journeyTogetherButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(120)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60) // TODO: - 크기 조정
        }
    }

    private func countGroupData() {

        if groupData == nil {
            setViewWithoutGroup()
        }
    }

    private func setViewWithoutGroup() {
        addSubview(viewWithoutCrew)

        viewWithoutCrew.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(110)
        }

        // 해당 뷰 안에 있는 라벨 추가
        let label = UILabel()
        label.text = "아직 만들어진 여정이 없어요...\n친구와 함께 여정을 시작해보세요!"
        label.textColor = UIColor.semantic.textBody
        label.textAlignment = .center
        label.numberOfLines = 0  // 0으로 설정하면 자동으로 줄 바꿈이 됩니다.
        label.font = CarmuFont().subhead3

        // UILabel을 viewWithoutCrew의 서브뷰로 추가
        viewWithoutCrew.addSubview(label)

        label.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(viewWithoutCrew)
        }
        // 점선 설정
        setupDashLine()
    }

    private func setSummaryView() {
        addSubview(summaryView)

        summaryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(journeyTogetherButton.snp.top).inset(-36)
            make.top.equalTo(groupData == nil ? viewWithoutCrew.snp.bottom : groupCollectionView.snp.bottom).inset(-16)
        }
        setGroupNameView()
    }

    private func setGroupNameView() {

        let groupNameLabel: UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.black
            lbl.font = UIFont.systemFont(ofSize: 14)
            lbl.text = groupData == nil ? "------" : "1개 이상"
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

        // MARK: - SessionStartView+Extension에 정의
        // 오늘의 날짜를 보여주는 메서드
        setTodayDate()

        // 요일과 인원을 알려주는 뷰
        setDayAndPerson()

        // 문구를 관리하는 메서드
        setSentence()
    }
}
