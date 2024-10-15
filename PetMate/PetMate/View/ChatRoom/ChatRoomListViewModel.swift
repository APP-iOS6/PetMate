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
        print("채팅 방 뷰모델 출근")
        observeMyChatRoom()
    }
    
    deinit {
        print("채팅 방 뷰모델 퇴근")
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
            calculateUnreadCount(chatRoom) { count in
                let chatRoomWithUser = ChatRoomWithUser(chatRoom: chatRoom, chatUser: user, unreadCount: count)
                self.chatListRoom.append(chatRoomWithUser)
            }
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
    
    private func calculateUnreadCount(_ chatRoom: ChatRoom, completion: @escaping (Int) -> Void) {
        guard let lastReadDate = chatRoom.readStatus["동경"],
              let chatRoomId = chatRoom.id else {
            completion(0)
            return
        }
        
        self.db.collection("Chat").document(chatRoomId).collection("Message")
            .whereField("createAt", isGreaterThan: lastReadDate).getDocuments { querySnapshot, error in
                if let error = error {
                    print("createAt 쿼리 데이터 못가져옴 \(error.localizedDescription)")
                    completion(0)
                    return
                }
                
                
                guard let query = querySnapshot?.documents else {
                    completion(0)
                    return
                }
                
                let unReadData = query.compactMap { quereyDocumentSnapshot in
                    try? quereyDocumentSnapshot.data(as: Chat.self)
                }.filter {
                    $0.sender != "동경" && !$0.readBy.contains("동경")
                }
                
                completion(unReadData.count)
     
            }
    }
    
    //나 말고 다른 사람의 uid 가져오는 함수
    func getOtherUserId(participants: [String], currentUserId: String) -> String? {
        return participants.first { $0 != currentUserId }
    }
    
}
