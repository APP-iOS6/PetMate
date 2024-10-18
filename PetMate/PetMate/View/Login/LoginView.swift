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
    var loginViewModel: LoginViewModel = LoginViewModel()
    
    @State private var currentPage = 0
    private let images = ["login_image1", "login_image2", "login_image3", "login_image4"]
    
    private let imageTexts = [
        "나의 반려동물이 외롭지 않도록\n빈 자리를 채워줄 메이트를 찾아요.",
        "반려동물을 대신 산책시켜 줄\n메이트를 찾을 수 있어요.",
        "내 주변의 펫 플레이스에서\n나의 반려동물과 더 즐거운 시간을 보내세요.",
        "반려동물의 상태를 실시간으로 확인하고\n펫시터와 채팅으로 소통하세요."
    ]
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // 로고 이미지
            Image("login_logo")
                .resizable()
                .frame(width: 139, height: 29)
                .position(x: 200, y: -20)
            
            // 이미지 슬라이더
            TabView(selection: $currentPage) {
                ForEach(images.indices, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .tag(index)
                }
            }
            .frame(width: 300, height: 300)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onReceive(timer) { _ in
                // 타이머가 작동할 때마다 currentPage 증가
                withAnimation {
                    currentPage = (currentPage + 1) % images.count
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.loginController.opacity(0.4))
                    .frame(width: CGFloat(images.count * 18), height: 25)
                
                HStack(spacing: 5) {
                    ForEach(images.indices, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.brown : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding(.bottom, 7)
            
            // 이미지에 맞는 텍스트 표시
            Text(imageTexts[currentPage])
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color.loginText)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(7)
            
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
            }) {
                Image("google_login_button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 60)
            }
            
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
        .padding(.top, 25)
    }
}

#Preview {
    LoginView()
        .environment(AuthManager())
}
