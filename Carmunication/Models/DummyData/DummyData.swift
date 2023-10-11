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
            userId: 0,
            username: "김배찌",
            email: "beerandsoju@gmail.com",
            imageURL: "",
            friends: [0, 1, 2, 3],
            group: []
        ),
        User(
            userId: 1,
            username: "김테드",
            email: "vandijk@gmail.com",
            imageURL: "",
            friends: [1],
            group: []
        ),
        User(
            userId: 2,
            username: "김레이",
            email: "pokemon767@gmail.com",
            imageURL: "",
            friends: [2],
            group: []
        ),
        User(
            userId: 3,
            username: "회장님",
            email: "unisushi@gmail.com",
            imageURL: "",
            friends: [3],
            group: []
        ),
        User(
            userId: 4,
            username: "권지수",
            email: "sulJji@gmail.com",
            imageURL: "",
            friends: [4],
            group: []
        ),
        User(
            userId: 5,
            username: "젤리빈",
            email: "sofa@gmail.com",
            imageURL: "",
            friends: [4],
            group: []
        ),
        User(
            userId: 6,
            username: "제이슨",
            email: "jsonparsing@gmail.com",
            imageURL: "",
            friends: [],
            group: []
        ),
        User(
            userId: 7,
            username: "이안",
            email: "tallPerson@gmail.com",
            imageURL: "",
            friends: [],
            group: []
        ),
        User(
            userId: 8,
            username: "좋아요좋아요",
            email: "likelike@gmail.com",
            imageURL: "",
            friends: [],
            group: []
        ),
        User(
            userId: 9,
            username: "중소기업",
            email: "jungso@gmail.com",
            imageURL: "",
            friends: [],
            group: []
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
