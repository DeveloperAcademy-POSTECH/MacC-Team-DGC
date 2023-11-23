import UIKit

final class SessionStartView: UIView {

    private let firebaseManger = FirebaseManager()
    private let textColor = UIColor.semantic.accPrimary ?? .blue

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

    let shuttleStartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.carmuFont.headline2
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor.semantic.accPrimary
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        addSubview(myPageButton)
        myPageButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(20)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(myPageButton.snp.bottom)
        }

        addSubview(notifyComment)

        let outerPadding = 20
        let innerPadding = frame.size.width / 2 + 5
        let bottomPadding = 64

        addSubview(individualButton)
        individualButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(outerPadding)
            make.trailing.equalToSuperview().inset(innerPadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
            make.height.equalTo(60)
        }

        addSubview(togetherButton)
        togetherButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(innerPadding)
            make.trailing.equalToSuperview().inset(outerPadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
            make.height.equalTo(60)
        }

        addSubview(shuttleStartButton)
        shuttleStartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(outerPadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
            make.height.equalTo(60)
        }
    }
}

// MARK: - titleLabel 관련
extension SessionStartView {

    func setTitleLabel(crewData: Crew?) {
        guard let crewData = crewData else {
            setTitleLabelNoCrew()
            return
        }
        if firebaseManger.isDriver(crewData: crewData) {
            setTitleForDriver(crewData: crewData)
        } else {
            setTitleForMember(crewData: crewData)
        }
    }

    private func setTitleLabelNoCrew() {
        titleLabel.text = "오늘도 카뮤와 함께\n즐거운 하루되세요!"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: ["카뮤"], color: textColor)
    }

    private func setTitleForDriver(crewData: Crew) {
        switch crewData.sessionStatus {
        case .waiting:
            setTitleDriverWaiting(crewData: crewData)
        case .decline:
            titleLabel.text = ""
        case .accept:
            setTitleDriverAccept(crewData: crewData)
        case .sessionStart:
            setTitleDriverSessionStart(crewData: crewData)
        case .none:
            break
        }
    }

    private func setTitleForMember(crewData: Crew) {
        switch crewData.sessionStatus {
        case .decline:
            titleLabel.text = ""
        case .waiting:
            setTitleMemberDefault(crewData: crewData)
        case .accept:
            if firebaseManger.passengerStatus(crewData: crewData) == .decline {
                titleLabel.text = ""
            } else {
                setTitleMemberDefault(crewData: crewData)
            }
        case .sessionStart:
            setTitleMemberSessionStart(crewData: crewData)
        case .none:
            break
        }
    }

    private func setTitleDriverWaiting(crewData: Crew) {
        let crewName = crewData.name ?? ""
        titleLabel.text = "\(crewName),\n오늘 운행하시나요?"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: textColor)
    }

    private func setTitleDriverAccept(crewData: Crew) {
        if firebaseManger.isAnyMemberAccepted(crewData: crewData) {
            let crewName = crewData.name ?? ""
            titleLabel.text = "\(crewName),\n운행을 시작해볼까요?"
            titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: textColor)
        } else {
            titleLabel.text = "탑승자들의\n응답을 기다립니다"
            titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: ["탑승자들", "응답"], color: textColor)
        }
    }

    private func setTitleDriverSessionStart(crewData: Crew) {
        let crewName = crewData.name ?? ""
        titleLabel.text = "\(crewName),\n안전 운행하세요"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: textColor)
    }

    private func setTitleMemberSessionStart(crewData: Crew) {
        let crewName = crewData.name ?? ""
        titleLabel.text = "\(crewName)이\n시작되었습니다!"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: textColor)
    }

    private func setTitleMemberDefault(crewData: Crew) {
        let crewName = crewData.name ?? ""
        titleLabel.text = "\(crewName)과\n함께 가시나요?"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: textColor)
    }

    private func setColorToLabel(text: String?, coloredTexts: [String], color: UIColor) -> NSMutableAttributedString {
        let topCommentText = NSMutableAttributedString(string: titleLabel.text ?? "")
        for coloredText in coloredTexts {
            if let range = titleLabel.text?.range(of: coloredText) {
                let nsRange = NSRange(range, in: text ?? "")
                topCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: nsRange)
            }
        }
        return topCommentText
    }
}

// MARK: - 하단 버튼 관련
extension SessionStartView {

    func setBottomButton(crewData: Crew?) {
        guard let crewData = crewData else {
            setBottomButtonNoCrew()
            return
        }
        if firebaseManger.isDriver(crewData: crewData) {
            setBottomButtonForDriver(crewData: crewData)
        } else {
            setBottomButtonForMember(crewData: crewData)
        }
    }

    private func setBottomButtonNoCrew() {
        individualButton.isHidden = true
        togetherButton.isHidden = true
        shuttleStartButton.isHidden = true
    }

    private func setBottomButtonForDriver(crewData: Crew) {
        switch crewData.sessionStatus {
        case .waiting:
            setBottomButtonDriverWaiting(crewData: crewData)
        case .decline:
            setBottomButtonDriverDecline(crewData: crewData)
        case .accept:
            setBottomButtonDriverAccept(crewData: crewData)
        case .sessionStart:
            setBottomButtonDriverSessionStart(crewData: crewData)
        case .none: break
        }
    }

