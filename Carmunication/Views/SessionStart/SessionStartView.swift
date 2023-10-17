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

    // 여정 알리기 버튼
    let journeyTogetherButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("여정 알리기", for: .normal)
        btn.backgroundColor = UIColor.semantic.accPrimary
        btn.titleLabel?.font = UIFont.carmuFont.headline2
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()

    // 동승자일 때 버튼
    let noRideButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("따로가기", for: .normal)
        btn.backgroundColor = UIColor.semantic.backgroundSecond
        btn.titleLabel?.font = UIFont.carmuFont.headline2
        return btn
    }()
    let participateButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("참여하기", for: .normal)
        btn.backgroundColor = UIColor.semantic.backgroundSecond
        btn.titleLabel?.font = UIFont.carmuFont.headline2
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGroupData()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGroupData()
    }

    override func draw(_ rect: CGRect) {
        setCollectionView()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }

    private func setupUI() {

        addSubview(groupCollectionView)
        addSubview(journeyTogetherButton)
        addSubview(noRideButton)
        addSubview(participateButton)
    }

    private func setCollectionView() {
        groupCollectionView.backgroundColor = .white

        let collectionViewHeight: CGFloat
        if UIScreen.main.bounds.height >= 800 {
            // iPhone 14와 같이 큰 화면
            collectionViewHeight = 104
        } else {
            // iPhone SE와 같이 작은 화면
            collectionViewHeight = 84
        }

        groupCollectionView.snp.makeConstraints { make in
            make.height.equalTo(collectionViewHeight)
            make.top.lessThanOrEqualTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview()
        }
    }

    private func setupGroupData() {

        // 그룹이 없을 때 나타내는 정보들
        if groupData == nil {
            journeyTogetherButton.setTitleColor(UIColor.theme.blue3, for: .normal)
            journeyTogetherButton.backgroundColor = UIColor.semantic.backgroundSecond
            journeyTogetherButton.isEnabled = false
        }
    }
}
