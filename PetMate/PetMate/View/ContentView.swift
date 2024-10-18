//
//  ContentView.swift
//  PetMate
//
//  Created by 김정원 on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthManager.self) var authManager
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
                
            case .unAuth: LoginView(isShowingUserProfileInput: $isShowingUserProfileInput, authManager: authManager)
                        
                
            case .auth, .signUp:
                if isShowingUserProfileInput {
                    UserProfileInputView(isShowingUserProfileInput: $isShowingUserProfileInput)
                } else {
                    HomeTabView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthManager())
}
