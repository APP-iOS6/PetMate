//
//  HomeFindFriendsScrollView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeFindFriendsScrollView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("내 주변 댕댕이 친구 찾아주기")
                .font(.headline)
                .padding(.horizontal, 30)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 41) {
                    ForEach(1...10, id: \.self) { _ in
                        HomeFindFriendCardView()
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .padding(.bottom, 5)
    }
}

#Preview {
    HomeFindFriendsScrollView()
}
