//
//  HomeFindButtonsView.swift
//  PetMate
//
//  Created by 권희철 on 10/15/24.
//

import SwiftUI
import FirebaseFirestore
struct HomeFindMateView: View {
    let db = Firestore.firestore()

    var body: some View {
        GeometryReader{ proxy in
            HStack{
                NavigationLink{
                    PetPostView(post: MatePost(writeUser: db.collection("User").document("희철"), pet: db.collection("User/희철/pets").document("1"), startDate: .now, endDate: Date(timeIntervalSinceNow: 60000), cost: 15000, content: "testDescription", location: "강동구", postState: "reservated", createdAt: .now, updatedAt: .now), writeUser: MateUser(id: "1", name: "김하나", image: "https://mblogthumb-phinf.pstatic.net/MjAyMzA3MTlfMzIg/MDAxNjg5NzcyMTQ0MzM0.m6BURqGnMKNRiuPNwuhYBqeg-9tLItHl81OVWUdmx5og.gFqEhucCUhnbdHANuZ-4W11Hl4-GM1_LtdSN7RhtQBUg.JPEG.ssw9014/KakaoTalk_20230703_062302394_01.jpg?type=w800", matchCount: 10, location: "강남구", createdAt: Date()))
                }
                label:{
                    HomeFindMateButton(text: "돌봐주세요!", color: .brown, proxy: proxy)
                }
                Spacer()
                NavigationLink(destination: PetPostView(post: MatePost(writeUser: db.collection("User").document("희철"), pet: db.collection("User/희철/pets").document("1"), startDate: .now, endDate: Date(timeIntervalSinceNow: 60000), cost: 15000, content: "testDescription", location: "강동구", postState: "reservated", createdAt: .now, updatedAt: .now), writeUser: MateUser(id: "1", name: "김하나", image: "https://mblogthumb-phinf.pstatic.net/MjAyMzA3MTlfMzIg/MDAxNjg5NzcyMTQ0MzM0.m6BURqGnMKNRiuPNwuhYBqeg-9tLItHl81OVWUdmx5og.gFqEhucCUhnbdHANuZ-4W11Hl4-GM1_LtdSN7RhtQBUg.JPEG.ssw9014/KakaoTalk_20230703_062302394_01.jpg?type=w800", matchCount: 10, location: "강남구", createdAt: Date()))) {
                    HomeFindMateButton(text: "산책해주세요!", color: .brown,proxy: proxy)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeFindMateView()
    }
}

// PetPostView(post: MatePost(writeUser: db.collection("User").document("희철"), pet: db.collection("User/희철/pets").document("1"), startDate: .now, endDate: Date(timeIntervalSinceNow: 60000), cost: 15000, content: "testDescription", location: "강동구", postState: "reservated", createdAt: .now, updatedAt: .now), writeUser: MateUser(id: "1", name: "김하나", image: "https://mblogthumb-phinf.pstatic.net/MjAyMzA3MTlfMzIg/MDAxNjg5NzcyMTQ0MzM0.m6BURqGnMKNRiuPNwuhYBqeg-9tLItHl81OVWUdmx5og.gFqEhucCUhnbdHANuZ-4W11Hl4-GM1_LtdSN7RhtQBUg.JPEG.ssw9014/KakaoTalk_20230703_062302394_01.jpg?type=w800", matchCount: 10, location: "강남구", createdAt: Date()))
