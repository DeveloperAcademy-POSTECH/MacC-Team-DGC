import UIKit

final class SessionStartView: UIView {

    private let firebaseManager = FirebaseManager()
    private let titleLabelTintColor = UIColor.semantic.accPrimary ?? .blue
    private let underLabelTintColor = UIColor.semantic.textTertiary ?? .blue

    let myPageButton: UIButton = {
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

    let underLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.carmuFont.body3Long
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    let individualButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.semantic.negative
        button.setTitleColor(UIColor.semantic.textSecondary, for: .normal)
        button.titleLabel?.font = UIFont.carmuFont.headline1
        button.layer.cornerRadius = 30
        return button
    }()

    let togetherButton: UIButton = {
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

        addSubview(underLabel)
        underLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(142.5)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

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
        if firebaseManager.isDriver(crewData: crewData) {
            setTitleForDriver(crewData: crewData)
        } else {
            setTitleForMember(crewData: crewData)
        }
    }

    private func setTitleLabelNoCrew() {
        titleLabel.text = "오늘도 카뮤와 함께\n즐거운 하루되세요!"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: ["카뮤"], color: titleLabelTintColor)
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
            if firebaseManager.passengerStatus(crewData: crewData) == .decline {
                titleLabel.text = ""
            } else {
                setTitleMemberDefault(crewData: crewData)
            }
        case .sessionStart:
            if firebaseManager.passengerStatus(crewData: crewData) == .accept {
                setTitleMemberSessionStart(crewData: crewData)
            } else {
                titleLabel.text = ""
            }
        case .none:
            break
        }
    }

    private func setTitleDriverWaiting(crewData: Crew) {
        let crewName = crewData.name ?? ""
        titleLabel.text = "\(crewName),\n오늘 운행하시나요?"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: titleLabelTintColor)
    }

    private func setTitleDriverAccept(crewData: Crew) {
        if firebaseManager.isAnyMemberAccepted(crewData: crewData) {
            let crewName = crewData.name ?? ""
            titleLabel.text = "\(crewName),\n운행을 시작해볼까요?"
            titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: titleLabelTintColor)
        } else {
            titleLabel.text = "탑승자들의\n응답을 기다립니다"
            titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: ["탑승자들", "응답"], color: titleLabelTintColor)
        }
    }

    private func setTitleDriverSessionStart(crewData: Crew) {
        let crewName = crewData.name ?? ""
        titleLabel.text = "\(crewName),\n안전 운행하세요"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: titleLabelTintColor)
    }

    private func setTitleMemberSessionStart(crewData: Crew) {
        let crewName = crewData.name ?? ""
        titleLabel.text = "\(crewName)이\n시작되었습니다!"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: titleLabelTintColor)
    }

    private func setTitleMemberDefault(crewData: Crew) {
        let crewName = crewData.name ?? ""
        titleLabel.text = "\(crewName)과\n함께 가시나요?"
        titleLabel.attributedText = setColorToLabel(text: titleLabel.text, coloredTexts: [crewName], color: titleLabelTintColor)
    }

    private func setColorToLabel(text: String?, coloredTexts: [String], color: UIColor) -> NSMutableAttributedString {
        let topCommentText = NSMutableAttributedString(string: text ?? "")
        // 행간 조절

        for coloredText in coloredTexts {
            if let range = text?.range(of: coloredText) {
                let nsRange = NSRange(range, in: text ?? "")
                topCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: nsRange)
            }
        }
        return topCommentText
    }
}

// MARK: - under Label 관련
extension SessionStartView {

    func setUnderLabel(crewData: Crew?) {
        guard let crewData = crewData else {
            setUnderLabelNoCrew()
            return
        }
        if firebaseManager.isDriver(crewData: crewData) {
            setUnderForDriver(crewData: crewData)
        } else {
            setUnderForMember(crewData: crewData)
        }
    }

