//
//  AuthManager.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Observation

enum AuthState {
    case splash
    case unAuth
    case auth
    case guest
    case signUp
}

@MainActor
class AuthManager: ObservableObject { // Conform to ObservableObject
    private var db = Firestore.firestore()
    @Published var authState: AuthState = .splash // Use @Published for authState
    
    init() {
        print("AuthManager initialized")
        DispatchQueue.main.async {
            self.checkAuthState()
        }
    }
    
    func checkAuthState() {
        guard let userUid = Auth.auth().currentUser?.uid else {
            authState = .unAuth
            return
        }
        
        Task {
            if try await self.checkExistUserData(userUid) {
                authState = .auth
            } else {
                authState = .unAuth
            }
        }
    }
    
    func login() {
        guard let userUid = Auth.auth().currentUser?.uid else {
            authState = .unAuth
            return
        }
        Task {
            if try await checkExistUserData(userUid) {
                authState = .auth
            } else {
                authState = .signUp
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            authState = .unAuth
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkExistUserData(_ userUid: String) async throws -> Bool {
        let document = try await self.db.collection("User").document(userUid).getDocument()
        return document.exists
    }
}
