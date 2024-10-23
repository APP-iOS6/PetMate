//
//  HomeReviewCardView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeReviewCardView: View {
    
    let reviewUi: ReviewUI
    let action: () -> Void
    
    init(reviewUi: ReviewUI, action: @escaping () -> Void) {
        self.reviewUi = reviewUi
        self.action = action
    }
    
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(radius: 1)
                    
                    HStack(alignment: .top, spacing: 12) {
                        // 메이트 프로필
                        AsyncImage(url: URL(string: reviewUi.reviewUser.image)) { phase in
                            switch phase {
                            case let .success(image):
                                image
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipShape(.rect(cornerRadius: 18))
                                    .frame(width: 90, height: 90)
                                
                            case .empty:
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color(uiColor: .systemGray3))
                                    .frame(width: 90, height: 90)
                            case .failure(_):
                                Image(.welcome)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipShape(.rect(cornerRadius: 18))
                                    .frame(width: 90, height: 90)
                            @unknown default:
                                Image(.welcome)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipShape(.rect(cornerRadius: 18))
                                    .frame(width: 90, height: 90)
                            }
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            
                            if reviewUi.postType == "walk" {
                                Text("산책")
                                    .font(.system(size: 11, weight: .bold))
                                    .frame(width: 41, height: 21)
                                    .foregroundColor(.white)
                                    .background(Color.tag)
                                    .cornerRadius(10)
                            } else {
                                Text("돌봄")
                                    .font(.system(size: 11, weight: .bold))
                                    .frame(width: 41, height: 21)
                                    .foregroundColor(.white)
                                    .background(Color.tag)
                                    .cornerRadius(10)
                            }
                            
                            
                            // 리뷰 제목
                            Text(reviewUi.reviewUser.name + " 님에 대한 후기")
                                .font(.system(size: 14, weight: .bold))
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .lineSpacing(3)
                                .padding(.top, 3)
                                .padding(.bottom, 3)
                            
                            // 리뷰 내용
                            Text(reviewUi.content)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .lineLimit(2)
                                .lineSpacing(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                    .padding(13)
                }
                .frame(width: 340, height: 116)
            }
        }
    }
}

