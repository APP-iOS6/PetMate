//
//  LoginStore.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/14/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Observation
import FirebaseCore

@Observable
final class LoginStore {
    var isLoggedIn: Bool = false
    var currentUser: User?
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Failed to get ID token.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.currentUser = authResult?.user
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
            isLoggedIn = false
            currentUser = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
