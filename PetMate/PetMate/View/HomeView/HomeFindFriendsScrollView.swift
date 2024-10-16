//
//  HomeFindFriendsScrollView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeFindFriendsScrollView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("주댕찾")
            ScrollView(.horizontal) {
                LazyHStack{
                    ForEach(1...10, id: \.self){ _ in
                        HomeFindFriendCardView()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeFindFriendsScrollView()
}
