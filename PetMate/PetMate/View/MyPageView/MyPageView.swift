//
//  MyPageTabView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI

struct MyPageView: View {
    @Environment(AuthManager.self) var authManager
    @State private var isRegisterPetViewPresented = false
    private var viewModel = MyPageViewViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // 프로필 섹션
                    UserProfileView(viewModel: viewModel)
                        .padding(.horizontal, 16)
                    
                    // 반려동물 섹션
                    VStack(alignment: .leading, spacing: 10) {
                        Text("함께하는 반려동물")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .padding(.leading, 16)
                        
                        PetProfileView(viewModel: viewModel)
                            .padding(.horizontal, 16)
                    }
                    
                    // 반려동물 추가하기 버튼
                    VStack {
                        Spacer()
                            .frame(height: 40)
                        Button(action: {
                            isRegisterPetViewPresented = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus.circle")
                                Text("반려동물 추가하기")
                            }
                            .foregroundColor(.gray)
                        }
                        
                        Spacer()
                            .frame(height: 60)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("로그아웃", action: authManager.logout)
                        .foregroundColor(.red)
                }
            }
            .navigationDestination(isPresented: $isRegisterPetViewPresented) {
                RegisterPetView(register: false) {
                    isRegisterPetViewPresented = false
                    Task {
                        await viewModel.getPetInfo()
                    }
                }
            }
        }
    }
}

#Preview {
    MyPageView()
        .environment(AuthManager())
}
