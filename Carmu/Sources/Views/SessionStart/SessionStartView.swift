import UIKit

final class SessionStartView: UIView {

    lazy var myPageButton: UIButton = {
        let button = UIButton()
        if let myPageImage = UIImage(named: "myPageButton") {
            let resizedImage = myPageImage.resizedImage(targetSize: CGSize(width: 48, height: 48))
            button.setImage(resizedImage, for: .normal)
        }
        return button
    }()

    lazy var topComment: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline2
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    lazy var notifyComment: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.carmuFont.body3Long
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    lazy var individualButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.semantic.negative
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.headline1
        button.layer.cornerRadius = 30
        return button
    }()

    lazy var togetherButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.semantic.accPrimary
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.headline1
        button.layer.cornerRadius = 30
        return button
    }()

    lazy var carpoolStartButton: UIButton = {
        let button = UIButton()
        button.setTitle("카풀 운행하기", for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.headline2
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor.semantic.accPrimary
        return button
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
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(20)
        }
        topComment.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(myPageButton.snp.bottom)
        }
    }

    // TODO: - 그룹있을 때 notifyComment, individualButton, togetherButton constraints 설정하기
}
