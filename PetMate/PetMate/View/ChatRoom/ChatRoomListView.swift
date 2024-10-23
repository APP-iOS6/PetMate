//
//  ChatRoomListView.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

struct ChatRoomListView: View {
    
    var viewModel: ChatRoomListViewModel
    @State private var isChatDetail: Bool = false
    @State private var selectedUser: MateUser?
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("채팅")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    CalendarButton()
                        .padding(.trailing, -5)
                        .padding(.bottom, -25)
                }
                .padding(.horizontal, 20)
                
                ScrollView {
                    LazyVStack(spacing: 22) {
                        ForEach(viewModel.sortedChatListRoom, id: \.chatRoom.id) { room in
                            ChatRoomCellView(chatRoom: room) {
                                selectedUser = room.chatUser
                                isChatDetail = true
                            }
                            Divider()
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
                AsyncImage(url: URL(string: chatRoom.chatUser.image)) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 67, height: 67)
                            .clipShape(Circle())
                    case .empty:
                        Circle()
                            .fill(Color(uiColor: .systemGray3))
                            .frame(width: 67, height: 67)
                    case .failure(_):
                        Circle()
                            .fill(Color(uiColor: .systemGray3))
                            .frame(width: 67, height: 67)
                    @unknown default:
                        Circle()
                            .fill(Color(uiColor: .systemGray3))
                            .frame(width: 67, height: 67)
                    }
                    
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


