//
//  UserProfileInputView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct UserProfileInputView: View {
    @State var userProfileViewModel = UserProfileViewModel()
    @Binding var isShowingUserProfileInput: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("이름", text: $userProfileViewModel.mateUser.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("위치", text: $userProfileViewModel.mateUser.location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("프로필 이미지 URL", text: $userProfileViewModel.mateUser.image)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                userProfileViewModel.updateUserProfile { success in
                    if success {
                        isShowingUserProfileInput = false
                    }
                }
            }) {
                Text("프로필 저장")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    UserProfileInputView(isShowingUserProfileInput: .constant(true))
}
