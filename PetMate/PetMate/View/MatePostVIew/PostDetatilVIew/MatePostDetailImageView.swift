//
//  MatePostDetailImageView.swift
//  PetMate
//
//  Created by 권희철 on 10/21/24.
//

import SwiftUI
import FirebaseFirestore

// PetDetailView: 특정 펫의 상세 정보를 보여주는 뷰
struct MatePostDetailImageView: View {
    let imageUrl: String
    
    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipped()
                        .cornerRadius(12)
                } else if phase.error != nil {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                } else {
                    ProgressView()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                }
            }
        }
        .frame(height: 300)
    }
}

#Preview {
    MatePostDetailImageView(imageUrl: "https://t2.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/4arX/image/yOxTvIj1eobuuV_A4OC0eu1aRAI.jpg")
        .frame(width: 300)
}
