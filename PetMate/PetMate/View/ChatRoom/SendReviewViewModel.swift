//
//  SendReviewViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/23/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Observation

@Observable
class SendReviewViewModel {
    
    var loadState: LoadState = .none
    private let db = Firestore.firestore()

    func uploadReview(otherUserId: String,otherUserProfile: String, postId: String, review: String, rating: Int, postType: String) async {
        
        guard let userUid = Auth.auth().currentUser?.uid else {
            return
        }
        DispatchQueue.main.async {
            self.loadState = .loading
        }
        do {
            let documentId = String(postId.first ?? "0") + generateChatRoomId(userId1: otherUserId, userId2: userUid)
            let Review = Review(id: documentId, post: db.collection("MatePost").document(postId), reviewUserUid: otherUserId, reviewerUserUid: userUid, postType: postType, rating: rating, content: review, createdAt: Date())
            let reviewEncode = try Firestore.Encoder().encode(Review)
            try await self.db.collection("Review").document(documentId).setData(reviewEncode, merge: true)
            DispatchQueue.main.async {
                self.loadState = .complete
            }
        } catch {
            print("리뷰 남기기 실패함")
            DispatchQueue.main.async {
                self.loadState = .none
            }
        }
    }
}
