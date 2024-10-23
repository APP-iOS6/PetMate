//
//  PetProfileEditView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

// 팻 프로필 수정 시트
struct PetProfileEditView: View {
    @State private var profileImage: Image?
    @State private var isImagePickerPresented = false // 이미지 선택기
    @State private var isShowingDeleteConfirmation = false // 삭제 확인
    @State private var viewModel: MyPageViewViewModel = MyPageViewViewModel()
    @Environment(\.dismiss) private var dismiss // EditView 닫기
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24) {
                ForEach(viewModel.petInfo, id: \.self) { pet in
                    VStack(alignment: .leading, spacing: 24) {
                        ZStack(alignment: .bottomTrailing) {
                            VStack {
                                AsyncImage(url: URL(string: pet.images.first ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                } placeholder: {
                                    Image("placeholder")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                }
                                .onTapGesture {
                                    isImagePickerPresented = true
                                }
                                .sheet(isPresented: $isImagePickerPresented) {
                                    ImagePicker(image: $profileImage)
                                }
                            }
                            Button(action: {
                                isImagePickerPresented = true
                            }) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(Circle())
                                    .padding(8)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("이름")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            TextField("이름을 입력해주세요", text: $viewModel.petInfo[0].name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("나이")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            TextField("나이를 입력해주세요", text: Binding(
                                get: { String(viewModel.petInfo[0].age) },
                                set: { viewModel.petInfo[0].age = Int($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("품종")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            TextField("품종을 입력해주세요", text: $viewModel.petInfo[0].breed)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("설명쓰기")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            TextField("설명을 입력해주세요", text: $viewModel.petInfo[0].description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("태그 선택하기")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            FlowLayout {
                                ForEach(petTags, id: \.self) { tag in
                                    TagToggle(tag: tag, isSelected: viewModel.petInfo[0].tag.contains(tag)) {
                                        if viewModel.petInfo[0].tag.contains(tag) {
                                            viewModel.petInfo[0].tag.removeAll { $0 == tag }
                                        } else {
                                            viewModel.petInfo[0].tag.append(tag)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 24)
                    Button(action: {
                        savePetProfile(pet: pet)
                        dismiss() // 저장 후 EditView 닫기
                    }) {
                        Text("저장하기")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBrown))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }

    // 저장 로직 임의로 긁어온거...ㅠㅠ
    private func savePetProfile(pet: Pet) {
        let db = Firestore.firestore()
        let petData: [String: Any] = [
            "name": pet.name,
            "age": pet.age,
            "breed": pet.breed,
            "description": pet.description,
            "tags": pet.tag
        ]

        db.collection("pets").document(pet.id ?? "").setData(petData, merge: true) { error in
            if let error = error {
                print("Error saving pet profile: \(error.localizedDescription)")
            } else {
                print("Pet profile successfully saved!")
            }
        }
    }
}

#Preview {
    PetProfileEditView()
}
