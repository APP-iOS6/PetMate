//
//  ChatDetailViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore
import Observation
import FirebaseAuth

@MainActor
class ChatDetailViewModel: ObservableObject {
    
    var listener: ListenerRegistration?
    let db = Firestore.firestore()
    var chatRoomInfo: ChatRoom?
    var isCreateChatRoom: Bool = false
    @Published var chatList: [Chat] = []
    @Published var post: MatePost?
    
    init() {
        print("어 디테일뷰모델 출근했어 ㅋ")
    }
    
    deinit {
        print("어 형 퇴근이야 ㅋ")
    }
    
    //채팅 디테일 뷰에 입장할 때 채팅방 데이터가 있는지 확인하고 그에 따라 리스너와 업데이트를 실행시키는 함수
    func checkChatRoom(_ otherUserUid: String) {
        
        guard let userUid = Auth.auth().currentUser?.uid else {
            print("로그인 하고 와")
            return
        }
        
        let chatRoomId = generateChatRoomId(userId1: userUid, userId2: otherUserUid)
        
        Task {
            if await checkExistChatRoom(chatRoomId) {
                //TODO: 채팅방이 존재 하면 해당 채팅방의 서브 컬렉션 Message 리스너 그냥 달아주기
                print("채팅방이 존재해요 ㅋ")
                self.chatRoomInfo = await getChatRoomData(chatRoomId) //현재 채팅룸에 대한 정보를 가져옴
                self.observeChatList(chatRoomId) //채팅 오는거 옵저하기 위한 함수
                self.updateAllMessagesAsRead(chatRoomId) //채팅 방에 입장했으면 안읽은 메시지 읽음 처리 해야 함
            } else {
                //TODO: 채팅방이 존재하지 않는다면 채팅방을 생성한 후 그 후 서브컬렉션인 Message 컬렉션의 리스너 달아주기
                print("채팅방이 존재하지 않아요")
            }
        }
    }
    
    //상대방과 나의 채팅방 데이터가 존재 하는지 안하는지 확인하는 함수
    func checkExistChatRoom(_ chatRoomId: String) async -> Bool {
        do {
            return try await self.db.collection("Chat").document(chatRoomId).getDocument().exists
        } catch {
            return false
        }
    }
    
    
    //해당 유저와의 채팅 메시지 정보를 계속 받기 위해 스냅샷 리스너를 호출
    func observeChatList(_ chatRoomId: String) {
        
        self.listener = self.db.collection("Chat").document(chatRoomId).collection("Message").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("리스너 실패")
                return
            }
            
            //스냅샷에서 받은 문서의 종류를 파악하고(추가, 업데이트, 삭제) 종류에 따라 맞는 함수 호출
            snapshot.documentChanges.forEach { [weak self] diff in
                do {
                    let chat = try diff.document.data(as: Chat.self)
                    switch diff.type {
                    case .added: //새로운 채팅 데이터가 추가 되었을 때
                        self?.handleAdded(chat)
                    case .modified: //기존의 채팅 데이터가 업데이트 되었을 때
                        self?.handleUpdate(chat)
                    case .removed:  //기존의 채팅 데이터가 아예 삭제되었을 때
                        self?.handleRemove(chat)
                    }
                } catch {
                    print("디코딩 실패")
                }
            }
        }
    }
    
    //채팅방의 데이터를 가져오는 함수
    func getChatRoomData(_ chatRoomId: String) async -> ChatRoom? {
        do {
            return try await self.db.collection("Chat").document(chatRoomId).getDocument(as: ChatRoom.self)
        } catch {
            return nil
        }
    }

    
    //내가 마지막에 읽은 시점 이후에 온 메시지들을 읽음 처리하는 함수
    func updateAllMessagesAsRead(_ chatRoomId: String) {
        
        guard let userUid = Auth.auth().currentUser?.uid else {
            print("로그인 상태 아님")
            return
        }
        
        
        guard let lastReadDate = self.chatRoomInfo?.readStatus[userUid] else {
            return
        }
        
        self.db.collection("Chat").document(chatRoomId).collection("Message")
            .whereField("createAt", isGreaterThan: lastReadDate).getDocuments { querySnapshot, error in
                if let error = error {
                    print("createAt 쿼리 데이터 못가져옴 \(error.localizedDescription)")
                    return
                }
                
                
                let unreadMessages = querySnapshot?.documents.filter { document in
                    guard let chat = try? document.data(as: Chat.self) else { return false }
                    return chat.sender != userUid && !chat.readBy.contains(userUid)
                }
                
                guard let unreadMessages = unreadMessages, !unreadMessages.isEmpty else {
                    print("읽지 않은 메시지가 없습니다.")
                    return
                }
                
                let batch = self.db.batch()
                unreadMessages.forEach { document in
                    let messageRef = self.db.collection("Chat").document(chatRoomId).collection("Message").document(document.documentID)
                    batch.updateData(["readBy": FieldValue.arrayUnion([userUid])], forDocument: messageRef)
                }
                
                batch.commit { error in
                    if let error = error {
                        print("배치 업데이트 실패: \(error.localizedDescription)")
                        return
                    }
                    print("모든 메시지를 읽음 상태로 업데이트했습니다.")
                    
                    let chatRoomRef = self.db.collection("Chat").document(chatRoomId)
                    chatRoomRef.updateData(["readStatus.\(userUid)": Date()]) { error in
                        if let error = error {
                            print("ChatRoom readStatus 업데이트 실패: \(error.localizedDescription)")
                        } else {
                            print("ChatRoom readStatus를 업데이트했습니다.")
                        }
                    }
                }
                
                
            }
        
    }
    
    //채딩 데이터가 새로 추가되었을 때
    private func handleAdded(_ chat: Chat) {
        self.chatList.append(chat)
    }
    
    //채팅 데이터가 업데이트 되었을 때
    private func handleUpdate(_ chat: Chat) {
        if let index = self.chatList.firstIndex(where: { $0.id == chat.id} ) {
            self.chatList[index] = chat
        }
    }
    
    //채팅 데이터가 지워졌을 때
    private func handleRemove(_ chat: Chat) {
        if let index = self.chatList.firstIndex(where: { $0.id == chat.id }) {
            self.chatList.remove(at: index)
        }
    }
    
}
