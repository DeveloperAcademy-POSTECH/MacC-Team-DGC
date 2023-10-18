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
            deviceToken: "Bazzi",
            nickname: "김배찌",
            email: "beerandsoju@gmail.com",
            imageURL: "",
            friends: []
        ),
        User(
            id: "1",
            deviceToken: "Ted",
            nickname: "김테드",
            email: "vandijk@gmail.com",
            imageURL: "",
            friends: []
        ),
        User(
            id: "2",
            deviceToken: "Rei",
            nickname: "김레이",
            email: "pokemon767@gmail.com",
            imageURL: "",
            friends: []
        ),
        User(
            id: "3",
            deviceToken: "Uni",
            nickname: "회장님",
            email: "unisushi@gmail.com",
            imageURL: "",
            friends: []
        ),
        User(
            id: "4",
            deviceToken: "Jen",
            nickname: "권지수",
            email: "sulJji@gmail.com",
            imageURL: "",
            friends: []
        ),
        User(
            id: "5",
            deviceToken: "JellyBeen",
            nickname: "젤리빈",
            email: "sofa@gmail.com",
            imageURL: "",
            friends: []
        ),
        User(
            id: "6",
            deviceToken: "Jason",
            nickname: "제이슨",
            email: "jsonparsing@gmail.com",
            imageURL: "",
            friends: []
        ),
        User(
            id: "7",
            deviceToken: "Ian",
            nickname: "이안",
            email: "tallPerson@gmail.com",
            imageURL: "",
            friends: []
        ),
        User(
            id: "8",
            deviceToken: "LikeLike",
            nickname: "좋아요좋아요",
            email: "likelike@gmail.com",
            imageURL: "",
            friends: []
        ),
        User(
            id: "9",
            deviceToken: "SmallMid",
            nickname: "중소기업",
            email: "jungso@gmail.com",
            imageURL: "",
            friends: []
        )
    ]
    static var friendships: [Friendship] = [
        Friendship(
            friendshipID: "0", senderID: "rei", receiverID: "ted", status: true
        ),
        Friendship(
            friendshipID: "1", senderID: "rei", receiverID: "uni", status: true
        ),
        Friendship(
            friendshipID: "2", senderID: "rei", receiverID: "bazzi", status: true
        ),
        Friendship(
            friendshipID: "3", senderID: "rei", receiverID: "jen", status: true
        ),
        Friendship(
            friendshipID: "4", senderID: "bazzi", receiverID: "jellybean", status: true
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
