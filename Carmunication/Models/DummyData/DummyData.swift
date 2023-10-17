//
//  DummyData.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

struct DummyData {
    static let users: [User] = [
        User(
            id: "0",
            nickname: "김배찌",
            email: "beerandsoju@gmail.com",
            deviceToken: "Bazzi"
        ),
        User(
            id: "1",
            nickname: "김테드",
            email: "vandijk@gmail.com",
            deviceToken: "Ted"
        ),
        User(
            id: "2",
            nickname: "김레이",
            email: "pokemon767@gmail.com",
            deviceToken: "Rei"
        ),
        User(
            id: "3",
            nickname: "회장님",
            email: "unisushi@gmail.com",
            deviceToken: "Uni"
        ),
        User(
            id: "4",
            nickname: "권지수",
            email: "sulJji@gmail.com",
            deviceToken: "Jen"
        ),
        User(
            id: "5",
            nickname: "젤리빈",
            email: "sofa@gmail.com",
            deviceToken: "JellyBeen"
        ),
        User(
            id: "6",
            nickname: "제이슨",
            email: "jsonparsing@gmail.com",
            deviceToken: "Jason"
        ),
        User(
            id: "7",
            nickname: "이안",
            email: "tallPerson@gmail.com",
            deviceToken: "Ian"
        ),
        User(
            id: "8",
            nickname: "좋아요좋아요",
            email: "likelike@gmail.com",
            deviceToken: "LikeLike"
        ),
        User(
            id: "9",
            nickname: "중소기업",
            email: "jungso@gmail.com",
            deviceToken: "SmallMid"
        )
    ]

    static var friendships: [Friendship] = [
        Friendship(
            friendId: 0, senderId: 0, receiverId: 1, status: true
        ),
        Friendship(
            friendId: 1, senderId: 0, receiverId: 2, status: true
        ),
        Friendship(
            friendId: 2, senderId: 0, receiverId: 3, status: true
        ),
        Friendship(
            friendId: 3, senderId: 0, receiverId: 4, status: true
        ),
        Friendship(
            friendId: 4, senderId: 3, receiverId: 5, status: true
        )
    ]

    static var points: [Point] = []
    static var crews: [Crew] = []
    static var groups: [Group] = []
    static var sessions: [Session] = []
}

/**
final class DummyData: ObservableObject {
    @Published var userList: [User] = []
    @Published var friendshipList: [Friendship] = []
    @Published var pointList: [Point] = []
    @Published var crewList: [Crew] = []
    @Published var groupList: [Group] = []
    @Published var sessionList: [Session] = []
}
/**
 초기 더미데이터 세팅(초기 친구 4인, 전체 유저 10명 가정. userList의 0번 인덱스가 유저라고 함)
*/
extension DummyData {
    func initialDataSetting() {
        for index in 0..<10 {
            userList.append(
                User(
                    userId: index,
                    username: "김배찌\(index)",
                    email: "dhk76\(index)@gmail.com",
                    imageURL: "",
                    friends: (index == 0) ? [1, 2, 3, 4] : [],
                    group: []
                )
            )
            if index <= 3 {
                friendshipList.append(
                    Friendship(
                        friendId: index,
                        senderId: 0,
                        receiverId: index,
                        status: true
                    )
                )
            }
        }
    }

}
 */
