//
//  ChatDetailView.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import SwiftUI

struct ChatDetailView: View {
    
    let chatWithUser: ChatRoomWithUser
    
    init(
        chatWithUser: ChatRoomWithUser
    ) {
        self.chatWithUser = chatWithUser
    }
    
    @StateObject private var viewModel: ChatDetailViewModel = ChatDetailViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.chatList, id: \.id) { chat in
                Text(chat.message)
            }
        }
        .onAppear {
            viewModel.observeChatList(chatWithUser)
        }
        .onDisappear {
            viewModel.listener?.remove()
        }
    }
}

