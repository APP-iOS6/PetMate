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
    
    var body: some View {
        VStack {
            Spacer()
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
            .padding(.bottom, 10)
            .padding(.trailing, 20)
            
            // 카드 컨테이너
            VStack {
                HStack {
                    Spacer()
                    
                    // 채팅하기 버튼
                    Button(action: {
                        // 채팅 기능
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
                .padding(.top, 20)
                .padding(.trailing, 20)
                
                // 카드 내용
                VStack {
                    Text("주댕찾 카드입니다")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding()
            }
            .frame(width: 360, height: 300)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
            )
            
            Spacer()
        }
        .padding(.bottom, 5)
        .frame(maxHeight: UIScreen.main.bounds.height / 2)
        .background(Color(uiColor: .systemGray6).opacity(0.5))
    }
}

#Preview {
    HomeFindFriendCardDetailView(pet: Pet(
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
    ))
}
