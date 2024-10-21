//
//  PetDetailView.swift
//  PetMate
//
//  Created by Mac on 10/15/24.
//

import SwiftUI
import FirebaseFirestore

// PetDetailView: 특정 펫의 상세 정보를 보여주는 뷰
struct MatePostDetailView: View {
    
    @Environment(MatePostStore.self) var postStore
    @State private var showChatView = false  // 채팅 뷰 표시 여부
    
    var body: some View {
        VStack(alignment: .leading) {
            if let writer = postStore.writer{ //작성자 정보가 불러와져야 함
                ScrollView {
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.black.opacity(0.3)).blur(radius: 2)
                            .padding()
                        VStack(alignment: .leading) {
                            ScrollView(.horizontal){
                                HStack(spacing: 10) {
                                    ForEach(postStore.pet){pet in
                                        ForEach(pet.images, id: \.self){image in
                                            MatePostDetailImageView(imageUrl: image)
                                                .frame(width: 300)
                                        }
                                    }
                                    
                                }
                            }
                            .padding()
                            .scrollIndicators(.hidden)
                            
                            ScrollView(.horizontal){
                                HStack(spacing: 10){
                                    ForEach(postStore.pet){ pet in
                                        MatePostDetailPetView(pet: pet)
                                    }
                                }
                            }
                            .padding()
                            .scrollIndicators(.hidden)
                            
                            if let post = postStore.selectedPost{
                                MatePostDetatilContentView(post: post)
                                    .padding()
                            }else{
                                Text("내용이 없습니다!")
                            }
                            MatePostDetailUserView(writer: writer)
                                .padding()
                            
                        }
                        .padding()
                    }
                }
                Spacer()
                // 채팅하기 버튼
                chatButton
            }else{
                ProgressView()
            }
        }
        .task{
            if let post = postStore.selectedPost {
                postStore.writer = await postStore.getUser(post.writeUser)
                await postStore.getPets()
            }
        }
        .navigationTitle(postStore.selectedPost?.title ?? "산책 해줘") // 네비게이션 타이틀 설정
    }
    
    // 채팅하기 버튼
    private var chatButton: some View {
        Button(action: {
            showChatView.toggle() // 채팅 뷰 표시 여부 토글
        }) {
            Text("채팅하기")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.brown)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .sheet(isPresented: $showChatView) {
            EmptyView() // 채팅 뷰 추가
        }
    }
    
    // 상대 시간 계산 함수
    func relativeTime(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        return minutes > 1 ? "\(minutes)분 전" : "방금 전"
    }
}

// 날짜 포맷터
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

//#Preview{
//    MatePostDetailView()
//        .environment(MatePostStore())
//}
