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

    lazy var notifyComment: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = UIFont.carmuFont.body3Long
        lbl.textColor = UIColor.semantic.textBody
        return lbl
    }()

    lazy var individualButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.semantic.negative
        btn.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        btn.titleLabel?.font = UIFont.carmuFont.headline1
        btn.layer.cornerRadius = 30
        return btn
    }()

    lazy var togetherButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.semantic.accPrimary
        btn.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        btn.titleLabel?.font = UIFont.carmuFont.headline1
        btn.layer.cornerRadius = 30
        return btn
    }()

    lazy var carpoolStartButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("여정 지금 시작하기", for: .normal)
        btn.titleLabel?.font = UIFont.carmuFont.headline2
        btn.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        btn.layer.cornerRadius = 30
        btn.backgroundColor = UIColor.semantic.accPrimary
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
        addSubview(individualButton)
        addSubview(togetherButton)
        addSubview(carpoolStartButton)
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

    // TODO: - 그룹있을 때 notifyComment, individualButton, togetherButton constraints 설정하기

}
