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
                MatePostListView()
            } label: {
                Image("care_button")
                    .resizable()
                    .frame(width: 180, height: 127)
            }
            Button(action: {
                print("산책 버튼")
            }) {
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
