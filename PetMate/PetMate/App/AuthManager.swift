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
    // 케이스마다 화면을 다르게 보여줌
    case splash
    case unAuth
    case auth
    case signUp // 가입화면
}

@MainActor
@Observable
class AuthManager {
    private var _db: Firestore?
    var db: Firestore {
        if _db == nil {
            _db = Firestore.firestore()
        }
        return _db!
    }
    
    var authState: AuthState = .splash
    
    init() {
        print("AuthManager initialized")
        DispatchQueue.main.async {
            self.checkAuthState() // 앱이 시작될 때 호출 로그인을 확인하는 로직이 자동으로 돌아감 > 이 친구를 활용
        }
    }
    
    // 로그인 된 상태 확인
    func checkAuthState() {
        guard let userUid = Auth.auth().currentUser?.uid else {
            authState = .unAuth // 로그인이 안 되어 있을 때
            return
        }
        
        Task {
            if try await self.checkExistUserData(userUid) {
                authState = .auth // 구글로 로그인 한 기록이 있고 데이터베이스에 데이터가 있기 때문에 홈으로 넘겨줌
            } else {
                authState = .signUp // 사용자 데이터가 없을 경우 회원가입으로 이동
            }
        }
    }
    
    // 데베에서 User 받아오기 체크하는 함수
    func checkExistUserData(_ userUid: String) async throws -> Bool {
        let document = try await self.db.collection("User").document(userUid).getDocument()
        return document.exists // 유저가 DB상에 존재하면 true 존재하지 않으면 false 반환
    }
}
