//
//  ChatDetailViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore
import Observation


@MainActor
class ChatDetailViewModel: ObservableObject {
    
    var listener: ListenerRegistration?
    let db = Firestore.firestore()
    @Published var chatList: [Chat] = []
    @Published var post: MatePost?
    
    init() {
        print("어 디테일뷰모델 출근했어 ㅋ")
    }
    
    deinit {
        print("어 형 퇴근이야 ㅋ")
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
    
    private func markAllMessagesAsRead(_ chatRoomId: String) {
       
    }
    
}
