//
//  LoginViewModel.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/16/24.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@Observable
final class LoginViewModel: ObservableObject {
    var isLoggedIn = false
    var currentUser: User?
    let loginStore = LoginStore()
    var authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    func signInWithGoogle(completion: @escaping (Bool) -> Void) {
        loginStore.signInWithGoogle(authManager: authManager) { success in
            if success {
                self.isLoggedIn = true
            }
            completion(success)
        }
    }

    func signInWithApple(completion: @escaping (Bool) -> Void) {
        loginStore.signInWithApple(authManager: authManager) { success in
            completion(success)
        }
    }

    func signOut() {
        loginStore.signOut()
        isLoggedIn = false
    }
}
