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
    
    @State private var selectedPostCategory: String = "walk" // 기본 선택 카테고리
    @State private var selectedPetCategory1: String = "dog"
    @State private var selectedPetCategory2: String = "small"
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                // 피커 카테고리
                Picker("게시글 타입 카테고리", selection: $selectedPostCategory) {
                    //Text("전체").tag("all")
                    ForEach(MatePostCategory.allCases, id: \.self) { category in
                        Text(category.description()).tag(category.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedPostCategory, { oldValue, newValue in
                    postStore.getPosts(postCategory: newValue, petCategory1: selectedPetCategory1, petCategory2: "")
                })
                
                Picker("동물 종류 카테고리", selection: $selectedPetCategory1) {
                    ForEach(PetType.allCases, id: \.self) { category in
                        Text(category.petType).tag(category.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedPetCategory1, { oldValue, newValue in
                    postStore.getPosts(postCategory: selectedPostCategory, petCategory1: newValue, petCategory2: "")
                })
                
                Picker("동물 크기 카테고리", selection: $selectedPetCategory2) {
                    ForEach(SizeType.allCases, id: \.self){ category in
                        Text(category.sizeString).tag(category.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedPetCategory2, { oldValue, newValue in
                    postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: newValue)
                })
                
                .padding()
                ScrollView() {
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
                postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
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
            }
            .fullScreenCover(isPresented: $isPresentAddView) {
                MatePostAddView()
            }
        }.environment(postStore)
    }

}

#Preview{
        MatePostListView()
            .environment(MatePostStore())
}
