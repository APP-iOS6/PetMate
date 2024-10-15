//
//  ChatRoomListViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore
import Observation

@Observable
@MainActor
class ChatRoomListViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    var chatListRoom: [ChatRoomWithUser] = []
    
    
    init() {
        observeMyChatRoom()
    }
    
    func createChatRoom() {
        Task {
            do {
                let room = ChatRoom(id: "동경_주노", participant: ["동경", "주노"], lastMessage: "주노 이즈 갓", lastMessageAt: Date(), readStatus: ["동경": Date(), "주노": Date()])
                let encode = try Firestore.Encoder().encode(room)
                self.db.collection("Chat").document(room.id ?? UUID().uuidString).setData(encode)
            } catch {
                print("챗룸 생성 실패")
            }
        }
    }
    
    private func observeMyChatRoom() {
        self.db.collection("Chat")
            .order(by: "lastMessageAt", descending: false)
            .whereField("participant", arrayContains: "동경")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("리스너 실패")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    do {
                        let chatRoom = try diff.document.data(as: ChatRoom.self)
                        switch diff.type {
                        case .added:
                            self?.handleAdded(chatRoom)
                        case .modified:
                            self?.handleUpdate(chatRoom)
                        case .removed:
                            self?.handleRemove(chatRoom)
                        }
                    } catch {
                        print("채팅방 디코딩 실패함")
                    }
                }
            }
    }
    
    
    private func handleAdded(_ chatRoom: ChatRoom) {
        fetchChatUserInfo(chatRoom) { [weak self] mateUser in
            guard let self = self, let user = mateUser else { return }
            let chatRoomWithUser = ChatRoomWithUser(chatRoom: chatRoom, chatUser: user)
            self.chatListRoom.append(chatRoomWithUser)
        }
    }
    
    private func handleUpdate(_ chatRoom: ChatRoom) {
        if let index = self.chatListRoom.firstIndex(where: { $0.chatRoom.id == chatRoom.id }) {
            let newChat = ChatRoomWithUser(chatRoom: chatRoom, chatUser: self.chatListRoom[index].chatUser)
            self.chatListRoom[index] = newChat
        }
    }
    
    private func handleRemove(_ chatRoom: ChatRoom) {
        if let index = self.chatListRoom.firstIndex(where: { $0.chatRoom.id == chatRoom.id }) {
            self.chatListRoom.remove(at: index)
        }
    }
    
    private func fetchChatUserInfo(_ chatRoom: ChatRoom, completion: @escaping (MateUser?) -> Void) {
        guard let otherUserId = chatRoom.participant.first(where: { $0 != "동경" }) else {
            completion(nil)
            return
        }
        
        db.collection("User").document(otherUserId).getDocument { [weak self] DocumentSnapshot, error in
            guard self != nil else { return }
            
            if let document = DocumentSnapshot, document.exists, let user = try? document.data(as: MateUser.self) {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
}
