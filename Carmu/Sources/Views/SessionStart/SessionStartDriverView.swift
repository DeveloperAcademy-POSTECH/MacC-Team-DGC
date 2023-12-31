//
//  SessionStartDriverView.swift
//  Carmu
//
//  Created by 김태형 on 2023/10/12.
//

import UIKit

import SnapKit

final class SessionStartDriverView: UIView {

    private lazy var isFlipped = false
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.semantic.backgroundDefault
        return view
    }()

    // 앞면 뷰
    lazy var driverFrontView = DriverFrontView()
    // TODO: - 추후에 변경하기
    private lazy var sessionStartBackView = NoCrewBackView()

    init() {
        super.init(frame: .zero)
        setupUI()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flip))  // flip 메서드 만들기
        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = bounds
        driverFrontView.frame = bounds
        sessionStartBackView.frame = bounds

    }
}

// MARK: - Layout Methods
extension SessionStartDriverView {

    private func setupUI() {
        addSubview(contentView)
        contentView.addSubview(driverFrontView)
        contentView.addSubview(sessionStartBackView)
        sessionStartBackView.isHidden = true

        layer.cornerRadius = 20
        layer.shadowColor = UIColor.semantic.accPrimary?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
    }
}

// MARK: - Actions
extension SessionStartDriverView {

    @objc private func flip() {
        isFlipped.toggle()

        let transitionOptions: UIView.AnimationOptions = isFlipped ? .transitionFlipFromLeft : .transitionFlipFromRight

        UIView.transition(with: contentView, duration: 0.4, options: transitionOptions, animations: {
            self.driverFrontView.isHidden = self.isFlipped
            self.sessionStartBackView.isHidden = !self.isFlipped
        }, completion: nil)
    }
}

// MARK: - 앞면 뷰
final class DriverFrontView: UIView {
    private lazy var comment: UILabel = {
        let label = UILabel()

        let firstLine = NSMutableAttributedString(string: "오늘 함께할 탑승자들", attributes: [
            .font: UIFont.carmuFont.headline1,
            .foregroundColor: UIColor.semantic.textPrimary as Any
        ])
        let secondLine = NSMutableAttributedString(string: "\n\n실시간 탑승여부 응답 정보입니다", attributes: [
            .font: UIFont.carmuFont.body2Long,
            .foregroundColor: UIColor.semantic.textBody as Any
        ])

        firstLine.append(secondLine)

        label.attributedText = firstLine
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    // /(총인원)에 대한 라벨
    private lazy var totalCrewMemeberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.subhead2
        label.textColor = UIColor.semantic.textBody
        return label
    }()