    private func setUnderLabelNoCrew() {
        underLabel.text = ""
    }

    private func setUnderForDriver(crewData: Crew) {
        switch crewData.sessionStatus {
        case .waiting:
            setUnderDriverWaiting()
        case .decline:
            setUnderDriverDecline(crewData: crewData)
        case .accept:
            setUnderDriverAccept(crewData: crewData)
        case .sessionStart:
            setUnderDriverSessionStart(crewData: crewData)
        case .none:
            break
        }
    }

    private func setUnderForMember(crewData: Crew) {
        if crewData.sessionStatus == .decline {
            underLabel.text = "기사님의 사정으로\n오늘은 셔틀이 운행되지 않아요"
            underLabel.attributedText = setColorAndLineHeightToLabel(text: underLabel.text, coloredTexts: [], color: underLabelTintColor, lineHeight: 8)
            return
        }
        switch firebaseManager.passengerStatus(crewData: crewData) {
        case .waiting:
            setUnderMemberWaiting(crewData: crewData)
        case .accept:
            if crewData.sessionStatus == .sessionStart {
                setUnderMemberSessionStart()
            } else {
                setUnderMemberAccept()
            }
        case .decline:
            setUnderMemberDecline(crewData: crewData)
        case .sessionStart:
            break
        }
    }

    // MARK: - Driver 상황별 텍스트 변경 메서드
    private func setUnderDriverWaiting() {
        underLabel.text = "오늘의 셔틀 운행 여부를\n출발시간 30분 전까지 알려주세요!"
        underLabel.attributedText = setColorAndLineHeightToLabel(text: underLabel.text, coloredTexts: ["30분 전"], color: underLabelTintColor)
    }

    private func setUnderDriverDecline(crewData: Crew) {
        underLabel.text = "오늘의 카풀 운행 여부를\n전달했어요"
        underLabel.attributedText = setColorAndLineHeightToLabel(text: underLabel.text, coloredTexts: [" "], color: underLabelTintColor)
    }

    private func setUnderDriverAccept(crewData: Crew) {
        if firebaseManager.isAnyMemberAccepted(crewData: crewData) {
            underLabel.text = "현재 탑승 응답한 탑승자들과 셔틀을 시작할까요?"
        } else {
            underLabel.text = "오늘의 셔틀 운행 여부를 전달했어요\n탑승 응답을 확인중입니다..."
            underLabel.attributedText = setColorAndLineHeightToLabel(text: underLabel.text, coloredTexts: [" "], color: underLabelTintColor)
        }
    }

    private func setUnderDriverSessionStart(crewData: Crew) {
        underLabel.text = "현재 운행 중인 셔틀이 있습니다\n셔틀 지도보기를 눌러주세요!"
        underLabel.attributedText = setColorAndLineHeightToLabel(text: underLabel.text, coloredTexts: ["현재 운행중인 셔틀", "셔틀 지도보기"], color: underLabelTintColor)
    }

    private func setUnderMemberWaiting(crewData: Crew) {
        if crewData.sessionStatus == .sessionStart {
            underLabel.text = ""
        } else {
            underLabel.text = "오늘의 셔틀 탑승 여부를\n탑승시간 20분 전까지 알려주세요!"
            underLabel.attributedText = setColorAndLineHeightToLabel(text: underLabel.text, coloredTexts: ["20분 전"], color: underLabelTintColor)
        }
    }

    private func setUnderMemberDecline(crewData: Crew) {
        if crewData.sessionStatus == .waiting {
            underLabel.text = "따로가기를 선택하셨네요!\n기사님에게 알려드릴게요"
            underLabel.attributedText = setColorAndLineHeightToLabel(text: underLabel.text, coloredTexts: [" "], color: underLabelTintColor)
        } else {
            underLabel.text = ""
        }
    }

