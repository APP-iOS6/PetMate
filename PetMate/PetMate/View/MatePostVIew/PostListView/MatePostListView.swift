//
//  PetPostView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

struct MatePostListView: View {
    @Environment(MatePostStore.self) var postStore
    @State private var isPresentDetailView: Bool = false
    @State private var isPresentAddView: Bool = false
    
    @State private var selectedPostCategory: String = "walk" // 기본 선택 카테고리
    @State private var selectedPetCategory1: String = "dog"
    @State private var selectedPetCategory2: String = "small"
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                // 상단 3개의 카테고리, 각 3분의 1씩 차지
                HStack(spacing: 8) {
                    categoryButton(title: "강아지 🐶", category: "dog")
                    categoryButton(title: "고양이 🐱", category: "cat")
                    categoryButton(title: "그 외 🐾", category: "other")
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            
                // 크기 카테고리, 각 4분의 1씩 차지
                HStack(spacing: 10) {
                    ForEach(sizeOptions(), id: \.self) { size in
                        sizeButton(title: size, category: size)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()

                GeometryReader { proxy in
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 20
                        ) {
                            ForEach(postStore.posts) { post in
                                MatePostListCardView(post: post, proxy: proxy)
                                    .onTapGesture {
                                        postStore.selectedPost = post
                                        isPresentDetailView.toggle()
                                    }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
            .onAppear {
                postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("돌봄")
                            .font(.title2)
                            .bold()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isPresentAddView.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                    }
                }
            }
            .fullScreenCover(isPresented: $isPresentAddView) {
                MatePostAddView()
            }
            .navigationDestination(isPresented: $isPresentDetailView) {
                MatePostDetailView()
            }
        }
    }
    
    private func categoryButton(title: String, category: String) -> some View {
        Button(action: {
            selectedPetCategory1 = category
            postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
        }) {
            HStack {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(selectedPetCategory1 == category ? .white : .brown)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(selectedPetCategory1 == category ? Color.brown : Color(UIColor(white: 0.95, alpha: 1)))
                    .cornerRadius(30)
                    .overlay(
                        selectedPetCategory1 == category ? nil : RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.brown, lineWidth: 0.5)
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }
    
    // 크기 카테고리 버튼 (각 버튼이 4분의 1씩 차지)
    private func sizeButton(title: String, category: String) -> some View {
        Button(action: {
            selectedPetCategory2 = category
            postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
        }) {
            Text(title)
                .foregroundColor(selectedPetCategory2 == category ? .white : .brown)
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .bold()
                .background(selectedPetCategory2 == category ? Color.brown : Color(UIColor(white: 0.95, alpha: 1)))
                .cornerRadius(30)
                .overlay(
                    selectedPetCategory2 == category ? nil : RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.brown, lineWidth: 0.5)
                )
        }
        .frame(maxWidth: .infinity)
    }

    // 크기 필터 옵션 - 펫 종류에 따라 변경
    private func sizeOptions() -> [String] {
        switch selectedPetCategory1 {
        case "cat":
            return ["대형묘", "중형묘", "소형묘", "아기"]
        case "other":
            return ["포유류", "파충류", "양서류", "조류"]
        default:
            return ["소형견", "중형견", "대형견", "아기"]
        }
    }
}

#Preview {
    MatePostListView()
        .environment(MatePostStore())
}
