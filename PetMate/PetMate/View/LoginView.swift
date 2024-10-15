//
//  LoginView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @Environment(AuthManager.self) var authManager
    @StateObject private var loginViewModel = LoginViewModel()
    @Binding var isShowingUserProfileInput: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Button(action: {
                print("카카오 로그인 버튼 눌림")
            }) {
                Image("kakao_login_button")
                    .resizable()
                    .frame(width: 300, height: 60)
            }

            Button(action: {
                print("애플 로그인 버튼 눌림")
            }) {
                Image("apple_login_button")
                    .resizable()
                    .frame(width: 300, height: 60)
            }
            
            Button(action: {
                print("구글 로그인 버튼 눌림")
                loginViewModel.signInWithGoogle(authManager: authManager) { success in
                    if success {
                        isShowingUserProfileInput = true  // 로그인 성공 시 회원정보 입력 화면으로 이동
                    }
                }
            }) {
                Image("google_login_button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 60)
            }

            // 둘러보기 버튼
            Button(action: {
                print("둘러보기 버튼 눌림")
                authManager.authState = .auth
            }) {
                Text("로그인 전 둘러보기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .underline(true, color: .gray)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(isShowingUserProfileInput: .constant(false))
        .environment(AuthManager())
}
