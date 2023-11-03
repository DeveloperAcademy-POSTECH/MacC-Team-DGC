//
//  User.swift
//  Carmu
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

import FirebaseDatabase

typealias UserIdentifier = String

/**
 id : 파이어베이스 유저 등록 시 발급되는 uid
 deviceToken : 서버 푸쉬 알림 시에 유저를 식별하기 위한 토큰값
 nickname: 유저 닉네임 (디폴트: 애플 로그인 시 받아오는 값)
 email : 유저 이메일 (애플 로그인 시 받아오는 값)
 profileType : 유저가 설정한 프로필의 타입
 crewList : 유저가 속한 크루의 id
 */

struct User: Codable {
    var id: UserIdentifier
    var deviceToken: String
    var nickname: String
    var email: String?
    var profileType: ProfileType
    var crewList: [String]?    // [Crew]
}

extension User {
    static var databasePathWithUID: DatabaseReference? = {
        guard let uid = KeychainItem.currentUserIdentifier else {
            return nil
        }
        return Database.database().reference().child("users/\(uid)")
    }()
}
