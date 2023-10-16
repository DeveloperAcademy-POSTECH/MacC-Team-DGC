//
//  Friendship.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/10.
//

import Foundation

/**
 friendship_id : Friendship 데이터 모델의 고유 번호
 sender_id : 친구추가를 보낸 사람의 user_id
 receiver_id : 친구추가를 받은 사람의 user_id
 status : 친구 추가를 receiver가 받았는지 여부. 친구추가가 끊기게 되면, false로 변경
 accumulate_distance_sender_stnd : sender가 캡틴인 기준으로 receiver와 함께 간 거리
 accumulate_distance_receiver_stnd : receiver가 캡틴인 기준으로 sender와 함께 간 거리
 */
struct Friendship {
    var friendshipId: Int
    var senderId: String
    var receiverId: String
    var status: Bool = false
    var accumulateDistanceSenderStnd: Int = 0
    var accumulateDistanceReceiverStnd: Int = 0
}
