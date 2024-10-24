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
    
    @State var selectedPostCategory: String = "walk" // 기본 선택 카테고리
    @State private var selectedPetCategory1: String = "dog"
    @State private var selectedPetCategory2: String = "small"
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("동물 종류 카테고리", selection: $selectedPetCategory1) {
                ForEach(PetType.allCases, id: \.self) { category in
                    Text(category.petType).tag(category.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedPetCategory1, { oldValue, newValue in
                postStore.getPosts(postCategory: selectedPostCategory, petCategory1: newValue, petCategory2: selectedPetCategory2)
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
            GeometryReader{ proxy in
                ScrollView() {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(postStore.posts) {post in
                                MatePostListCardView(post: post, proxy: proxy)
                                    .onTapGesture {
                                        postStore.selectedPost = post
                                        isPresentDetailView.toggle()
                                    }
                            }
                        }.padding(.horizontal)
                }
            }.padding(.horizontal, 5)
        }
        .onAppear{
            postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isPresentDetailView) {
            MatePostDetailView()
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button{
                    isPresentAddView.toggle()
                }label: {
                    Image(systemName: "square.and.pencil")
                }
            }
            ToolbarItem(placement: .principal) {
                HStack{
                    Picker("게시글 타입 카테고리", selection: $selectedPostCategory) {
                        ForEach(MatePostCategory.allCases, id: \.self) { category in
                            Text(category.description())
                                .tag(category.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .onChange(of: selectedPostCategory, { oldValue, newValue in
                        postStore.getPosts(postCategory: newValue, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
                    })
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .padding(.leading, -10)
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentAddView, onDismiss: {
            postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
        }) {
            MatePostAddView()
        }
    }
    
}

#Preview{
    MatePostListView()
        .environment(MatePostStore())
}
