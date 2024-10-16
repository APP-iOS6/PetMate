//
//  StoreCardView.swift
//  PetMate
//
//  Created by 김정원 on 10/17/24.
//

import SwiftUI

struct PlaceCardView: View {
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
