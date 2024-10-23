//
//  HomeReviewScrollView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeReviewScrollView: View {
    
   
    @Bindable var viewModel: HomeViewViewModel
    @State private var selectedReview: ReviewUI?

    var body: some View {
        VStack(alignment: .leading) {
            Text("메이트 후기가 궁금해요!")
                .font(.headline)
                .padding(.horizontal, 33)
                .padding(.bottom, -1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.reviews, id: \.id) { review in
                        HomeReviewCardView(reviewUi: review) {
                            selectedReview = review
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.leading,1)
                .padding(.horizontal, 33)
            }
        }
        .sheet(item: $selectedReview, onDismiss: {
            print("")
        }, content: { review in
            HomeReviewSheet(review: review) {
                viewModel.selectedReview = review
                viewModel.reviewNavigateToChat = true
                selectedReview = nil
            }
                .presentationDetents([.fraction(0.5)]) //
        })
        .padding(.bottom, 5)
    }
}


