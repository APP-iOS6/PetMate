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
                    // HStack으로 텍스트와 chevron.down 아이콘을 나란히 배치
                    HStack(spacing: 4) {
                        Text("📍\(myInfo?.location ?? "알 수 없음")")
                            .font(.system(size: 14, weight: .regular))
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color(UIColor.systemGray2))
                    }
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
