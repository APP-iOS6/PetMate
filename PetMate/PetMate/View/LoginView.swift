//
//  LoginView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            // 로고 이미지
            Image("")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
            
            // 온보딩 이미지
            Image("")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
            
            // 카카오 로그인
            Button(action: {
                // 카카오 로그인 동작 추가
            }) {
                Image("kakao_login_button")
                    .resizable()
                    .frame(width: 300, height: 60)
            }

            // 애플 로그인
            Button(action: {
                // 애플 로그인 동작 추가
            }) {
                Image("apple_login_button")
                    .resizable()
                    .frame(width: 300, height: 60)
            }

            // 구글 로그인 버튼 이미지
            Button(action: {
                // 구글 로그인 동작 추가
            }) {
                Image("google_login_button")
                    .resizable()
                    .frame(width: 300, height: 60)
            }

            // 둘러보기 버튼
            Button(action: {
                // 둘러보기 동작 추가
            }) {
                Text("로그인 전 둘러보기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .underline(true, color: .gray)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
