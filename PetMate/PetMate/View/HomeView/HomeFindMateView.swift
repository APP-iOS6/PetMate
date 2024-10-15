//
//  HomeFindButtonsView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeFindMateView: View {
    var body: some View {
        GeometryReader{ proxy in
            HStack{
                HomeFindMateButton(text: "돌봐주세요!", color: .brown, proxy: proxy)
                Spacer()
                HomeFindMateButton(text: "산책해주세요!", color: .brown,proxy: proxy)
            }
        }
    }
}

#Preview {
    HomeFindMateView()
}
