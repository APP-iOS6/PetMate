//
//  UserProfileView.swift
//  PetMate
//
//  Created by 이다영 on 10/14/24.
//

import SwiftUI
import FirebaseFirestore

struct UserProfileView: View {
    @State private var profileImage: Image?
    @State private var isImagePickerPresented = false // 이미지 선택기
    @State private var isEditingIntroduction = false // 편집모드인지 여부
    @State private var introduction = "소개를 기다리고 있어요"
    
    var user: MateUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                ZStack(alignment: .bottom) {
                    // 이미지 프로필
                    (profileImage ?? Image(user.image))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            isImagePickerPresented = true
                        } // 이미지 탭하면 편집
                    
                    Text("편집")
                        .font(.caption)
                        .padding(4)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.bottom, 4)
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $profileImage)
                }
                
                // TODO: 뼈다구 점수 추가하기
                // 이름, 지역, 매칭 횟수, 소개글
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(user.name)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                        Text("📍\(user.location)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Text("메이트 횟수: \(user.matchCount)번")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    // 소개글 편집
                    if isEditingIntroduction {
                        TextField("소개", text: $introduction, onCommit: {
                            isEditingIntroduction = false
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    } else {
                        Text(introduction)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                isEditingIntroduction = true
                            }
                    }
                }
            }
            
            HStack {
                Text("뼈다구 점수 ")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                Text("🦴🦴🦴🦴🦴")
            }
            
            HStack {
                Text("친구목록 ")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: MateUser(name: "김정원", image: "gardenProfile", matchCount: 5, location: "구월3동", createdAt: Date()))
    }
}
