//
//  User.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

import FirebaseDatabase

/**
 user_id : user에게 고유하게 부여되는 번호(UUID로 변경예정)
 username: 유저 닉네임
 email : 유저에게서 수집한 이메일
 imageURL : 추후 Firebase Storage에 저장할 image의 URL
 friends : Friends 저장소(static 배열)에 들어가있는 Friendship 고유 번호
 group : Group 저장소(static 배열)에 들어가있는 group 고유 번호
 */
struct User: Codable {
    var id: String
    var nickname: String
    var email: String
}

extension User {

    static var databasePathWithUID: DatabaseReference? = {
        guard let uid = KeychainItem.currentUserIdentifier else {
            return nil
        }
        return Database.database().reference().child("users/\(uid)")
    }()
}
