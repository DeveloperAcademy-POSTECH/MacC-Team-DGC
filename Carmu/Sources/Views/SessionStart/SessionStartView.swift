import UIKit

final class SessionStartView: UIView {

    lazy var myPageButton: UIButton = {
        let btn = UIButton()
        if let myPageImage = UIImage(named: "myPageButton") {
            let resizedImage = myPageImage.resizedImage(targetSize: CGSize(width: 48, height: 48))
            btn.setImage(resizedImage, for: .normal)
        }
        return btn
    }()

    lazy var topComment: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.carmuFont.headline2
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private lazy var notifyComment: UILabel = {
        let lbl = UILabel()
        lbl.text = "운전자의 전달여부"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = UIFont.carmuFont.body3Long

        return lbl
    }()

    private lazy var leftButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("왼쪽", for: .normal)

        return btn
    }()

    private lazy var rightButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("오른쪽", for: .normal)

        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

// MARK: - Layout
extension SessionStartView {

    private func setupUI() {
        addSubview(myPageButton)
        addSubview(topComment)
        addSubview(notifyComment)
        addSubview(leftButton)
        addSubview(rightButton)
    }

    private func setupConstraints() {
        myPageButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.trailing.equalToSuperview().inset(20)
        }
        topComment.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(myPageButton.snp.bottom)

        }
    }

    // TODO: - 그룹있을 때 notifyComment, leftButton, rightButton constraints 설정하기

}
