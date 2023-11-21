//
//  StopoverSelectViewController.swift
//  Carmu
//
//  Created by 김동현 on 11/8/23.
//

import UIKit

final class StopoverPointSelectViewController: UIViewController {

    private let stopoverPointSelectView = StopoverPointSelectView()
    private var stopoverCount = 1
    var crewData: Crew
    var pointList: [Point] = Array(repeating: Point(), count: 3)

    init(crewData: Crew) {
        self.crewData = crewData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        view.layer.insertSublayer(CrewMakeUtil.backGroundLayer(view), at: 0)

        stopoverPointSelectView.startPointView.text = crewData.startingPoint?.name
        stopoverPointSelectView.endPointView.text = crewData.destination?.name

        stopoverPointSelectView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
        stopoverPointSelectView.nextButton.isEnabled = false

        addButtonTarget()
        view.addSubview(stopoverPointSelectView)
        stopoverPointSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 뒤로 넘어왔을 때 stopoverCount 파악하여 Constraint를 다시 잡아주는 부분
        switch stopoverCount {
        case 1:
            break
        case 2:
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.stopover3).offset(30)
                make.leading.equalTo(stopoverPointSelectView).inset(20)
            }
            showStopoverButton(sequence: 2, isHidden: false)
        default:
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.nextButton.snp.top).offset(-30)
                make.leading.equalTo(stopoverPointSelectView).inset(20)
            }
            showStopoverButton(sequence: 2, isHidden: false)
            showStopoverButton(sequence: 3, isHidden: false)
            stopoverPointSelectView.stopoverAddButton.isHidden = true
        }
    }
}

// MARK: - custom Method
extension StopoverPointSelectViewController {

    private func showStopoverButton(sequence: Int, isHidden: Bool) {
        if sequence == 2 {
            stopoverPointSelectView.stopover2.label.isHidden = isHidden
            stopoverPointSelectView.stopover2.button.isHidden = isHidden
            stopoverPointSelectView.stopover2.xButton.isHidden = isHidden
        } else {
            stopoverPointSelectView.stopover3.label.isHidden = isHidden
            stopoverPointSelectView.stopover3.button.isHidden = isHidden
            stopoverPointSelectView.stopover3.xButton.isHidden = isHidden
        }
    }

    private func addButtonTarget() {
        stopoverPointSelectView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        stopoverPointSelectView.stopoverAddButton.button.addTarget(self, action: #selector(addPointButtonTapped), for: .touchUpInside)
        stopoverPointSelectView.stopover2.xButton.addTarget(self, action: #selector(deletePointButtonTapped), for: .touchUpInside)
        stopoverPointSelectView.stopover3.xButton.addTarget(self, action: #selector(deletePointButtonTapped), for: .touchUpInside)
        stopoverPointSelectView.stopover1.button.addTarget(self, action: #selector(findAddressButtonTapped), for: .touchUpInside)
        stopoverPointSelectView.stopover2.button.addTarget(self, action: #selector(findAddressButtonTapped), for: .touchUpInside)
        stopoverPointSelectView.stopover3.button.addTarget(self, action: #selector(findAddressButtonTapped), for: .touchUpInside)
    }

    /**
     crewData가 변화되었을 때 호출되는 메서드
     */
    private func updatedCrewData() {
        print("updatedCrewData 호출")
        if crewData.stopover1 != nil {
            stopoverPointSelectView.nextButton.backgroundColor = UIColor.semantic.accPrimary
            stopoverPointSelectView.nextButton.isEnabled = true
        } else {
            stopoverPointSelectView.nextButton.backgroundColor = UIColor.semantic.backgroundThird
            stopoverPointSelectView.nextButton.isEnabled = false
        }
    }
}

// MARK: - @objc Method
extension StopoverPointSelectViewController {

    // TODO: - crewData stopover point 배열로 관리하다가 model에 적재 필요.
    // 뒤로 돌아왔을 때 처리 필요?
    @objc private func addPointButtonTapped() {
        if stopoverCount == 1 {
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.stopover3).offset(30)
                make.leading.equalTo(stopoverPointSelectView).inset(20)
            }
            showStopoverButton(sequence: 2, isHidden: false)
            stopoverCount += 1
        } else {
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.nextButton.snp.top).offset(-30)
                make.leading.equalTo(stopoverPointSelectView).inset(20)
            }
            stopoverPointSelectView.stopoverAddButton.isHidden = true
            showStopoverButton(sequence: 3, isHidden: false)
            stopoverCount += 1
        }
    }

    @objc private func deletePointButtonTapped() {
        if stopoverCount == 3 {
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.stopover3).offset(30)
                make.leading.equalTo(stopoverPointSelectView).inset(20)
            }
            stopoverPointSelectView.stopover3.button.setTitle("     경유지 3 검색", for: .normal)
            showStopoverButton(sequence: 3, isHidden: true)
            stopoverPointSelectView.stopoverAddButton.isHidden = false
            stopoverCount -= 1
            crewData.stopover3 = nil
        } else {
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.stopover2).offset(30)
                make.leading.equalToSuperview().inset(20)
            }
            stopoverPointSelectView.stopover2.button.setTitle("     경유지 2 검색", for: .normal)
            showStopoverButton(sequence: 2, isHidden: true)
            stopoverCount -= 1
            crewData.stopover2 = nil
        }
    }

    @objc private func findAddressButtonTapped(_ sender: UIButton) {
        let detailViewController = SelectDetailStopoverPointViewController(crewData: crewData)
        detailViewController.addressSelectionHandler = { addressDTO in
            var point = Point()
            point.name = addressDTO.pointName
            point.detailAddress = addressDTO.pointDetailAddress
            point.latitude = addressDTO.pointLat
            point.longitude = addressDTO.pointLng

            switch sender {
            case self.stopoverPointSelectView.stopover1.button:
                self.crewData.stopover1 = point
                self.pointList.insert(point, at: 0)
            case self.stopoverPointSelectView.stopover2.button:
                self.crewData.stopover2 = point
                self.pointList.insert(point, at: 1)
            default:
                self.crewData.stopover3 = point
                self.pointList.insert(point, at: 2)
            }
            self.updatedCrewData()
            sender.setTitle("     \(addressDTO.pointName ?? "")", for: .normal)
        }
        present(detailViewController, animated: true)
    }

    @objc private func nextButtonTapped() {
        // TODO: pointList를 활용하여 최종 다음 화면으로 갈 때만 데이터 적재할 수 있도록 로직 변경
        let viewController = TimeSelectViewController(crewData: crewData)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct SOPViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = StopoverPointSelectViewController
    func makeUIViewController(context: Context) -> StopoverPointSelectViewController {
        return StopoverPointSelectViewController(
            crewData: Crew(
                memberStatus: [MemberStatus]()
            )
        )
    }
    func updateUIViewController(_ uiViewController: StopoverPointSelectViewController, context: Context) {}
}
