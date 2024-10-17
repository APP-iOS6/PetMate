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
            if viewModel.post != nil {
                
            }
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.groupedChats) { section in
                        Text(section.dateString)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemBackground))
                        
                        ForEach(section.chats, id: \.id) { chat in
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
                                                .frame(alignment: .trailing)
                                        }
                                        
                                        Text(chat.createAt.formattedTime)
                                            .font(.caption)
                                            .foregroundStyle(.basic)
                                    }
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
                }
            }
            .frame(maxHeight: .infinity)
            
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
            viewModel.checkChatRoom(otherUser.id ?? "")
            // 키보드가 내려갈 때 높이를 0으로 설정
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }
        .onDisappear {
            viewModel.listener?.remove()
        }
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

