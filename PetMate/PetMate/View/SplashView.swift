//
//  SplashView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/16/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("splash_image")
                .resizable()
                .scaledToFit()
                .frame(width: 371, height: 176)
            Spacer()
        }
        .edgesIgnoringSafeArea(.all) // 전체 화면으로 표시
    }
}

#Preview {
    SplashView()
}
