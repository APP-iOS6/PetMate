//
//  HomeReviewSheet.swift
//  PetMate
//
//  Created by 김동경 on 10/23/24.
//

import SwiftUI

struct HomeReviewSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    let review: ReviewUI
    let action: () -> Void
    
    var body: some View {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    AsyncImage(url: URL(string: review.reviewUser.image)) { phase in
                        switch phase {
                        case let.success(image):
                            image
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        case .failure(_):
                            Image(.welcome)
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        case .empty:
                            Circle()
                                .fill(Color(uiColor: .systemGray2))
                                .frame(width: 100, height: 100)
                        @unknown default:
                            ProgressView()
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        if review.postType == "walk" {
                            Text("산책")
                                .modifier(ReviewTextModifier())
                        } else {
                            Text("돌봄")
                                .modifier(ReviewTextModifier())
                        }
                        
                        Text(review.reviewUser.name + " 님에 대한 후기에요!")
                            .font(.system(size: 16))
                            .bold()
                        
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { index in
                                Image(index <= review.rating ? .etc : .emptyetc)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                
                                
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.vertical)
                
                ScrollView {
                    Text(review.content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
                }
                
                Button {
                   action()
                } label: {
                    Text("\(review.reviewUser.name)과 채팅하기")
                        .modifier(ButtonModifier())
                }
                .padding(.vertical)
                
                Spacer()
            }
            
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(Color(uiColor: .systemGray4))
                        .padding([.top, .trailing], 4)
                }
            }
            .padding()
        }
}
