//
//  PetProfileEditView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI

struct PetProfileEditView: View {
    @State private var profileImage: Image?
    @State private var isImagePickerPresented = false // 이미지 선택기
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var location: String = ""
    @State private var description: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            (profileImage ?? Image("placeholder"))
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                )
                .overlay(
                    VStack {
                        Spacer()
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color(.systemGray2))
                                .clipShape(Circle())
                        }
                        .offset(x: 40, y: 10)
                    }
                )
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $profileImage)
                }
            
            Group {
                VStack(alignment: .leading, spacing: 8) {
                    Text("이름")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    TextField("이름을 입력해주세요", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("나이")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    TextField("나이를 입력해주세요", text: $age)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("사는 곳")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    TextField("사는 곳을 입력해주세요", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("설명쓰기")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    TextField("설명을 입력해주세요", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("태그 선택하기")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    // 태그를 선택할 수 있는 공간은 비워둠
                    
                }
            }
        }
        .padding()
    }
}

#Preview {
    PetProfileEditView()
}
