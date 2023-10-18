//
//  FriendListView.swift
//  Carmunication
//
//  Created by 김영빈 on 2023/10/10.
//

import UIKit

final class FriendListView: UIView {

    // MARK: - 친구 목록 테이블 뷰
    lazy var friendListTableView: UITableView = {
        let friendListTableView = UITableView()
        friendListTableView.separatorStyle = .none
        friendListTableView.showsVerticalScrollIndicator = false
        friendListTableView.isHidden = true
        return friendListTableView
    }()

    // MARK: - 친구 목록이 비어있을 때 보여줄 화면
    lazy var emptyView: UIView = {
        let emptyView = UIView()
        emptyView.backgroundColor = UIColor.theme.gray5
        return emptyView
    }()

    // 점선 테두리 배경
    lazy var borderLayer: CAShapeLayer = {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.theme.blue3?.cgColor
        borderLayer.lineDashPattern = [4, 4]
        borderLayer.fillColor = nil
        return borderLayer
    }()
    // 비어있음 라벨
    lazy var emptyFriendLabel: UILabel = {
        let emptyFriendLabel = UILabel()
        emptyFriendLabel.text = "아직 친구가 없습니다.\n새 친구를 추가해보세요!"
        emptyFriendLabel.numberOfLines = 0
        emptyFriendLabel.font = UIFont.carmuFont.headline1
        emptyFriendLabel.textColor = UIColor.semantic.textBody
        emptyFriendLabel.textAlignment = .center
        return emptyFriendLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = emptyFriendLabel.bounds
        borderLayer.path = UIBezierPath(roundedRect: emptyFriendLabel.bounds, cornerRadius: 16).cgPath
    }

    override func draw(_ rect: CGRect) {
        setupViews()
        setAutoLayout()
    }

    func setupViews() {
        addSubview(friendListTableView)

        addSubview(emptyView)
        addSubview(emptyFriendLabel)

        emptyFriendLabel.layer.addSublayer(borderLayer)
    }

    // MARK: - 오토 레이아웃 설정 메서드
    func setAutoLayout() {
        // 친구가 있을 때
        friendListTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }

        // 친구가 없을 때
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(36)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(emptyFriendLabel.snp.top).offset(-24)
        }
        emptyFriendLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-91)
            make.height.equalTo(122)
        }
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct FriendListViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FriendListViewController
    func makeUIViewController(context: Context) -> FriendListViewController {
        return FriendListViewController()
    }
    func updateUIViewController(_ uiViewController: FriendListViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct FriendListViewPreview: PreviewProvider {
    static var previews: some View {
        FriendListViewControllerRepresentable()
    }
}
