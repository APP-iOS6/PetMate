//
//  StoreCardView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI

struct PlaceCardView: View {
    var placeName: String = "함께해 cafe"
    var location: String = "매탄동"
    var description: String = "오늘 다녀왔는데 맛집이에요! 정말 분위기 좋고 반려동물과 함께 시간을 보내기 딱 좋은 곳이에요. 커피도 맛있고, 디저트도 다양해요."
    var place: PlacePost
    var body: some View {
        HStack(spacing: 16) {
            Image("cafe1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("📍\(place.placeName)")
                        .font(.headline)
                        .lineLimit(1)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(place.address)
                        .font(.subheadline)
                        .lineLimit(1)
                        .foregroundColor(.gray)
                }
                
                Text(place.content)
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4)
        )
        .padding()
    }
}

//#Preview {
//    PlaceCardView()
//}
