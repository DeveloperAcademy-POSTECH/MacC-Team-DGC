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
}
