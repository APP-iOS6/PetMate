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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    ForEach(viewModel.nearPets, id: \.self) { pet in
                        HomeFindFriendCardView(pet: pet)
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .padding(.bottom, 5)
    }
}
