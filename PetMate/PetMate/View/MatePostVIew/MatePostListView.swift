//
//  PetPostView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

struct MatePostListView: View {
    @State var postStore = MatePostStore()
    @State var isPresent: Bool = false
    
    @State private var selectedCategory: String = "산책" // 기본 선택 카테고리
    let categories = ["산책", "돌봄", "놀이", "훈련"] // 더미 카테고리
    
    var body: some View {
        VStack(alignment: .leading) {
            // 피커 카테고리
            Picker("카테고리", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(), GridItem()]) {
                        ForEach(postStore.posts) {post in
                            MatePostListCardView(pet: post.firstPet)
                                .onTapGesture {
                                    postStore.selectedPost = post
                                    isPresent.toggle()
                                }
                        }
                    }
            }
        }
        .navigationTitle("돌봄")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isPresent) {
            MatePostDetailView(postStore: $postStore)
        }
        .toolbar {
            NavigationLink {
                MatePostAddView()
            } label: {
                Image(systemName: "pencil")
            }

        }
    }
}

#Preview{
    NavigationStack{
        MatePostListView()
    }
}

// Preview
//struct MatePostListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MatePostListView(
//            post: MatePost(
//                writeUser: Firestore.firestore().document("users/user1"),
//                pet: Firestore.firestore().document("pets/1"),
//                startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 16, hour: 10, minute: 0))!,
//                endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 16, hour: 22, minute: 0))!,
//                cost: 1000,
//                content: "1시간 산책 같이 하실분.",
//                location: "강남구",
//                reservationUser: nil,
//                postState: "Available",
//                createdAt: Date().addingTimeInterval(-3600),
//                updatedAt: Date()
//            ),
//            writeUser: MateUser(id: "1", name: "김하나", image: "https://mblogthumb-phinf.pstatic.net/MjAyMzA3MTlfMzIg/MDAxNjg5NzcyMTQ0MzM0.m6BURqGnMKNRiuPNwuhYBqeg-9tLItHl81OVWUdmx5og.gFqEhucCUhnbdHANuZ-4W11Hl4-GM1_LtdSN7RhtQBUg.JPEG.ssw9014/KakaoTalk_20230703_062302394_01.jpg?type=w800", matchCount: 10, location: "강남구", createdAt: Date())
//        )
//    }
//}
