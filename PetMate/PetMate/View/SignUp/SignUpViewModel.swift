//
//  SignUpViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/18/24.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserProfileViewModel: ObservableObject {
    @Published var mateUser: MateUser

    init() {
        self.mateUser = MateUser(
            id: nil,
            name: "",
            image: "",
            matchCount: 0,
            location: "",
            createdAt: Date()
        )
    }

    func saveUserProfile(completion: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser
        let changeRequest = user?.createProfileChangeRequest()
        changeRequest?.displayName = mateUser.name
        
        changeRequest?.commitChanges { error in
            if let error = error {
                print("Failed to update profile: \(error.localizedDescription)")
                completion(false)
            } else {
                guard let uid = user?.uid else {
                    completion(false)
                    return
                }
                let db = Firestore.firestore()
                db.collection("users").document(uid).setData([
                    "name": self.mateUser.name,
                    "location": self.mateUser.location,
                    "image": self.mateUser.image
                ]) { error in
                    if let error = error {
                        print("Failed to save user profile: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("User profile successfully saved")
                        completion(true)
                    }
                }
            }
        }
    }
}