    // 실시간 탑승 여부 인원에 대한 라벨
    lazy var todayCrewMemeberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.carmuFont.headline1
        label.textColor = UIColor.semantic.accPrimary
        return label
    }()

    private lazy var crewView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.layer.cornerRadius = 16
        return view
    }()

    lazy var crewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.semantic.backgroundSecond
        collectionView.layer.cornerRadius = 16
        return collectionView
    }()
    private lazy var collectionViewFooterLabel: CarpoolPlanLabel = {
        let label = CarpoolPlanLabel()
        return label
    }()

    // 당일에 운행이 없을 때 나타나는 뷰
    lazy var noDriveViewForDriver: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.semantic.backgroundSecond
        view.layer.cornerRadius = 16
        return view
    }()
    private lazy var noDriveImage: UIImageView = {
        let image = UIImage(named: "NoSessionBlinker")
        let imgView = UIImageView(image: image)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    private lazy var noDriveComment: UILabel = {
        let label = UILabel()
        label.text = "오늘은 셔틀을 운행하지 않아요"
        label.font = UIFont.carmuFont.subhead3
        label.textColor = UIColor.semantic.negative
        label.textAlignment = .center
        return label
    }()
    private lazy var carpoolPlanLabel: CarpoolPlanLabel = {
        let label = CarpoolPlanLabel()
        return label
    }()

    var crewData: Crew?

    init() {
        super.init(frame: .zero)
        setupFrontView()
        setupConstraints()

        // TODO: - 데이터 수정 후 변경 -> session 여부에 따라 true, false로 변경하기
        noDriveViewForDriver.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFrontView() {
        addSubview(comment)
        addSubview(totalCrewMemeberLabel)
        addSubview(todayCrewMemeberLabel)
        addSubview(crewView)
        addSubview(crewCollectionView)
        addSubview(noDriveViewForDriver)
        noDriveViewForDriver.addSubview(noDriveImage)
        noDriveViewForDriver.addSubview(noDriveComment)
        noDriveViewForDriver.addSubview(carpoolPlanLabel)
        crewCollectionView.dataSource = self
        crewCollectionView.delegate = self
        crewCollectionView.register(CrewCollectionViewCell.self, forCellWithReuseIdentifier: CrewCollectionViewCell.cellIdentifier)
        crewCollectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "FooterView"
        )
    }

    private func setupConstraints() {
        comment.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
        }
        totalCrewMemeberLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
        }
        todayCrewMemeberLabel.snp.makeConstraints { make in
            make.top.equalTo(totalCrewMemeberLabel)
            make.centerY.equalTo(totalCrewMemeberLabel)
            make.trailing.equalTo(totalCrewMemeberLabel.snp.leading).offset(-4)
        }

        noDriveViewForDriver.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20).priority(.high)
        }
        noDriveImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(62)
            make.height.equalTo(64)
        }
        noDriveComment.snp.makeConstraints { make in
            make.top.equalTo(noDriveImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        carpoolPlanLabel.snp.makeConstraints { make in
            make.top.equalTo(noDriveComment.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        crewCollectionView.snp.makeConstraints { make in
            make.top.equalTo(comment.snp.bottom).offset(16).priority(.high)
            make.leading.trailing.bottom.equalToSuperview().inset(20).priority(.high)
        }
    }

    func settingDriverFrontData(crewData: Crew) {
        totalCrewMemeberLabel.text = "/ \(crewData.memberStatus?.count ?? 0)"
        todayCrewMemeberLabel.text = "\(todayMemberJoined(crewData: crewData))"
    }

    func todayMemberJoined(crewData: Crew) -> Int {
        guard let memberStatus = crewData.memberStatus else { return 0 }
        // `memberStatus` 배열에서 `.accept` 상태인 요소들만 필터링하여 개수를 반환
        let todayJoiningMember = memberStatus.filter { $0.status == .accept }.count

        return todayJoiningMember
    }
}

extension DriverFrontView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count ", crewData?.memberStatus?.count ?? 0)
        return crewData?.memberStatus?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CrewCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? CrewCollectionViewCell else {
            return UICollectionViewCell()
        }

        // crewStatus에서 현재 indexPath.row에 해당하는 크루의 상태 값을 가져옵니다.
        if let memberStatus = crewData?.memberStatus?[indexPath.row] {
            // 운전자가 응답을 하지 않은 상황이면 Zzz..이고, 응답을 했다면 미응답으로 표현합니다.
            if crewData?.sessionStatus == .waiting, memberStatus.status?.statusValue == "미응답" {
                cell.statusLabel.text = "Zzz.."
            } else {
                cell.statusLabel.text = memberStatus.status?.statusValue
            }
            cell.userNameLabel.text = memberStatus.nickname
            // image가져오기
            if let profileColorString = memberStatus.profileColor,
               let profileColor = ProfileImageColor(rawValue: profileColorString) {
                cell.profileImageView.image = UIImage(profileImageColor: profileColor)
            } else {
                // 기본값 또는 다른 처리를 수행
                cell.profileImageView.image = UIImage(profileImageColor: .blue)
            }
        }

        // 운전자가 당일 운전을 진행할 때 글자 색상 변경
        if crewData?.sessionStatus == .accept || crewData?.sessionStatus == .sessionStart {
            if let crewStatus = crewData?.memberStatus?[indexPath.row] {
                if crewStatus.status == .accept {  // 크루원이 함께 간다고 했을 때
                    cell.statusLabel.textColor = UIColor.semantic.accPrimary
                    cell.statusLabel.font = UIFont.carmuFont.subhead3
                } else if crewStatus.status == .decline {  // 크루원이 함께 가지 않는다고 했을 때
                    cell.statusLabel.textColor = UIColor.semantic.negative
                    cell.statusLabel.font = UIFont.carmuFont.subhead3
                }
            }
        }

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath)
            footerView.addSubview(collectionViewFooterLabel)
            collectionViewFooterLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension DriverFrontView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 48, height: 100)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let cellWidth: CGFloat = 48 // 셀의 너비
        let cellSpacing: CGFloat = 10 // 셀 간격
        let numberOfCellsPerRow: Int = 4 // 한 줄에 표시할 셀 개수

        let totalCellWidth: CGFloat = CGFloat(crewData?.memberStatus?.count ?? 0) * cellWidth
        let totalSpacing: CGFloat = CGFloat(crewData?.memberStatus?.count ?? 0 - 1) * cellSpacing
        let totalWidth: CGFloat = totalCellWidth + totalSpacing
        let horizontalInset: CGFloat

        if crewData?.memberStatus?.count ?? 0 <= numberOfCellsPerRow {
            // 4개 이하인 경우, 한 줄로 표시
            horizontalInset = (collectionView.frame.width - totalWidth) / 2
            return UIEdgeInsets(top: 50, left: horizontalInset, bottom: 0, right: horizontalInset)
        } else {
            // 5개 이상인 경우, 두 줄로 표시
            let totalCellWidth = CGFloat(numberOfCellsPerRow) * cellWidth
            let totalSpacing = CGFloat(numberOfCellsPerRow - 1) * cellSpacing
            let totalRowWidth = totalCellWidth + totalSpacing
            horizontalInset = (collectionView.frame.width - totalRowWidth) / 2
            return UIEdgeInsets(top: 10, left: horizontalInset, bottom: 0, right: horizontalInset)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}
