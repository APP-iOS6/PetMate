//
//  MyPageTabView.swift
//  PetMate
//
//  Created by 이다영 on 10/15/24.
//

import SwiftUI

struct MyPageTabView: View {
    let user = MateUser(name: "김정원", image: "gardenProfile", matchCount: 5, location: "구월3동", createdAt: Date())
    
    var body: some View {
        VStack(alignment: .center) {
            UserProfileView(user: user)
                .padding(.bottom, 30)
            
            // TODO: 옆으로 스와이프 해서 반려동물 추가 하는 기능
            // TODO: 반려동물 추가하기 view 만들어야 함
            VStack(alignment: .leading, spacing: 0) {
                Text("함께하는 반려동물")
                    .padding(.horizontal, 16)
                    .fontWeight(.bold)
                PetProfileView(mateUser: user)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
        }
    }
}

#Preview {
    MyPageTabView()
}
