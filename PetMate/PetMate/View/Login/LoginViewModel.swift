//
//  LoginViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/18/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import AuthenticationServices
import Combine

class LoginViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @Published var loadState: LoadState = .none
    
    // Store Apple Sign-In completion handler here (moved from extension)
    private var appleSignInCompletion: ((Result<User, Error>) -> Void)?
    
    // 각 버튼에 대한 액션 정의
    enum Action {
        case google
        case kakao
        case apple
    }

    // AuthError enum (moved into the main class)
    enum AuthError: Error {
        case clientIDError // 클라이언트 ID 오류
        case tokenError // 토큰 오류
        case loginError // 로그인 에러
        case invalidate // 유효하지 않음
    }
    
    func action(_ action: Action) {
        loadState = .loading
        switch action {
        case .google:
            self.signInWithGoogle { result in
                switch result {
                case .success(_):
                    self.loadState = .complete
                case .failure(_):
                    self.loadState = .none
                    print("구글 로그인에 실패함")
                }
            }
        case .kakao:
            return
        case .apple:
            self.signInWithApple { result in
                switch result {
                case .success(_):
                    self.loadState = .complete
                case .failure(let error):
                    self.loadState = .none
                    print("애플 로그인에 실패함: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Google Sign-In Logic
    
    private func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(AuthError.clientIDError))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.failure(AuthError.tokenError))
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            self?.authenticatedUserWithFirebase(credential: credential, completion: completion)
        }
    }
    
    // MARK: - Apple Sign-In Logic
    
    private func signInWithApple(completion: @escaping (Result<User, Error>) -> Void) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        // Store the completion for later use
        self.appleSignInCompletion = completion
    }
    
    // MARK: - Firebase Authentication
    
    private func authenticatedUserWithFirebase(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(AuthError.invalidate))
                return
            }
            
            completion(.success(user))
        }
    }
    
    // Save user to Firestore
    private func saveUserToFirestore(user: User, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "name": user.displayName ?? ""
        ]
        
        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                print("Failed to save user: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // MARK: - ASAuthorizationControllerDelegate Methods
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let idTokenData = appleIDCredential.identityToken,
                  let idTokenString = String(data: idTokenData, encoding: .utf8) else {
                print("Failed to get identity token")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, accessToken: nil)
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    self?.appleSignInCompletion?(.failure(error))
                    print("Firebase sign-in with Apple failed: \(error.localizedDescription)")
                    return
                }
                
                guard let user = authResult?.user else {
                    self?.appleSignInCompletion?(.failure(AuthError.loginError))
                    return
                }
                
                self?.saveUserToFirestore(user: user) { success in
                    if success {
                        self?.appleSignInCompletion?(.success(user))
                    } else {
                        self?.appleSignInCompletion?(.failure(AuthError.invalidate))
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple failed: \(error.localizedDescription)")
        appleSignInCompletion?(.failure(error))
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding Method
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
