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
    var review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // 프로필 이미지 (둥글게 처리)
                Image(systemName: "person.circle.fill") //이미지 넣어야함
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("작성자 이름") // 이름 넣어야함
                        .font(.subheadline)
                        .bold()
                    
                    Text("구경 3등") // 동 넣어야함
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            Divider()
            
            Text(review.content)
                .font(.body)
                .padding(.bottom, 4)
            
            HStack {
                Text("\(review.rating)개의 발점") //발점 넣어야함
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("어제 다녀왔어요") // 날짜 넣어야함
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding(.horizontal) // 스토어랑 좌우 패딩값이 다름 
    }
}


