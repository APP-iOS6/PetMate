//
//  ContentView.swift
//  PetMate
//
//  Created by 김정원 on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(AuthManager.self) var authManager // AuthManager를 환경에서 가져옴
    
    var body: some View {
        switch authManager.authState {
        case .splash:
            Text("로딩 중...") // 스플래시 화면
        case .unAuth:
            LoginView(isLoggedIn: .constant(false)) // 로그인 화면
        case .auth:
            Text("홈화면 입니다...") // 로그인 성공 시 메인 화면
        case .signUp:
            Text("회원가입화면 입니다...") // 회원가입 화면
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthManager())
}
