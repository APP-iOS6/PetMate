//
//  MatePostListCardView.swift
//  PetMate
//
//  Created by 권희철 on 10/16/24.
//

import SwiftUI

struct MatePostListCardView: View {
    var pet: Pet
    var body: some View {
        GeometryReader{ proxy in
            VStack {
                // 펫 이미지
                AsyncImage(url: URL(string: pet.images.first ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200, maxHeight: 250)
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
            .frame(width: proxy.size.width * 0.8)
            .border(.black)
            .padding() // 이미지와 정보 섹션 전체에 패딩 추가
        }
    }
}

#Preview {
    MatePostListCardView(pet: Pet(name: "애옹", description: "설명", age: 3, category1: "dog", category2: "small", tag: ["활발해요", "예방 접종 완료", "중성화 완료"], breed: "포메", images: ["https://i.namu.wiki/i/u6RY6Cwfgl5LU3zbiqxbOzmRfe2IEeICXexXNykfzxwnhMwIvV8KddLNkUxyNyDQzBwtvD9swGszVOXM_A0UFw.webp"], ownerUid: "희철", createdAt: .now, updatedAt: .now))
}
