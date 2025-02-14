//
//  ChatDetailView.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import SwiftUI

struct ChatDetailView: View {
    
    @StateObject private var viewModel: ChatDetailViewModel = ChatDetailViewModel()
    @State private var text: String = ""
    @State private var height: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    @State private var isReviewSheet: Bool = false
    
    let otherUser: MateUser
    let postId: String?
    
    init(
        otherUser: MateUser,
        postId: String? = nil
    ) {
        self.otherUser = otherUser
        self.postId = postId
    }
    
    var body: some View {
        VStack {
            if let post = viewModel.post {
                Divider()
                ChatPostView(post: post, otherUser: otherUser) { type in
                    switch type {
                    case .comfirm:
                        viewModel.updatePostReservation(post.id, reservationUid: otherUser.id ?? "")
                    case .review:
                        isReviewSheet = true
                    }
                }
                Divider()
            }
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.groupedChats) { section in
                            Text(section.dateString)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.systemBackground))
                            ForEach(section.chats, id: \.id) { chat in
                                ChatItemView(chat: chat, otherUser: otherUser)
                                    .id(chat.id) // 각 메시지에 고유한 ID 할당
                                
                            }
                        }
                        Rectangle()
                            .foregroundStyle(Color.clear)
                            .frame(height: 1)
                            .id("Bottom")
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo("Bottom", anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.chatList.count) { _, _ in
                    withAnimation {
                        proxy.scrollTo("Bottom", anchor: .bottom)
                    }
                    // 새로운 메시지가 추가될 때마다 스크롤
//                    if let lastMessage = viewModel.chatList.last {
//                        withAnimation {
//                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
//                        }
//                    }
                }
                
                .frame(maxHeight: .infinity)
            }
            
            Spacer()
            
            
            HStack {
                Button {
                    
                    
                } label: {
                    Image(systemName: "plus")
                        .bold()
                        .tint(.loginText)
                }
                
                ResizableTextField(text: self.$text, height: self.$height)
                    .frame(height: self.height < 150 ? self.height : 150)
                    .modifier(TextFieldModifier())
                    .overlay(alignment: .leading) {
                        if text.isEmpty {
                            Text("메시지를 입력해 주세요.")
                                .transition(.opacity)
                                .offset(x: 8)
                                .foregroundStyle(.secondary)
                        }
                    }
                
                Button {
                    Task {
                        await viewModel.sendMessage(postId, otherUser: otherUser, message: self.text)
                        self.text = ""
                    }
                } label: {
                    Image(systemName: "paperplane.circle")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .tint(.loginText)
                }
            }
            .animation(.smooth, value: text)
            .padding(.horizontal)
            
        }
        .padding(.bottom, 15)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            viewModel.checkChatRoom(otherUser.id ?? "", postId: postId)
            // 키보드가 내려갈 때 높이를 0으로 설정
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }
        .onDisappear {
            viewModel.listener?.remove()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .sheet(isPresented: $isReviewSheet) {
            if let post = viewModel.post {
                SendReviewView(otherUser: otherUser, post: post)
                    .presentationDetents([.fraction(0.5)]) //
            }
        }
        
    }
}


struct ChatItemView: View {
    
    let chat: Chat
    let otherUser: MateUser
    
    var body: some View {
        if chat.sender == otherUser.id {
            // 다른 사용자의 메시지 (왼쪽 정렬)
            HStack {
                Text(chat.message)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.accentColor, lineWidth: 1)
                    }
                VStack(alignment: .leading) {
                    Spacer()
                    Text(chat.createAt.formattedTime)
                        .font(.caption)
                }
                Spacer()
                
            }
            .padding(.horizontal)
        } else {
            // 내 메시지 (오른쪽 정렬)
            HStack {
                Spacer()
                
                VStack {
                    if !chat.readBy.contains(where: { $0 == otherUser.id }) {
                        Text("1")
                            .transition(.opacity)
                            .font(.caption)
                            .foregroundStyle(Color.accentColor)
                            .padding(.top, 12)
                            .frame(maxWidth: .infinity,alignment: .trailing)
                    }
                    
                    Text(chat.createAt.formattedTime)
                        .font(.caption)
                        .foregroundStyle(.basic)
                        .frame(maxWidth: .infinity,alignment: .bottomTrailing)
                    
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .animation(.smooth, value: chat.readBy)
                
                
                Text(chat.message)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

