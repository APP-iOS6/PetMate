//
//  HomeFindFriendsScrollView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeFindFriendsScrollView: View {
    @Bindable var viewModel: HomeViewViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("내 주변 댕댕이 친구 찾아주기")
                .font(.headline)
                .padding(.horizontal, 33)
                .padding(.bottom, -1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.nearPets, id: \.self) { pet in
                        HomeFindFriendCardView(pet: pet, viewModel: viewModel)
                    }
                }
                .padding(.horizontal, 33)
            }
        }
        .padding(.bottom, 5)
    }
}
