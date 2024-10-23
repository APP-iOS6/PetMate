//
//  ChatRoomListViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore
import Observation
import FirebaseAuth

@Observable
@MainActor
class ChatRoomListViewModel {
    
    
    let db = Firestore.firestore()
    var chatListRoom: [ChatRoomWithUser] = []
    
    var sortedChatListRoom: [ChatRoomWithUser] {
        chatListRoom.sorted { $0.chatRoom.lastMessageAt > $1.chatRoom.lastMessageAt }
    }
    
    
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
                let room = ChatRoom(id: "9tONJiqJzPdKpoaXsgu7D7xkHnc2_op32ORHPEnPRs39iZGN6WwNYRlH2", participant: ["op32ORHPEnPRs39iZGN6WwNYRlH2", "9tONJiqJzPdKpoaXsgu7D7xkHnc2"], lastMessage: "덱정원 형이야 ㅋ", lastMessageAt: Date(), readStatus: ["op32ORHPEnPRs39iZGN6WwNYRlH2": Date(), "9tONJiqJzPdKpoaXsgu7D7xkHnc2": Date()])
                let encode = try Firestore.Encoder().encode(room)
                self.db.collection("Chat").document(room.id ?? UUID().uuidString).setData(encode)
            } catch {
                print("챗룸 생성 실패")
            }
        }
    }
    
    
    private func observeMyChatRoom() {
        
        guard let userUid = Auth.auth().currentUser?.uid else {
            print("로그인 상태 아님")
            return
        }
        
        self.db.collection("Chat")
            .whereField("participant", arrayContains: userUid)
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
                            self?.handleAdded(chatRoom, userUid: userUid)
                        case .modified:
                            self?.handleUpdate(chatRoom, userUid: userUid)
                        case .removed:
                            self?.handleRemove(chatRoom)
                        }
                    } catch {
                        print("채팅방 디코딩 실패함")
                    }
                }
            }
    }
    
    
    private func handleAdded(_ chatRoom: ChatRoom, userUid: String) {
        fetchChatUserInfo(chatRoom, userUid: userUid) { [weak self] mateUser in
            guard let self = self, let user = mateUser else {
                print("유저 정보를 못가져옴")
                return
            }
            calculateUnreadCount(chatRoom, userUid: userUid) { count in
                let chatRoomWithUser = ChatRoomWithUser(chatRoom: chatRoom, chatUser: user, myUid: userUid, unreadCount: count)
                self.chatListRoom.append(chatRoomWithUser)
            }
        }
    }
    
    private func handleUpdate(_ chatRoom: ChatRoom, userUid: String) {
        if let index = self.chatListRoom.firstIndex(where: { $0.chatRoom.id == chatRoom.id }) {
            calculateUnreadCount(chatRoom, userUid: userUid) { count in
                let newChat = ChatRoomWithUser(chatRoom: chatRoom, chatUser: self.chatListRoom[index].chatUser, myUid: userUid, unreadCount: count)
                self.chatListRoom[index] = newChat
            }
        }
    }
    
    private func handleRemove(_ chatRoom: ChatRoom) {
        if let index = self.chatListRoom.firstIndex(where: { $0.chatRoom.id == chatRoom.id }) {
            self.chatListRoom.remove(at: index)
        }
    }
    
    private func fetchChatUserInfo(_ chatRoom: ChatRoom, userUid: String, completion: @escaping (MateUser?) -> Void) {
        guard let otherUserId = chatRoom.participant.first(where: { $0 != userUid }) else {
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
    
    private func calculateUnreadCount(_ chatRoom: ChatRoom, userUid: String, completion: @escaping (Int) -> Void) {
        guard let lastReadDate = chatRoom.readStatus[userUid],
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
                    print("ㄱ계산 문서 없음")
                    completion(0)
                    return
                }
                
                let unReadData = query.compactMap { quereyDocumentSnapshot in
                    try? quereyDocumentSnapshot.data(as: Chat.self)
                }.filter {
                    $0.sender != "동경" && !$0.readBy.contains(userUid)
                }
                
                completion(unReadData.count)
                
            }
    }
    
    //나 말고 다른 사람의 uid 가져오는 함수
    func getOtherUserId(participants: [String], currentUserId: String) -> String? {
        return participants.first { $0 != currentUserId }
    }
    
}