    private func setBottomButtonForMember(crewData: Crew) {
        if crewData.sessionStatus == .decline {
            setBottomButtonMemberDecline(crewData: crewData)
            return
        }
        if crewData.sessionStatus == .sessionStart {
            if firebaseManger.passengerStatus(crewData: crewData) == .accept {
                setBottomButtonMemberSessionStart(crewData: crewData)
            } else {
                setBottomButtonMemberDecline(crewData: crewData)
            }
            return
        }

        switch firebaseManger.passengerStatus(crewData: crewData) {
        case .waiting:
            setBottomButtonMemberWaiting(crewData: crewData)
        case .accept:
            setBottomButtonMemberAccept(crewData: crewData)
        case .decline:
            setBottomButtonMemberDecline(crewData: crewData)
        case .sessionStart:
            break
        }
    }

    private func setBottomButtonDriverWaiting(crewData: Crew) {
        individualButton.isHidden = false
        togetherButton.isHidden = false
        shuttleStartButton.isHidden = true

        individualButton.setTitle("운행하지 않아요", for: .normal)
        togetherButton.setTitle("운행해요", for: .normal)

        individualButton.backgroundColor = UIColor.semantic.negative
        togetherButton.backgroundColor = UIColor.semantic.accPrimary

        individualButton.isEnabled = true
        togetherButton.isEnabled = true
    }

    private func setBottomButtonDriverDecline(crewData: Crew) {
        individualButton.isHidden = false
        togetherButton.isHidden = false
        shuttleStartButton.isHidden = true

        individualButton.setTitle("운행하지 않아요", for: .normal)
        togetherButton.setTitle("운행해요", for: .normal)

        individualButton.backgroundColor = UIColor.semantic.backgroundThird
        togetherButton.backgroundColor = UIColor.semantic.backgroundThird

        individualButton.isEnabled = false
        togetherButton.isEnabled = false
    }

    private func setBottomButtonDriverAccept(crewData: Crew) {
        individualButton.isHidden = true
        togetherButton.isHidden = true
        shuttleStartButton.isHidden = false
        shuttleStartButton.setTitle("셔틀 운행하기", for: .normal)

        if firebaseManger.isAnyMemberAccepted(crewData: crewData) {
            shuttleStartButton.backgroundColor = UIColor.semantic.accPrimary
            shuttleStartButton.isEnabled = true
        } else {
            shuttleStartButton.backgroundColor = UIColor.semantic.backgroundThird
            shuttleStartButton.isEnabled = false
        }
    }

    private func setBottomButtonDriverSessionStart(crewData: Crew) {
        individualButton.isHidden = true
        togetherButton.isHidden = true
        shuttleStartButton.isHidden = false

        shuttleStartButton.setTitle("셔틀 지도보기", for: .normal)
        shuttleStartButton.backgroundColor = UIColor.semantic.accPrimary
        shuttleStartButton.isEnabled = true
    }

    private func setBottomButtonMemberWaiting(crewData: Crew) {
        individualButton.isHidden = false
        togetherButton.isHidden = false
        shuttleStartButton.isHidden = true

        individualButton.setTitle("따로가요", for: .normal)
        togetherButton.setTitle("함께가요", for: .normal)

        individualButton.backgroundColor = UIColor.semantic.negative
        togetherButton.backgroundColor = UIColor.semantic.accPrimary

        individualButton.isEnabled = true
        togetherButton.isEnabled = true
    }

    private func setBottomButtonMemberDecline(crewData: Crew) {
        individualButton.isHidden = false
        togetherButton.isHidden = false
        shuttleStartButton.isHidden = true

        individualButton.setTitle("따로가요", for: .normal)
        togetherButton.setTitle("함께가요", for: .normal)

        individualButton.backgroundColor = UIColor.semantic.backgroundThird
        individualButton.isEnabled = false

        if crewData.sessionStatus == .waiting {
            togetherButton.backgroundColor = UIColor.semantic.accPrimary
            togetherButton.isEnabled = true
        } else {
            togetherButton.backgroundColor = UIColor.semantic.backgroundThird
            togetherButton.isEnabled = false
        }
    }

    private func setBottomButtonMemberAccept(crewData: Crew) {
        individualButton.isHidden = false
        togetherButton.isHidden = false
        shuttleStartButton.isHidden = true

        individualButton.setTitle("따로가요", for: .normal)
        togetherButton.setTitle("함께가요", for: .normal)

        individualButton.backgroundColor = UIColor.semantic.negative
        togetherButton.backgroundColor = UIColor.semantic.backgroundThird

        individualButton.isEnabled = true
        togetherButton.isEnabled = false
    }

    private func setBottomButtonMemberSessionStart(crewData: Crew) {
        individualButton.isHidden = true
        togetherButton.isHidden = true
        shuttleStartButton.isHidden = false

        shuttleStartButton.setTitle("셔틀 지도보기", for: .normal)
        shuttleStartButton.backgroundColor = UIColor.semantic.accPrimary
        shuttleStartButton.isEnabled = true
    }
}
