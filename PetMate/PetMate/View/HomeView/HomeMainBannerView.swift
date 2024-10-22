//
//  HomeMainBannerView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI

struct HomeMainBannerView: View {
    
    @State private var currentPage = 0
    // 광고배너
    private let images = ["Advertising_banner", "homebanner"]
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                ForEach(images.indices, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 360, height: 140)
                        .tag(index)
                }
            }
            .frame(width: 360, height: 140)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onReceive(timer) { _ in
                withAnimation {
                    currentPage = (currentPage + 1) % images.count
                }
            }
            
            // 커스텀 페이지 컨트롤러
            HStack(spacing: 5) {
                ForEach(images.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.brown : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 5)
        }
    }
}

#Preview {
    HomeMainBannerView()
}
