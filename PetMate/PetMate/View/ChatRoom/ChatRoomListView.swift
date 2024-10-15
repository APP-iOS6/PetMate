//
//  ChatRoomListView.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

struct ChatRoomListView: View {
    
    private var viewModel: ChatRoomListViewModel = .init()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 22) {
                ForEach(viewModel.chatListRoom, id: \.chatRoom.id) { room in
                    ChatRoomCellView(chatRoom: room)
                }
                
                Button {
                    viewModel.createChatRoom()
                } label: {
                    Text("채팅 추가하기")
                }
                
            }
            .padding()
        }
    }
}

struct ChatRoomCellView: View {
    
    let chatRoom: ChatRoomWithUser
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: chatRoom.chatUser.image)) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            VStack {
                HStack {
                    Text(chatRoom.chatUser.name)
                        .font(.headline)
                    Spacer()
                    Text(chatRoom.chatRoom.lastMessageAt.formattedTimeAgo)
                        .frame(alignment: .topTrailing)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                .padding(.bottom, 4)
               
                
                HStack {
                    Text(chatRoom.chatRoom.lastMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
#Preview {
    ChatRoomListView()
}
