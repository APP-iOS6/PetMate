//
//  PetPostView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//
//
//  PetPostView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

// 펫 게시물 리스트를 표시하는 메인 뷰
struct MatePostListView: View {
    @Environment(MatePostStore.self) var postStore  // 게시물 스토어에 접근하기 위한 환경 변수
    @State private var isPresentDetailView: Bool = false  // 게시물 상세 뷰 표시 상태 변수
    @State private var isPresentAddView: Bool = false  // 게시물 추가 뷰 표시 상태 변수
    
    @State private var selectedPostCategory: String = "walk" // 기본 선택된 게시물 카테고리
    @State private var selectedPetCategory1: String = "dog" // 선택된 주요 펫 카테고리
    @State private var selectedPetCategory2: String = "small" // 선택된 펫 크기 카테고리
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                // 상단의 펫 종류 선택 버튼 (예: 강아지, 고양이, 그 외)
                HStack(spacing: 8) {
                    categoryButton(title: "강아지 🐶", category: "dog")  // 강아지 카테고리 버튼
                    categoryButton(title: "고양이 🐱", category: "cat")  // 고양이 카테고리 버튼
                    categoryButton(title: "그 외 🐾", category: "other")  // 그 외 카테고리 버튼
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            
                // 펫 크기 선택 버튼
                HStack(spacing: 10) {
                    ForEach(sizeOptions(), id: \.self) { size in
                        sizeButton(title: size, category: size)  // 옵션에 따라 크기 버튼 생성
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()

                // 게시물 리스트를 스크롤할 수 있는 뷰
                GeometryReader { proxy in
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],  // 2열 그리드
                            spacing: 20
                        ) {
                            ForEach(postStore.posts) { post in
                                MatePostListCardView(post: post, proxy: proxy)  // 게시물 카드 뷰
                                    .onTapGesture {
                                        postStore.selectedPost = post  // 선택된 게시물 저장
                                        isPresentDetailView.toggle()  // 상세 뷰 표시
                                    }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
            .onAppear {
                // 뷰가 나타날 때 게시물 가져오기
                postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
            }
            .navigationBarTitleDisplayMode(.inline)  // 내비게이션 바 타이틀 설정
            .toolbar {
                // 내비게이션 바의 툴바 아이템 설정
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("돌봄")  // 툴바 제목
                            .font(.title2)
                            .bold()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isPresentAddView.toggle()  // 게시물 추가 뷰 표시
                    } label: {
                        Image(systemName: "square.and.pencil")  // 추가 버튼 아이콘
                            .font(.title2)
                    }
                }
            }
            .fullScreenCover(isPresented: $isPresentAddView) {
                MatePostAddView()  // 게시물 추가 뷰
            }
            .navigationDestination(isPresented: $isPresentDetailView) {
                MatePostDetailView()  // 게시물 상세 뷰
            }
        }
    }
    
    // 펫 종류에 따른 카테고리 버튼 생성
    private func categoryButton(title: String, category: String) -> some View {
        Button(action: {
            selectedPetCategory1 = category  // 선택된 펫 카테고리 업데이트
            // 선택된 카테고리에 따라 게시물 가져오기
            postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
        }) {
            HStack {
                Text(title)  // 버튼 텍스트
                    .font(.title3)
                    .bold()
                    .foregroundColor(selectedPetCategory1 == category ? .white : .brown)  // 선택된 카테고리에 따라 색상 변경
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(selectedPetCategory1 == category ? Color.brown : Color(UIColor(white: 0.95, alpha: 1)))  // 배경색 설정
                    .cornerRadius(30)  // 모서리 둥글게
                    .overlay(
                        selectedPetCategory1 == category ? nil : RoundedRectangle(cornerRadius: 30)  // 선택되지 않은 경우 테두리 추가
                            .stroke(Color.brown, lineWidth: 0.5)
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }
    
    // 크기 카테고리 버튼 생성 (각 버튼이 4분의 1씩 차지)
    private func sizeButton(title: String, category: String) -> some View {
        Button(action: {
            selectedPetCategory2 = category  // 선택된 크기 카테고리 업데이트
            // 선택된 카테고리에 따라 게시물 가져오기
            postStore.getPosts(postCategory: selectedPostCategory, petCategory1: selectedPetCategory1, petCategory2: selectedPetCategory2)
        }) {
            Text(title)  // 버튼 텍스트
                .foregroundColor(selectedPetCategory2 == category ? .white : .brown)  // 선택된 카테고리에 따라 색상 변경
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .bold()
                .background(selectedPetCategory2 == category ? Color.brown : Color(UIColor(white: 0.95, alpha: 1)))  // 배경색 설정
                .cornerRadius(30)  // 모서리 둥글게
                .overlay(
                    selectedPetCategory2 == category ? nil : RoundedRectangle(cornerRadius: 30)  // 선택되지 않은 경우 테두리 추가
                        .stroke(Color.brown, lineWidth: 0.5)
                )
        }
        .frame(maxWidth: .infinity)
    }

    // 크기 필터 옵션 - 펫 종류에 따라 변경
    private func sizeOptions() -> [String] {
        switch selectedPetCategory1 {
        case "cat":
            return ["대형묘", "중형묘", "소형묘", "아기"]  // 고양이 선택 시 크기 옵션
        case "other":
            return ["포유류", "파충류", "양서류", "조류"]  // 그 외 선택 시 크기 옵션
        default:
            return ["소형견", "중형견", "대형견", "아기"]  // 기본(강아지) 선택 시 크기 옵션
        }
    }
}

#Preview {
    MatePostListView()
        .environment(MatePostStore())  // 미리보기 환경 설정
}
