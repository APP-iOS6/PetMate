//
//  ChatRoomListView.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

struct ChatRoomListView: View {
    
    var viewModel: ChatRoomListViewModel = .init()
    @State private var isChatDetail: Bool = false
    @State private var selectedUser: MateUser?
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("채팅")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "calendar.circle")
                        
                    }
                }
                .padding()
                
                Divider()
                
                ScrollView {
                    LazyVStack(spacing: 22) {
                        ForEach(viewModel.chatListRoom, id: \.chatRoom.id) { room in
                            ChatRoomCellView(chatRoom: room) {
                                selectedUser = room.chatUser
                                isChatDetail = true
                            }
                            Divider()
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
    }
}


struct ChatRoomCellView: View {
    
    let chatRoom: ChatRoomWithUser
    let action: () -> Void
    
    init(
        chatRoom: ChatRoomWithUser,
        action: @escaping () -> Void = {}
    ) {
        self.chatRoom = chatRoom
        self.action = action
    }
    
    var body: some View {
        NavigationLink {
            ChatDetailView(otherUser: chatRoom.chatUser)
        } label: {
            HStack {
                AsyncImage(url: URL(string: chatRoom.chatUser.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 67, height: 67)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 60, height: 60)
                VStack {
                    HStack {
                        Text(chatRoom.chatUser.name)
                            .foregroundStyle(.basic)
                            .font(.headline)
                        Text(chatRoom.chatUser.location)
                            .padding(.horizontal, 2)
                            .font(.caption)
                            .foregroundStyle(Color(uiColor: .systemGray2))
                        
                        Spacer()
                        
                        Text(chatRoom.chatRoom.lastMessageAt.formattedTimeAgo)
                            .frame(alignment: .topTrailing)
                            .foregroundStyle(Color(uiColor: .systemGray2))
                            .font(.caption)
                    }
                    .padding(.bottom, 4)
                    .padding(.horizontal, 6)
                    
                    HStack {
                        Text(chatRoom.chatRoom.lastMessage)
                            .font(.caption)
                            .foregroundStyle(Color(uiColor: .systemGray2))
                            .lineLimit(2)
                        Spacer()
                        if chatRoom.unreadCount != 0 {
                            Text("\(chatRoom.unreadCount)")
                                .bold()
                                .font(.caption)
                                .padding(4)
                                .foregroundStyle(.white)
                                .background(.red)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 6)
                }
            }
        }
    }
}


