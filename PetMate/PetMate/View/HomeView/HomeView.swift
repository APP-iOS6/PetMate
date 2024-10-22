//
//  HomeView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading){
            HomeFindMateView()
            HomeReviewScrollView()
        }.padding()
    }
}

#Preview {
    HomeView()
}
