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

    let titleLabel: UILabel = {
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
        addSubview(titleLabel)
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
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(myPageButton.snp.bottom)
        }
    }

    func setTitleLabel(crewData: Crew?) {
        guard let crewData = crewData else {
            setTitleLabelNoCrew()
            return
        }
    }

    private func setTitleLabelNoCrew() {
        titleLabel.text = "오늘도 카뮤와 함께\n즐거운 하루되세요!"
        let attributedText = NSMutableAttributedString(string: titleLabel.text ?? "")
        if let range1 = titleLabel.text?.range(of: "카뮤") {
            let nsRange1 = NSRange(range1, in: titleLabel.text ?? "")
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.semantic.accPrimary as Any, range: nsRange1)
        }
        titleLabel.attributedText = attributedText
    }
}
