//
//  LoginStore.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/14/24.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Observation
import FirebaseCore
import AuthenticationServices

@Observable
final class LoginStore {
    var isLoggedIn: Bool = false
    var currentUser: User?
    
    func signInWithGoogle() {
        GIDSignIn.sharedInstance.signOut()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Failed to get client ID")
            return
        }
        _ = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("There is no root view controller!")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Google Sign-In Error: \(error.localizedDescription)")
                return
            }
            
            guard let result = result else {
                print("No result from Google Sign-In")
                return
            }
            
            guard let idToken = result.user.idToken?.tokenString else {
                print("Failed to get ID token.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In Error: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.currentUser = authResult?.user
                    print("Successfully logged in with Google")
                }
            }
        }
    }
    
    func signInWithApple() {
        
    }
    
    func signInWithKakao() {
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            
            GIDSignIn.sharedInstance.disconnect { error in
                if let error = error {
                    print("Error disconnecting: \(error.localizedDescription)")
                } else {
                    print("Successfully disconnected Google account")
                }
            }
            
            isLoggedIn = false
            currentUser = nil
            print("Successfully signed out")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
