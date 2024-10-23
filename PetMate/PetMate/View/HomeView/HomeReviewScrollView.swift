//
//  HomeReviewScrollView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeReviewScrollView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("메이트 후기가 궁금해요!")
                .font(.headline)
                .padding(.horizontal, 33)
                .padding(.bottom, -1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { _ in
                        HomeReviewCardView()
                            .padding(.vertical, 5)
                    }
                }
                .padding(.leading,1)
                .padding(.horizontal, 33)
            }
        }
        .padding(.bottom, 5)
    }
}

#Preview {
    HomeReviewScrollView()
}
