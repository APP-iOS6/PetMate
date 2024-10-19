//
//  WelcomeView.swift
//  PetMate
//
//  Created by 김동경 on 10/19/24.
//

import SwiftUI

struct WelcomeView: View {
    
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
        VStack {
            Image(.welcome)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: .screenWidth * 0.6, height: .screenWidth * 0.6)
            
            Text("회원 가입이 완료 되었습니다!")
                .font(.title2)
                .bold()
                .foregroundStyle(.welcome)
                .padding(.vertical)
            
            Button {
                
            } label: {
                Text("+ 펫 정보 입력하기")
                    .padding()
                    .bold()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.accentColor)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.accentColor, lineWidth: 1)
                    }
                
            }
            .padding(.vertical, 12)
            
            Button {
                authManager.authState = .auth
            } label: {
                Text("PetMate 시작하기")
                    .modifier(ButtonModifier())
                    .bold()
            }
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    WelcomeView()
        .environment(AuthManager())
}