    private func setUnderMemberAccept() {
        underLabel.text = "함께가기를 선택하셨네요!\n기사님에게 알려드릴게요"
        underLabel.attributedText = setColorAndLineHeightToLabel(text: underLabel.text, coloredTexts: [" "], color: underLabelTintColor)
    }

    private func setUnderMemberSessionStart() {
        underLabel.text = "운전자의 위치를 보려면\n셔틀 지도보기를 눌러주세요!"
        underLabel.attributedText = setColorAndLineHeightToLabel(text: underLabel.text, coloredTexts: ["셔틀 지도보기"], color: underLabelTintColor)
    }

    private func setColorAndLineHeightToLabel(text: String?, coloredTexts: [String], color: UIColor, lineHeight: CGFloat = 8.0) -> NSMutableAttributedString {
        let topCommentText = NSMutableAttributedString(string: text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        paragraphStyle.alignment = .center

        for coloredText in coloredTexts {
            if let range = text?.range(of: coloredText) {
                let nsRange = NSRange(range, in: text ?? "")
                topCommentText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: nsRange)
                topCommentText.addAttribute(
                    NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: topCommentText.length)
                )
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
        if firebaseManager.isDriver(crewData: crewData) {
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
            if firebaseManager.passengerStatus(crewData: crewData) == .accept {
                setBottomButtonMemberSessionStart(crewData: crewData)
            } else {
                setBottomButtonMemberDecline(crewData: crewData)
            }
            return
        }

        switch firebaseManager.passengerStatus(crewData: crewData) {
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
        individualButton.showButton(title: "운행하지 않아요", buttonColor: UIColor.semantic.negative)
        togetherButton.showButton(title: "운행해요", buttonColor: UIColor.semantic.accPrimary)
        shuttleStartButton.hideButton()
    }

    private func setBottomButtonDriverDecline(crewData: Crew) {
        individualButton.showButton(title: "운행하지 않아요", enabled: false)
        togetherButton.showButton(title: "운행해요", enabled: false)
        shuttleStartButton.hideButton()
    }

    private func setBottomButtonDriverAccept(crewData: Crew) {
        individualButton.hideButton()
        togetherButton.hideButton()
        if firebaseManager.isAnyMemberAccepted(crewData: crewData) {
            shuttleStartButton.showButton(title: "셔틀 운행하기", buttonColor: UIColor.semantic.accPrimary)
        } else {
            shuttleStartButton.showButton(title: "셔틀 운행하기", enabled: false)
        }
    }

    private func setBottomButtonDriverSessionStart(crewData: Crew) {
        individualButton.hideButton()
        togetherButton.hideButton()
        shuttleStartButton.showButton(title: "셔틀 지도보기", buttonColor: UIColor.semantic.accPrimary)
    }

    private func setBottomButtonMemberWaiting(crewData: Crew) {
        individualButton.showButton(title: "따로가요", buttonColor: UIColor.semantic.negative)
        togetherButton.showButton(title: "함께가요", buttonColor: UIColor.semantic.accPrimary)
        shuttleStartButton.hideButton()
    }

    private func setBottomButtonMemberDecline(crewData: Crew) {
        individualButton.showButton(title: "따로가요", enabled: false)
        if crewData.sessionStatus == .decline {
            togetherButton.showButton(title: "함께가요", enabled: false)
        } else {
            togetherButton.showButton(title: "함께가요", buttonColor: UIColor.semantic.accPrimary)
        }
        shuttleStartButton.hideButton()
    }

    private func setBottomButtonMemberAccept(crewData: Crew) {
        individualButton.showButton(title: "따로가요", buttonColor: UIColor.semantic.negative)
        togetherButton.showButton(title: "함께가요", enabled: false)
        shuttleStartButton.hideButton()
    }

    private func setBottomButtonMemberSessionStart(crewData: Crew) {
        individualButton.hideButton()
        togetherButton.hideButton()
        shuttleStartButton.showButton(title: "셔틀 지도보기", buttonColor: UIColor.semantic.accPrimary)
    }
}
