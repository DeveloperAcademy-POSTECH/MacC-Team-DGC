import UIKit

final class SessionStartView: UIView {

    //TODO: - DB 형식 나오면 GroupData 모델 변경, 추후 setupConstraints() 생성
    // 더미 데이터
        let groupData: [GroupData]? = [
            GroupData(image: UIImage(systemName: "heart"), groupName: "group1", start: "양덕", end: "C5",
                      startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
            GroupData(image: UIImage(systemName: "circle"), groupName: "group2", start: "포항", end: "부산",
                      startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
            GroupData(image: UIImage(systemName: "heart.fill"), groupName: "group3", start: "인천", end: "서울",
                      startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
            GroupData(image: UIImage(systemName: "circle.fill"), groupName: "group4", start: "부평", end: "일산",
                      startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4),
            GroupData(image: UIImage(systemName: "square"), groupName: "group5", start: "서울", end: "포항",
                      startTime: "08:30", endTime: "9:00", date: "주중(월 - 금)", total: 4)
        ]
    // 데이터가 없을 때
//    let groupData: [GroupData]? = nil

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

    // 그룹이 없을 때 컬렉션 뷰 대신 보여주는 뷰입니다. -> 삭제?
    let sessionStartBorderLayer = CAShapeLayer()
    lazy var viewWithoutCrew: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true

        return view
    }()
    // viewWithoutCrew 안에 있는 라벨 추가  -> 삭제?
    let noGroupCommentlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "아직 만들어진 여정이 없어요...\n친구와 함께 여정을 시작해보세요!"
        lbl.textColor = UIColor.semantic.textBody
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont.carmuFont.subhead3
        return lbl
    }()

    // 그룹 이름을 알려주는 뷰(groupNameView)와 여정을 요약해주는 뷰(journeySummaryView)의 상위 뷰입니다. -> MVP 개발 이후에 변경 예정
    let summaryView: UIView = {
        let view = UIView()
        return view
    }()

    // 그룹 이름을 알려주는 뷰입니다.
    let groupNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground  // TODO: - 색상 변경하기
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    let groupNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 14)
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

    // 여정을 요약해주는 뷰입니다.
    let journeySummaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.theme.blue3?.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        return view
    }()

    // journeySummaryView의 컴포넌트
    let startView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.blue4
        view.layer.cornerRadius = 14

        return view
    }()
    let startLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "출발"
        lbl.textColor = .white
        lbl.font = UIFont.carmuFont.subhead2
        return lbl
    }()
    let startLocation: UILabel = {
        let lbl = UILabel()
        lbl.text = "양덕" // 출발지
        lbl.textColor = .black
        lbl.font = UIFont.carmuFont.display2
        lbl.textAlignment = .center
        return lbl
    }()
    let startTime: UILabel = {
        let lbl = UILabel()
        lbl.text = "00 : 00"
        lbl.textColor = UIColor.theme.darkblue4
        lbl.font = UIFont.carmuFont.body3
        lbl.textAlignment = .center
        return lbl
    }()
    let arrowLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "→"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.textColor = .black
        return lbl
    }()
    let endView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.blue4
        view.layer.cornerRadius = 14

        return view
    }()
    let endLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "도착"
        lbl.textColor = .white
        lbl.font = UIFont.carmuFont.subhead2
        return lbl
    }()
    let endLocation: UILabel = {
        let lbl = UILabel()
        lbl.text = "C5" // 출발지
        lbl.textColor = .black
        lbl.font = UIFont.carmuFont.display2
        lbl.textAlignment = .center
        return lbl
    }()
    let endTime: UILabel = {
        let lbl = UILabel()
        lbl.text = "00 : 00"
        lbl.textColor = UIColor.theme.darkblue4
        lbl.font = UIFont.carmuFont.body3
        lbl.textAlignment = .center
        return lbl
    }()

    // 변환된 날짜를 UILabel에 표시 -> 삭제?
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.theme.blue8
        lbl.font = UIFont.carmuFont.body2Long
        return lbl
    }()
    let noGroupComment: UILabel = { // 삭제?
        let lbl = UILabel()
        lbl.text = "초대하거나 받은 여정이 없어요...\n친구와 함께 여정을 시작해 보세요!"   // TODO: - Text 변경하기
        lbl.textColor = UIColor.semantic.textBody
        lbl.font = UIFont.carmuFont.headline1
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()

    // 해당 그룹의 여정 요일에 대한 뷰입니다.
    let dayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.semantic.textDisableBT?.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    let calendarImage: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(systemName: "calendar") {
            imageView.image = image
            imageView.tintColor = UIColor.semantic.accPrimary
        }
        return imageView
    }()
    let dayLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.font = UIFont.carmuFont.body2Long
        return lbl
    }()

    // 해당 그룹의 인원 수에 대한 뷰입니다.
    let personCountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // 배경색을 설정할 수 있습니다.
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.semantic.textDisableBT?.cgColor
        view.layer.cornerRadius = 20 // 원하는 모양으로 뷰를 꾸밀 수 있습니다.
        return view
    }()
    let personImage: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(systemName: "person.2") {
            imageView.image = image
            imageView.tintColor = UIColor.semantic.accPrimary
        }
        return imageView
    }()
    let personLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.semantic.textPrimary
        lbl.font = UIFont.carmuFont.body2Long
        return lbl
    }()

    // 점선과 문구
    let dottedLineLayer = CAShapeLayer()
    let bottomLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.semantic.textBody
        lbl.font = UIFont.carmuFont.body2
        lbl.textAlignment = .center
        return lbl
    }()

    // 여정 시작하기 버튼
    let journeyTogetherButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("여정 시작하기", for: .normal)
        btn.backgroundColor = UIColor.semantic.accPrimary
        btn.titleLabel?.font = UIFont.carmuFont.headline2
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 30
        return btn
    }()

    // 기타 부수 사항
    let insetRatio: CGFloat = 88.0 / UIScreen.main.bounds.height

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func draw(_ rect: CGRect) {
        setCollectionView()
        setJourneyTogetherButton()
        countGroupData()
        setSummaryView()
        setJourneySummaryView()
    }

}
