//
//  ChatRoom.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore

struct ChatRoom: Codable, Identifiable {
    @DocumentID var id: String?
    var postId: String? // 신청한 글의 ID
    var participant: [String] // 대화 참가자들 UID (예: ["user1", "user2"])
    var lastMessage: String
    var lastMessageAt: Date
    var readStatus: [String: Date] // 각 참가자의 마지막 읽은 메시지 시점
}

struct ChatRoomWithUser: Codable {
    var chatRoom: ChatRoom
    var chatUser: MateUser
    var unreadCount: Int = 0
}
