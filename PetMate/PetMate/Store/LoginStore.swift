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
import FirebaseFirestore
import AuthenticationServices

@Observable
final class LoginStore {
    var isLoggedIn: Bool = false
    var currentUser: User?
    let db = Firestore.firestore()  // Firestore 인스턴스 생성
    
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
            
            // Firebase 인증 처리
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In Error: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.currentUser = authResult?.user
                    print("Successfully logged in with Google")
                    
                    // **사용자 정보 추출 및 Firestore 저장 함수 호출**
                    self.saveUserToFirestore() // 로그인 성공 후 사용자 정보를 Firestore에 저장
                }
            }
        }
    }
    
    // Firestore에 사용자 정보를 저장하는 함수
    func saveUserToFirestore() {
        // **로그인된 사용자 정보 확인**
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is currently logged in.")
            return
        }
        
        // 사용자 정보 추출
        let userUID = currentUser.uid
        let userEmail = currentUser.email ?? "이메일 없음"
        
        // Firestore의 컬렉션 및 문서 ID 지정 (Firestore가 ID를 자동으로 관리함)
        let userRef = Firestore.firestore().collection("User").document(userUID)
        
        // MateUser 모델 생성
        let newUser = MateUser(id: userUID,
                               name: userEmail, // 사용자 이메일을 이름으로 저장
                               image: "", // 기본 이미지 URL
                               matchCount: 0, // 기본 매칭 횟수는 0
                               location: "", // 사용자의 위치 정보 (필요 시 추후 업데이트)
                               createdAt: Date()) // 생성일
        
        do {
            // Firestore에 저장
            try userRef.setData(from: newUser) { error in
                if let error = error {
                    print("Error saving user to Firestore: \(error.localizedDescription)")
                } else {
                    print("User successfully saved to Firestore.")
                }
            }
        } catch {
            print("Error encoding user model: \(error.localizedDescription)")
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
