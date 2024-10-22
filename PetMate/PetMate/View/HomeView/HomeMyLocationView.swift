//
//  HomeMyLocationView.swift
//  PetMate
//
//  Created by Hyeonjeong Sim on 10/15/24.
//

import SwiftUI

struct HomeMyLocationView: View {
    let myInfo: MateUser?
    let nearbyFriendsCount: Int
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text("📍\(myInfo?.location ?? "알 수 없음")")
                        .font(.subheadline)
                    
                    Text("지금 근처에 \(nearbyFriendsCount)명의 친구가 있어요")
                        .font(.caption)
                        .foregroundColor(Color.location)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 5)
    }
}

#Preview {
    HomeMyLocationView(myInfo: MateUser(id: "preview", name: "프리뷰 사용자", image: "default_image_url", matchCount: 0, location: "강남구 개포1동", createdAt: Date()), nearbyFriendsCount: 3)
}
