//
//  HomeFindFriendCardDetailView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/21/24.
//

import SwiftUI

struct HomeFindFriendCardDetailView: View {
    let pet: Pet
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingChatRoom = false
    @Bindable var viewModel: HomeViewViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // 닫기 버튼
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.trailing, 20)

                // 프로필 이미지와 정보
                HStack(alignment: .center, spacing: 16) {
                    // 펫 프로필 이미지
                    AsyncImage(url: URL(string: pet.images.first ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    } placeholder: {
                        Image("placeholder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }

                    // 이름, 나이, 주소
                    VStack(alignment: .leading, spacing: 6) {
                        Text(pet.name)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Text("\(pet.age)살")
                            .font(.system(size: 12))
                        Text("📍\(pet.location)에 사는 \(pet.breed)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // 채팅하기 버튼
                    Button(action: {
                        Task {
                            await viewModel.fetchPetOwner(pet.ownerUid)
                            if viewModel.petOwner != nil {
                                viewModel.selectedChatUser = viewModel.petOwner
                                viewModel.shouldNavigateToChat = true
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("채팅하기")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.accentColor)
                            .padding()
                            .frame(width: 110, height: 47)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

                // 태그 섹션
                HStack {
                    ForEach(pet.tag.isEmpty ? ["태그 없음"] : pet.tag, id: \.self) { tag in
                        TagView(text: tag)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)

                // 나의 성격 섹션
                VStack(alignment: .leading, spacing: 6) {
                    Text("나의 성격")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            .background(Color.white)
                            .frame(minHeight: 100, maxHeight: 100)
                        
                        Text(pet.description.isEmpty == false ? pet.description : "저를 설명해주세요!")
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                            .padding(8)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding(.vertical, 20)
            .frame(maxHeight: UIScreen.main.bounds.height / 2)
            .background(Color(uiColor: .systemGray6).opacity(0.5))
            .navigationDestination(isPresented: $isShowingChatRoom) {
                if let owner = viewModel.petOwner {
                    ChatDetailView(otherUser: owner)
                }
            }
        }
        .presentationDetents([.fraction(0.5)])
    }
}

#Preview {
    HomeFindFriendCardDetailView(
        pet: Pet(
            id: "1",
            name: "갱얼쥐",
            description: "귀여운강아쥐",
            age: 3,
            category1: "dog",
            category2: "small",
            tag: ["활발해요", "산책 좋아요"],
            breed: "비글",
            images: ["https://example.com/dog.jpg"],
            ownerUid: "owner123",
            createdAt: Date(),
            updatedAt: Date(),
            location: "강남구 개포1동"
        ),
        viewModel: HomeViewViewModel()
    )
}
