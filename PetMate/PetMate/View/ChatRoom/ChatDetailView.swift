//
//  ChatDetailView.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import SwiftUI

struct ChatDetailView: View {
    
    let chatRoomId: String
    let chatUser: MateUser
    let postId: String?
    
    init(chatRoomId: String,
         chatUser: MateUser,
         postId: String?
    ) {
        self.chatRoomId = chatRoomId
        self.chatUser = chatUser
        self.postId = postId
    }
    
    @StateObject private var viewModel: ChatDetailViewModel = ChatDetailViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.chatList, id: \.id) { chat in
                Text(chat.message)
            }
        }
        .onAppear {
            viewModel.observeChatList(chatRoomId)
        }
        .onDisappear {
            viewModel.listener?.remove()
        }
    }
}

#Preview {
    ChatDetailView(
        chatRoomId: "동경_정원",
        chatUser: MateUser(
            name: "정원",
            image: "https://image-cdn.hypb.st/https%3A%2F%2Fkr.hypebeast.com%2Ffiles%2F2022%2F08%2Fone-piece-luffys-anime-voice-actress-says-she-doesnt-read-the-manga-ft.jpg?w=960&cbr=1&q=90&fit=max",
            matchCount: 6,
            location: "구얼동",
            createdAt: Date()),
        postId: nil
    )
}
