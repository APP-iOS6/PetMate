//
//  HomeFindFriendCard.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeFindFriendCardView: View {
    var body: some View {
        VStack {
            // 주댕찾 펫 이미지
            Image(systemName: "pawprint.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(Color.petTag)
                .padding(.top, 10)

            Divider()
                .frame(width: 80)
                .background(Color.gray)

            // 주댕찾 펫 이름
            Text("펫 이름")
                .font(.system(size: 14, weight: .bold))
                .padding(.bottom, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 2)
                .frame(width: 100, height: 130)
        )
    }
}

#Preview {
    HomeFindFriendCardView()
}
