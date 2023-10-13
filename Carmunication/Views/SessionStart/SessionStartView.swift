import UIKit

final class SessionStartView: UIView {

    // TODO: - 추후 setupConstraints() 생성

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
        lbl.font = UIFont.carmuFont.headline1
        return lbl
    }()
    let whiteCircleImageViewLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = UIColor.semantic.accPrimary
        return imageView
    }()
    let whiteCircleImageViewRight: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = UIColor.semantic.accPrimary
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
        view.layer.cornerRadius = 12

        return view
    }()
    lazy var startGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = startView.bounds
        gradient.cornerRadius = 12
        gradient.colors = [
            UIColor.theme.blue6!.cgColor,
            UIColor.theme.acua5!.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
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
    lazy var endGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = endView.bounds
        gradient.cornerRadius = 12
        gradient.colors = [
            UIColor.theme.blue6!.cgColor,
            UIColor.theme.acua5!.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
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

    let dottedLineLayer = CAShapeLayer()
    let bottomLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.semantic.textBody
        lbl.font = UIFont.carmuFont.body2
        lbl.textAlignment = .center
        return lbl
    }()

    // 여정 알리기 버튼
    let journeyTogetherButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("여정 알리기", for: .normal)
        btn.backgroundColor = UIColor.semantic.accPrimary
        btn.titleLabel?.font = UIFont.carmuFont.headline2
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}
