//
//  LoginViewModel.swift
//  PetMate
//
//  Created by 김동경 on 10/18/24.
//

import Foundation
import FirebaseFirestore
import Observation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import AuthenticationServices

@Observable
class LoginViewModel {
    
    var loadState: LoadState = .none
    private var currentNonce: String?
    
    //로그인 에러 타입
    enum AuthError: Error {
        case clientIDError // 클라 아이디 오류
        case tokenError //토큰오류
        case loginError //로그인에러
        case invalidate
    }
    
    //각 버튼에 대한 액션 정의
    enum Action {
        case google
        case kakao
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
    }
    
    func action(_ action: Action) {
        loadState = .loading
        switch action {
        case .google:
            self.signInWithGoogle { result in
                switch result {
                case  .success(_):
                    self.loadState = .complete
                case  .failure(_):
                    self.loadState = .none
                    print("구글 로그인에 실패함")
                }
            }
        case .kakao:
            return
        case let .appleLogin(request):
            let nonce = randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
        case let .appleLoginCompletion(result):
            switch result {
            case let .success(authorization):
                guard let nonce = currentNonce else { return }
                signInWithApple(authorization, nonce: nonce) { value in
                    switch value {
                    case .success(_):
                        self.loadState = .complete
                    case .failure(_):
                        self.loadState = .none
                        print("애플 로그인 실패함")
                    }
                }
            case .failure(_):
                self.loadState = .none
                print("애플로그인 실패")
            }
        }
    }
}



//MARK: 구글 로그인 익스텐션
extension LoginViewModel {
    
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
            
            //에러가 없을 때
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.failure(AuthError.tokenError))
                return
            }
            
            let accessToekn = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToekn)
            
            //파베 인증 진행
            self?.authenticatedUserWithFirebase(credential: credential, completion: completion)
        }
    }
    
}

//MARK: 애플 로그인 익스텐션
extension LoginViewModel {
    func signInWithApple(_ authorization: ASAuthorization, nonce: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            completion(.failure(AuthError.tokenError))
            return
        }
        
        guard let appleIDToken = appleIdCredential.identityToken else {
            completion(.failure(AuthError.tokenError))
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            completion(.failure(AuthError.tokenError))
            return
        }
        
        let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
        
        authenticatedUserWithFirebase(credential: credential, completion: completion)

    }
}


//MARK: AuthCredential로 파이어Auth에 유저 추가하는 익스텐션
extension LoginViewModel {
    private func authenticatedUserWithFirebase(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            //만약 에러가 있다면 에러 클로저 후 종료
            if let error {
                completion(.failure(error))
                print("error")
                return
            }
            
            guard let result = result else {
                completion(.failure(AuthError.invalidate))
                return
            }
            
            completion(.success(result.user))
        }
    }
}
