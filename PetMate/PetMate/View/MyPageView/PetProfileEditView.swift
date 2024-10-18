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
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var breed: String = ""
    @State private var description: String = ""
    @State private var tags: [String] = []
    @State private var selectedTags: Set<String> = []

    // 더미 데이터 생성
    public let dummyPet = Pet(
        id: "1",
        name: "가디",
        description: "활발하고 사람을 좋아해요. 예방 접종 완료!",
        age: 3,
        tag: ["활발함", "얌전함", "사람 싫어요", "사람 친화적", "예방 접종 완료"],
        breed: "포메",
        images: ["gadiProfile"],
        ownerUid: "희철",
        category1: "cat",
        category2: "large",
        createdAt: Date(),
        updatedAt: Date()
    )

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            (profileImage ?? Image(dummyPet.images.first ?? "placeholder"))
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
                        .onAppear {
                            name = dummyPet.name
                        }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("나이")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    TextField("나이를 입력해주세요", text: $age)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            age = String(dummyPet.age)
                        }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("품종")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    TextField("품종을 입력해주세요", text: $breed)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            breed = dummyPet.breed
                        }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("설명쓰기")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    TextField("설명을 입력해주세요", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            description = dummyPet.description
                        }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("태그 선택하기")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                    FlowLayout {
                        ForEach(dummyPet.tag, id: \ .self) { tag in
                            TagToggle(tag: tag, isSelected: selectedTags.contains(tag)) {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
            }
            Spacer()
            Button(action: {
                // 저장 로직 추가
                savePetProfile()
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
        .padding()
    }

    // 저장로직
    private func savePetProfile() {
        let db = Firestore.firestore()
        let petData: [String: Any] = [
            "name": name,
            "age": Int(age) ?? 0,
            "breed": breed,
            "description": description,
            "tags": Array(selectedTags)
        ]

        db.collection("pets").document(dummyPet.id ?? "").setData(petData) { error in
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
