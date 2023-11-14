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
    var pointList: [Point] = []

    init(crewData: Crew) {
        self.crewData = crewData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.semantic.backgroundDefault

        stopoverPointSelectView.startPointView.text = crewData.startingPoint?.name
        stopoverPointSelectView.endPointView.text = crewData.destination?.name

        addButtonTarget()
        view.addSubview(stopoverPointSelectView)
        stopoverPointSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - custom Method
extension StopoverPointSelectViewController {

    private func addButtonTarget() {
        stopoverPointSelectView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
        stopoverPointSelectView.stopoverAddButton.button.addTarget(
            self,
            action: #selector(addPointButtonTapped),
            for: .touchUpInside
        )
        stopoverPointSelectView.stopover2.xButton.addTarget(
            self,
            action: #selector(deletePointButtonTapped),
            for: .touchUpInside
        )
        stopoverPointSelectView.stopover3.xButton.addTarget(
            self,
            action: #selector(deletePointButtonTapped),
            for: .touchUpInside
        )
        stopoverPointSelectView.stopover1.button.addTarget(
            self,
            action: #selector(findAddressButtonTapped),
            for: .touchUpInside
        )
        stopoverPointSelectView.stopover2.button.addTarget(
            self,
            action: #selector(findAddressButtonTapped),
            for: .touchUpInside
        )
        stopoverPointSelectView.stopover3.button.addTarget(
            self,
            action: #selector(findAddressButtonTapped),
            for: .touchUpInside
        )
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

    @objc private func addPointButtonTapped() {
        if stopoverCount == 1 {
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.stopover3).offset(30)
                make.leading.equalTo(stopoverPointSelectView).inset(20)
            }
            stopoverPointSelectView.stopover2.label.isHidden = false
            stopoverPointSelectView.stopover2.button.isHidden = false
            stopoverPointSelectView.stopover2.xButton.isHidden = false
            stopoverCount += 1
        } else {
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.nextButton.snp.top).offset(-30)
                make.leading.equalTo(stopoverPointSelectView).inset(20)
            }
            stopoverPointSelectView.stopoverAddButton.isHidden = true
            stopoverPointSelectView.stopover3.label.isHidden = false
            stopoverPointSelectView.stopover3.button.isHidden = false
            stopoverPointSelectView.stopover3.xButton.isHidden = false
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
            stopoverPointSelectView.stopover3.label.isHidden = true
            stopoverPointSelectView.stopover3.button.isHidden = true
            stopoverPointSelectView.stopover3.xButton.isHidden = true
            stopoverPointSelectView.stopoverAddButton.isHidden = false
            stopoverCount -= 1
        } else {
            stopoverPointSelectView.colorLine.snp.remakeConstraints { make in
                make.top.equalTo(stopoverPointSelectView.titleLabel5.snp.bottom).offset(30)
                make.bottom.equalTo(stopoverPointSelectView.stopover2).offset(30)
                make.leading.equalToSuperview().inset(20)
            }
            stopoverPointSelectView.stopover2.label.isHidden = true
            stopoverPointSelectView.stopover2.button.isHidden = true
            stopoverPointSelectView.stopover2.xButton.isHidden = true
            stopoverCount -= 1
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

            switch sender.titleLabel?.text {
            case "     경유지 1 검색":
                self.crewData.stopover1 = point
                self.pointList.insert(point, at: 0)
            case "     경유지 2 검색":
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
                crews: [UserIdentifier](),
                crewStatus: [CrewStatus]()
            )
        )
    }
    func updateUIViewController(_ uiViewController: StopoverPointSelectViewController, context: Context) {}
}
