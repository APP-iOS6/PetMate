//
//  LoginView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @State private var loginStore = LoginStore()
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

//            // 로고 이미지
//            Image("")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 100)
//            
//            // 온보딩 이미지
//            Image("")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 100)
            
            // 카카오 로그인
            Button(action: {
                print("카카오 로그인 버튼 눌림")
                loginStore.signInWithKakao()
            }) {
                Image("kakao_login_button")
                    .resizable()
                    .frame(width: 300, height: 60)
            }

            // 애플 로그인
            Button(action: {
                print("애플 로그인 버튼 눌림")
                loginStore.signInWithApple()
            }) {
                Image("apple_login_button")
                    .resizable()
                    .frame(width: 300, height: 60)
            }

            // 구글 로그인
            Button(action: {
                print("구글 로그인 버튼 눌림")
                loginStore.signInWithGoogle()
            }) {
                Image("google_login_button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 60)
            }

            // 둘러보기 버튼
            Button(action: {
                print("둘러보기 버튼 눌림")
                // 둘러보기 동작 추가
            }) {
                Text("로그인 전 둘러보기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .underline(true, color: .gray)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .onChange(of: loginStore.isLoggedIn) { oldValue, newValue in
            isLoggedIn = newValue
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
