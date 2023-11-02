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
        lbl.text = "오늘도 카뮤와 함께\n즐거운 카풀 생활되세요!"
        lbl.font = UIFont.carmuFont.headline2
        lbl.textAlignment = .left
        lbl.numberOfLines = 0

        let attributedText = NSMutableAttributedString(string: lbl.text ?? "")
        if let range1 = lbl.text?.range(of: "카뮤") {
            let nsRange1 = NSRange(range1, in: lbl.text!)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange1)
        }
        if let range2 = lbl.text?.range(of: "카풀 생활") {
            let nsRange2 = NSRange(range2, in: lbl.text!)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.semantic.accPrimary as Any,
                                        range: nsRange2)
        }
        lbl.attributedText = attributedText

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
