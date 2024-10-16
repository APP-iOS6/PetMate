//
//  PetPostView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

struct PetPostView: View {
    var pets: [Pet] = dummyPets + dummyPets + dummyPets + dummyPets
    
    @State private var selectedCategory: String = "산책" // 기본 선택 카테고리
    let categories = ["산책", "돌봄", "놀이", "훈련"] // 더미 카테고리
    
    var post: MatePost
    var writeUser: MateUser
    
    var body: some View {
        VStack(alignment: .leading) {
            // 피커 카테고리
            Picker("카테고리", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ScrollView {
                // 2x2 레이아웃
                LazyVGrid(columns: [GridItem(.fixed(150)), GridItem(.fixed(150))], spacing: 20) {
                    ForEach(Array(pets.enumerated()), id: \.offset) { index, pet in
                        VStack {
                            // 펫 이미지
                            AsyncImage(url: URL(string: pet.images.first ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 250)
                                    .padding() // 이미지 사이의 패딩
                            } placeholder: {
                                ProgressView()
                            }
                            
                            // 펫 데이터 표시
                            VStack(alignment: .leading) {
                                Text(pet.name)
                                    .font(.headline)
                                Text("\(pet.age)살")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(pet.tag.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(.bottom, 10) // 각 이미지 아래 여백 추가
                        }
                        .padding() // 이미지와 정보 섹션 전체에 패딩 추가
                    }
                }
                .padding() // 전체 그리드에 패딩 추가
            }
        }
        .navigationTitle("Pet Details")
    }
}

// Preview
struct PetPostView_Previews: PreviewProvider {
    static var previews: some View {
        PetPostView(
            post: MatePost(
                writeUser: Firestore.firestore().document("users/user1"),
                pet: Firestore.firestore().document("pets/1"),
                startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 16, hour: 10, minute: 0))!,
                endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 16, hour: 22, minute: 0))!,
                cost: 1000,
                content: "1시간 산책 같이 하실분.",
                location: "강남구",
                reservationUser: nil,
                postState: "Available",
                createdAt: Date().addingTimeInterval(-3600),
                updatedAt: Date()
            ),
            writeUser: MateUser(id: "1", name: "김하나", image: "https://mblogthumb-phinf.pstatic.net/MjAyMzA3MTlfMzIg/MDAxNjg5NzcyMTQ0MzM0.m6BURqGnMKNRiuPNwuhYBqeg-9tLItHl81OVWUdmx5og.gFqEhucCUhnbdHANuZ-4W11Hl4-GM1_LtdSN7RhtQBUg.JPEG.ssw9014/KakaoTalk_20230703_062302394_01.jpg?type=w800", matchCount: 10, location: "강남구", createdAt: Date())
        )
    }
}
