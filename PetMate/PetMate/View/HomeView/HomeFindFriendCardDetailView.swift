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
                closeButton
                
                // 전체 카드 내용
                VStack(spacing: 18) {
                    profileSection // 펫 프로필 및 정보 섹션
                    tagSection      // 태그 섹션
                    personalitySection // 성격 섹션
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.top, 5)
                
                Spacer()
            }
            .padding(.vertical, 20)
            .frame(maxHeight: UIScreen.main.bounds.height / 2)
            .background(Color(uiColor: .systemGray6).opacity(0.5))
            .navigationDestination(isPresented: $isShowingChatRoom) {
                if let owner = viewModel.petOwner {
                    ChatDetailView(otherUser: owner) // 채팅방으로 이동
                }
            }
        }
        .presentationDetents([.fraction(0.5)])
    }
    
    // 닫기 버튼 컴포넌트
    private var closeButton: some View {
        HStack {
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                CircleButton(imageName: "xmark")
            }
            .padding(.top, 20) // 위쪽 공간 추가

        }
        .padding(.trailing, 20) // 오른쪽 공간 유지
    }
    
    // 펫 프로필 이미지와 이름, 나이, 주소 섹션
    private var profileSection: some View {
        HStack(alignment: .top, spacing: -20) {
            VStack {
                Spacer()
                HStack(alignment: .top, spacing: 12) {
                    petProfileImage // 펫 프로필 이미지
                    petInfo         // 펫 정보
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.bottom, 10)
            
            chatButton
        }
    }
    
    // 펫 프로필 이미지 컴포넌트
    private var petProfileImage: some View {
        AsyncImageView(url: pet.images.first ?? "")
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .padding(.top, 15)
    }
    
    // 펫 이름, 나이, 주소 정보 컴포넌트
    private var petInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(pet.name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Text("\(pet.age)살")
                    .font(.system(size: 12))
                Spacer()
            }
            Text("📍\(pet.location)에 사는 \(pet.breed)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(.top, 15)
    }
    
    // 채팅하기 버튼 컴포넌트
    private var chatButton: some View {
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
                .frame(width: 100, height: 40)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
        }
    }
    
    // 태그 섹션 컴포넌트
    private var tagSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("태그")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 8) {
                    ForEach(pet.tag.isEmpty ? ["태그 없음"] : pet.tag, id: \.self) { tag in
                        TagView(text: tag)
                    }
                }
            }
        }
    }
    
    // 성격 섹션 컴포넌트
    private var personalitySection: some View {
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
    }
}

// 재사용 가능한 버튼 컴포넌트
private struct CircleButton: View {
    let imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 30, height: 30)
            
            Image(systemName: imageName)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

// 재사용 가능한 이미지 로드 컴포넌트
private struct AsyncImageView: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Image("placeholder")
                .resizable()
                .scaledToFill()
        }
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
