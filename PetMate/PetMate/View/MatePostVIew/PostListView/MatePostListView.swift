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
    @State var isPresent: Bool = false
    
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
                                    print(postStore.selectedPost)
                                    isPresent.toggle()
                                    //enterMatePostDetail(post: post)
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
        .navigationDestination(isPresented: $isPresent) {
            //클래스이기 떄문에 $ 바인딩이 아니라 그냥 주입시키면 됨
            MatePostDetailView()
                .environment(postStore)
        }
        .toolbar {
            NavigationLink {
                MatePostAddView()
            } label: {
                Image(systemName: "pencil")
            }

        }
    }
    
    func enterMatePostDetail(post: MatePost){
        postStore.selectedPost = post
        isPresent.toggle()
    }
}

#Preview{
    NavigationStack{
        MatePostListView()
            .environment(MatePostStore())
    }
}
