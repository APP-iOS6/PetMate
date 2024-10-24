//
//  HomeFindButtonsView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeFindMateView: View {
    
    var body: some View {
        HStack(spacing: 15) {
            NavigationLink {
                MatePostListView(selectedPostCategory: "care")
            } label: {
                Image("care_button")
                    .resizable()
                    .frame(width: 180, height: 127)
            }
            NavigationLink{
                MatePostListView(selectedPostCategory: "walk")
            } label: {
                Image("walk_button")
                    .resizable()
                    .frame(width: 180, height: 127)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 5)
    }
}

#Preview {
    NavigationStack {
        HomeFindMateView()
    }
}
