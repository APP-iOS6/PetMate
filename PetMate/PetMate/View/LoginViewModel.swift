//
//  LoginViewModel.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/16/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

final class LoginViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    
    let loginStore = LoginStore()
    
    func signInWithGoogle(authManager: AuthManager, completion: @escaping (Bool) -> Void) {
        loginStore.signInWithGoogle(authManager: authManager) { success in
            if success {
                self.isLoggedIn = true
            }
            completion(success)
        }
    }
    
    func signOut() {
        loginStore.signOut()
        isLoggedIn = false
    }
}
