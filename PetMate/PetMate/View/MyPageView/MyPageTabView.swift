//
//  MyPageTabView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI

struct MyPageTabView: View {
    
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                UserProfileView()
                
                Text("함께하는 반려동물")
                    .fontWeight(.bold)
                    .padding(.leading, 15)
                PetProfileView()
                Spacer()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        authManager.logout()
                    } label: {
                        Text("로그아웃(테스트용)")
                    }
                }
            }
        }
    }
}

#Preview {
    MyPageTabView()
        .environment(AuthManager())
}
