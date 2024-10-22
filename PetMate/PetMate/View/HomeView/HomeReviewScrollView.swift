//
//  HomeReviewScrollView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeReviewScrollView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("[매탄동] 메이트 후기가 궁금해요!")
                .font(.headline)
                .padding(.horizontal, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(1...10, id: \.self) { _ in
                        HomeReviewCardView()
                    }
                }
                .padding(.horizontal, 28)
            }
        }
        .padding(.bottom, 5)
    }
}

#Preview {
    HomeReviewScrollView()
}
