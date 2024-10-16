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
        .border(.black)
        .padding() // 이미지와 정보 섹션 전체에 패딩 추가
        
    }
}

//#Preview {
//    MatePostListCardView()
//}
