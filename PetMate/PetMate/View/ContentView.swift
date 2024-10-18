//
//  ContentView.swift
//  PetMate
//
//  Created by 김정원 on 10/14/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isShowingUserProfileInput = false
    
    var body: some View {
        VStack {
            switch authManager.authState {
            case .splash:
                Text("로딩 중...")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            authManager.checkAuthState()
                        }
                    }
                
            case .unAuth:
                LoginView(isShowingUserProfileInput: $isShowingUserProfileInput)
                    .environmentObject(authManager) // 환경 객체로 추가
                
            case .auth, .signUp:
                if isShowingUserProfileInput {
                    UserProfileInputView(isShowingUserProfileInput: $isShowingUserProfileInput)
                } else {
                    HomeTabView()
                }
                
            case .guest:
                Text("게스트 모드")
                
            default:
                Text("잘못된 상태")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}
