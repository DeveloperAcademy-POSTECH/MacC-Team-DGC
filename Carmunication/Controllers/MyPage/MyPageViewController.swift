//
//  MyProfileViewController.swift
//  Carmunication
//
//  Created by 허준혁 on 2023/09/22.
//

import UIKit

final class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setMyPageViewLayout()
    }
    // MARK: - 프로필 뷰 레이아웃 세팅
    func setMyPageViewLayout() {
        // MARK: - 화면 상단 ZStack
        
        // 상단 뷰 생성
        let topView = UIView()
        topView.backgroundColor = .gray
        topView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height / 2)
        self.view.addSubview(topView)
        
        // 아래 뷰 생성 (radius와 그림자 추가)
        let bottomView = UIView()
//        bottomView.backgroundColor = UIColor.white
//        bottomView.layer.cornerRadius = 10 // 원하는 radius 값으로 설정
//        bottomView.layer.shadowColor = UIColor.black.cgColor
//        bottomView.layer.shadowOpacity = 0.5
//        bottomView.layer.shadowOffset = CGSize(width: 0, height: 5) // 그림자의 위치 및 크기 조정
//        bottomView.layer.shadowRadius = 5
//        bottomView.frame = CGRect(x: 20, y: self.view.frame.size.height / 2 + 20, width: self.view.frame.size.width - 40, height: self.view.frame.size.height / 2 - 40)
//        self.view.addSubview(bottomView)
//        
//        // 이미지 뷰 생성
//        let imageView = UIImageView(image: UIImage(systemName: "star")) // 이미지 이름을 자신의 이미지 파일로 변경
//        imageView.contentMode = .scaleAspectFit
//        imageView.frame = CGRect(x: 20, y: 20, width: bottomView.frame.size.width - 40, height: 150)
//        bottomView.addSubview(imageView)
//        
//        // 텍스트 뷰 생성
//        let textView = UITextView()
//        textView.text = "여기에 텍스트를 입력하세요." // 원하는 텍스트로 변경
//        textView.frame = CGRect(x: 20, y: 180, width: bottomView.frame.size.width - 40, height: bottomView.frame.size.height - 200)
//        bottomView.addSubview(textView)
    }
}

// MARK: - 프리뷰 canvas 세팅
import SwiftUI

struct MyPageViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyPageViewController
    func makeUIViewController(context: Context) -> MyPageViewController {
        return MyPageViewController()
    }
    func updateUIViewController(_ uiViewController: MyPageViewController, context: Context) {
    }
}
@available(iOS 13.0.0, *)
struct MyPageViewPreview: PreviewProvider {
    static var previews: some View {
        MyPageViewControllerRepresentable()
    }
}
