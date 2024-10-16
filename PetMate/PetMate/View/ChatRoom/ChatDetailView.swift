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
                    ForEach(viewModel.chatList, id: \.id) { chat in
                        if chat.sender == otherUser.id {
                            Text(chat.message)
                                .bold()
                                .foregroundStyle(.black)
                        } else {
                            Text(chat.message)
                                .bold()
                                .foregroundStyle(.yellow)
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
                    self.text = ""
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
