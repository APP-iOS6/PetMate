//
//  ChatDetailViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/15/24.
//

import Foundation
import FirebaseFirestore
import Observation

@Observable
@MainActor
class ChatDetailViewModel {
    
    let db = Firestore.firestore()
    var chatList: [Chat] = []
    
}
