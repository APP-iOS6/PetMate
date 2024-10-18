//
//  HomeMainBannerView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeMainBannerView: View {
    
    var imageUrl: URL = URL(string:"https://www.dutch.com/cdn/shop/articles/shutterstock_1898629669.jpg?v=1697090094")!
    
    var body: some View {
        VStack{
            AsyncImage(url: imageUrl){ image in
                image.image?.resizable()
                    .scaledToFit()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .border(.gray)
    }
}

#Preview {
    HomeMainBannerView()
}
