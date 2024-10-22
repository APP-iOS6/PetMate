//
//  HomeReviewCardView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeReviewCardView: View {

    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 1)

            HStack(alignment: .top, spacing: 12) {
                // 메이트 프로필
                Image(systemName: "person.crop.rectangle.fill")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .foregroundColor(Color(UIColor.systemGray5))

                VStack(alignment: .leading, spacing: 4) {
                    // 돌봄 태그
                    Text("돌봄")
                        .font(.system(size: 11, weight: .bold))
                        .frame(width: 41, height: 21)
                        .foregroundColor(.white)
                        .background(Color.tag)
                        .cornerRadius(10)

                    // 리뷰 제목
                    Text("리뷰 제목")
                        .font(.system(size: 14, weight: .bold))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .lineSpacing(3)
                        .padding(.top, 3)
                        .padding(.bottom, 3)

                    // 리뷰 내용
                    Text("리뷰 내용은 여기에 들어갑니다. 최대 두 줄까지 표시합니다.")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                // 사용자 프로필
                VStack {
                    Spacer()
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 37, height: 37)
                        .foregroundColor(Color(UIColor.systemGray5))
                }
            }
            .padding(13)
        }
        .frame(width: 340, height: 110)
    }
}

#Preview {
    HomeReviewCardView()
}
