//
//  ContentView.swift
//  PetMate
//
//  Created by 김정원 on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthManager.self) var authManager
    @State private var isShowingSplash = true // 스플래시 화면을 제어하는 상태 변수
    @State private var isShowingUserProfileInput = false

    var body: some View {
        VStack {
            if isShowingSplash {
                Image("splash_image")
                    .onAppear {
                        print("스플래시 화면 나옴")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation {
                                isShowingSplash = false // 3초 후 스플래시 화면을 사라지게 함
                            }
                        }
                    }
                    .transition(.opacity)
            } else {
                switch authManager.authState {
                case .unAuth:
                    LoginView(isShowingUserProfileInput: $isShowingUserProfileInput)

                case .auth, .signUp:
                    if isShowingUserProfileInput {
                        UserProfileInputView(isShowingUserProfileInput: $isShowingUserProfileInput)
                    } else {
                        HomeTabView()
                    }

                default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            print("AuthManager initialized")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                authManager.checkAuthState()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthManager())
}
