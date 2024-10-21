//
//  PetPostView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

struct MatePostListView: View {
    //@State 지워도 됨
    @Environment(MatePostStore.self) var postStore
    @State private var isPresentDetailView: Bool = false
    @State private var isPresentAddView: Bool = false
    
    @State private var selectedCategory: String = "all" // 기본 선택 카테고리
    let categories = ["all", "산책", "돌봄"] // 더미 카테고리
    
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
                                    isPresentDetailView.toggle()
                                }
                        }
                    }
            }
        }
        .onAppear{
            postStore.getPosts(category: "all")
        }
        .navigationTitle("돌봄")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isPresentDetailView) {
            //클래스이기 떄문에 $ 바인딩이 아니라 그냥 주입시키면 됨
            MatePostDetailView()
        }
        .toolbar {
            Button{
                isPresentAddView.toggle()
            }label: {
                Image(systemName: "pencil")
            }
//            NavigationLink {
//                MatePostAddView()
//            } label: {
//                Image(systemName: "pencil")
//            }
        }
        .fullScreenCover(isPresented: $isPresentAddView) {
            MatePostAddView()
        }
    }

}

#Preview{
    NavigationStack{
        MatePostListView()
            .environment(MatePostStore())
    }
}
