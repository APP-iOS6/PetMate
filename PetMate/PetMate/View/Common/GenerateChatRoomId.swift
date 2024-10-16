//
//  GenerateChatRoomId.swift
//  PetMate
//
//  Created by 김동경 on 10/16/24.
//

import Foundation


func generateChatRoomId(userId1: String, userId2: String) -> String {
    return userId1 < userId2 ? "\(userId1)_\(userId2)" : "\(userId2)_\(userId1)"
}
