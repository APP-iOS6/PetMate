//
//  ReviewView.swift
//  PetMate
//
//  Created by Mac on 10/23/24.
//

import SwiftUI
import FirebaseFirestore

// 리뷰 뷰
struct ReviewView: View {

    var placePost: PlacePost

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("dog")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(.systemGray2), lineWidth: 1)
                    )
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("가디") // 이름 넣어야함
                        .font(.subheadline)
                        .bold()
                    
                    Text("역삼동") // 동 넣어야함
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            Divider()
            
            VStack {
                Text(placePost.title)
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 4)
                Text(placePost.content)
                    .padding(.bottom)
            }
            .padding(.horizontal)
            
        }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .stroke(Color.secondary, lineWidth: 0.5)
        }
    }
}


