//
//  UserProfileViewModel.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/16/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

final class UserProfileViewModel: ObservableObject {
    @Published var mateUser: MateUser = MateUser(
        id: nil,
        name: "",
        image: "",
        matchCount: 0,
        location: "",
        createdAt: Date()
    )

    // Firestore에 사용자 정보를 업데이트하는 함수
    func updateUserProfile(completion: @escaping (Bool) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            completion(false)
            return
        }

        let userRef = Firestore.firestore().collection("User").document(userUID)

        let updatedData: [String: Any] = [
            "name": mateUser.name,
            "location": mateUser.location,
            "image": mateUser.image,
            "updatedAt": Date()
        ]

        userRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
                completion(false)
            } else {
                print("User profile successfully updated.")
                completion(true)
            }
        }
    }
}
