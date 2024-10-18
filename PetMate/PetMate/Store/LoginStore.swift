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
import FirebaseCore
import FirebaseFirestore
import AuthenticationServices

final class LoginStore: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding { // NSObject 상속 추가
    var isLoggedIn: Bool = false
    var currentUser: User?
    let db = Firestore.firestore()
    var authManager: AuthManager? // authManager 저장
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("No window found in the app")
        }
        return window
    }
    
    func signInWithGoogle(authManager: AuthManager, completion: @escaping (Bool) -> Void) {
        GIDSignIn.sharedInstance.signOut()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Failed to get client ID")
            completion(false)
            return
        }
        _ = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("There is no root view controller!")
            completion(false)
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Google Sign-In Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let result = result else {
                print("No result from Google Sign-In")
                completion(false)
                return
            }
            
            guard let idToken = result.user.idToken?.tokenString else {
                print("Failed to get ID token.")
                completion(false)
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.currentUser = authResult?.user
                    print("Successfully logged in with Google")
                    
                    // Firestore에 사용자 정보 저장
                    self.saveUserToFirestore { success in
                        if success {
                            // Firestore 저장 후 회원가입 상태로 전환
                            authManager.authState = .signUp
                        }
                        completion(success)
                    }
                }
            }
        }
    }
    
    // Firestore에 사용자 정보를 저장하는 함수
    func saveUserToFirestore(completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is currently logged in.")
            completion(false)
            return
        }
        
        let userUID = currentUser.uid
        let userEmail = currentUser.email ?? "이메일 없음"
        
        let userRef = Firestore.firestore().collection("User").document(userUID)
        
        let newUser = MateUser(id: userUID,
                               name: userEmail,
                               image: "",
                               matchCount: 0,
                               location: "",
                               createdAt: Date())
        
        do {
            try userRef.setData(from: newUser) { error in
                if let error = error {
                    print("Error saving user to Firestore: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("User successfully saved to Firestore.")
                    completion(true) // 성공 시 true 전달
                }
            }
        } catch {
            print("Error encoding user model: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // Apple 로그인
    func signInWithApple(authManager: AuthManager, completion: @escaping (Bool) -> Void) {
        self.authManager = authManager // authManager 저장
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let idTokenData = appleIDCredential.identityToken,
                  let idTokenString = String(data: idTokenData, encoding: .utf8) else {
                print("Failed to get identity token")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, accessToken: nil)
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Firebase sign-in with Apple failed: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        self.currentUser = authResult?.user
                        print("Successfully logged in with Apple")
                        
                        self.saveUserToFirestore { success in
                            if success {
                                self.authManager?.authState = .signUp
                            }
                        }
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple failed: \(error.localizedDescription)")
    }
    
    func signInWithKakao() {
        // Kakao 로그인 로직 추가 예정
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
