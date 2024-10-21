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
        AsyncImage(url: URL(string: imageUrl)){ image in
            image.image?.resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 12))
        }
        
    }
}

#Preview{
    MatePostDetailImageView(imageUrl: "https://t2.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/4arX/image/yOxTvIj1eobuuV_A4OC0eu1aRAI.jpg")
}

