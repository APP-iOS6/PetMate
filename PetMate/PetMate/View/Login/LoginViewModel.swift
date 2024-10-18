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

@Observable
class LoginViewModel {
    
    var loadState: LoadState = .none
    
    
    //각 버튼에 대한 액션 정의
    enum Action {
        case google
        case kakao
        case apple
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
        case .apple:
            return
        }
    }
}



//로그인 로직 함수 익스텐션
extension LoginViewModel {
    
    enum AuthError: Error {
        case clientIDError // 클라 아이디 오류
        case tokenError //토큰오류
        case loginError //로그인에러
        case invalidate
    }
    
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
